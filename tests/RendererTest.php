<?php

declare(strict_types=1);

namespace Shopkit\Themes\Tests;

use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;
use RuntimeException;
use Shopkit\Themes\Renderer;
use Shopkit\Themes\PreviewServer;
use Shopkit\Themes\ThemeProject;

final class RendererTest extends TestCase
{
    private array $paths = [];

    protected function tearDown(): void
    {
        foreach (array_reverse($this->paths) as $path) {
            TestTheme::remove($path);
        }
    }

    public function testRendersShopkitHelpersWithDeterministicDummyData(): void
    {
        $root = $this->theme([
            'home.tpl' => "{% extends 'base.tpl' %}{% block content %}{% for item in products('limit:2') %}<b>{{ item.title }}</b><img src=\"{{ item.image.full }}\">{% endfor %}<img src=\"{{ assets_url('assets/store/img/no-img.png') }}\">{{ 12.5|money_with_sign }}{% endblock %}",
        ]);

        $html = (new Renderer())->render(new ThemeProject($root), 'home', '/preview-token');

        self::assertStringContainsString('Produto de exemplo', $html);
        self::assertStringContainsString('12,50', $html);
        self::assertStringContainsString('/preview-token/__theme/style.css', $html);
        self::assertStringContainsString('/preview-token/__theme/placeholder.svg', $html);
        self::assertStringNotContainsString('/preview-token/assets/', $html);
    }

    #[DataProvider('forbiddenTwig')]
    public function testSandboxRejectsDangerousTwig(string $source): void
    {
        $root = $this->theme(['home.tpl' => $source]);

        $this->expectException(RuntimeException::class);
        (new Renderer())->render(new ThemeProject($root), 'home', '/preview');
    }

    public static function forbiddenTwig(): array
    {
        return [
            'shell function' => ["{{ system('id') }}"],
            'constant function' => ["{{ constant('PHP_VERSION') }}"],
            'source function' => ["{{ source('base.tpl') }}"],
            'dynamic attribute' => ["{{ attribute(_context, 'PATH') }}"],
            'method on allowed date object' => ["{{ date('now').format('c') }}"],
            'method on template object' => ["{{ _self.getSourceContext() }}"],
            'filesystem traversal' => ["{% extends '../../etc/passwd' %}"],
        ];
    }

    public function testCompilesTheSingleVirtualLessImport(): void
    {
        $root = $this->theme([], "@import \"template-vars.less\";\n.preview { color: @basecolor; }");

        $css = (new Renderer())->compileCss(new ThemeProject($root));

        self::assertStringContainsString('.preview', $css);
        self::assertStringNotContainsString('@basecolor', $css);
    }

    public function testCompilesTheVirtualLessImportWithWindowsLineEndings(): void
    {
        $root = $this->theme([], "@import \"template-vars.less\";\r\n.preview { color: @basecolor; }\r\n");

        $css = (new Renderer())->compileCss(new ThemeProject($root));

        self::assertStringContainsString('.preview', $css);
    }

    public function testIncludesOnlyTemplatesFromTheValidatedThemeMap(): void
    {
        $root = $this->theme([
            'home.tpl' => "{% extends 'base.tpl' %}{% block content %}{% include 'card.tpl' %}{% endblock %}",
            'card.tpl' => '<p>Local partial</p>',
        ]);

        $html = (new Renderer())->render(new ThemeProject($root), 'home', '/preview');

        self::assertStringContainsString('Local partial', $html);
    }

    public function testCheckReportsRuntimeErrorsInsteadOfOnlyParsingTemplates(): void
    {
        $root = $this->theme(['home.tpl' => '{{ 1 / 0 }}']);

        $errors = (new Renderer())->check(new ThemeProject($root));

        self::assertNotSame([], $errors);
        self::assertStringContainsString('home.tpl', implode("\n", $errors));
    }

    public function testCheckRejectsOutputThatThePreviewCannotServe(): void
    {
        $root = $this->theme([
            'home.tpl' => '{% for item in range(1, 300000) %}<i></i>{% endfor %}',
        ]);

        $errors = (new Renderer())->check(new ThemeProject($root));

        self::assertNotSame([], $errors);
        self::assertStringContainsString('2 MB output limit', implode("\n", $errors));
    }

    #[DataProvider('publicThemes')]
    public function testOfficialHomePreviewUsesReadableLabelsInsteadOfTranslationKeys(string $theme): void
    {
        $project = new ThemeProject(dirname(__DIR__).'/'.$theme);

        $html = (new Renderer())->render($project, 'home', '/preview');

        self::assertStringNotContainsString('lang.storefront.', $html);
    }

    #[DataProvider('dangerousLess')]
    public function testRejectsLessFilesystemAndCodeCapabilities(string $less): void
    {
        $root = $this->theme([], $less);

        $this->expectException(RuntimeException::class);
        (new Renderer())->compileCss(new ThemeProject($root));
    }

    public static function dangerousLess(): array
    {
        return [
            'traversal import' => ['@import "../../secret.less";'],
            'remote import' => ['@import "https://example.com/theme.less";'],
            'absolute import' => ['@import "/etc/passwd";'],
            'plugin' => ['@plugin "plugin.js";'],
            'file embedding' => ['.x { background: data-uri("/etc/passwd"); }'],
        ];
    }

    #[DataProvider('lessFilesystemAliases')]
    public function testRejectsEveryLessFilesystemFunctionAlias(string $function): void
    {
        $root = $this->theme([], sprintf(
            "@import \"template-vars.less\";\n.preview { value: %s(\"composer.json\"); }",
            $function
        ));

        $this->expectException(RuntimeException::class);
        $this->expectExceptionMessage('forbidden filesystem');

        (new Renderer())->compileCss(new ThemeProject($root));
    }

    public static function lessFilesystemAliases(): array
    {
        return [
            ['data-uri'],
            ['datauri'],
            ['image-size'],
            ['imagesize'],
            ['image-width'],
            ['imagewidth'],
            ['image-height'],
            ['imageheight'],
        ];
    }

    #[DataProvider('publicThemes')]
    public function testParsesAndCompilesEveryPublicTheme(string $theme): void
    {
        $project = new ThemeProject(dirname(__DIR__).'/'.$theme);
        $renderer = new Renderer();

        self::assertSame([], $renderer->check($project));
        self::assertGreaterThan(1000, strlen($renderer->compileCss($project)));
    }

    #[DataProvider('publicThemes')]
    public function testRendersEveryPageOfEveryPublicTheme(string $theme): void
    {
        $project = new ThemeProject(dirname(__DIR__).'/'.$theme);
        $renderer = new Renderer();

        foreach ($project->pages() as $page) {
            $html = $renderer->render($project, $page, '/preview');
            self::assertLessThanOrEqual(PreviewServer::MAX_PREVIEW_BYTES, strlen($html), $theme.'/'.$page);
            self::assertStringNotContainsString('lang.storefront.', $html, $theme.'/'.$page);
        }
    }

    public static function publicThemes(): array
    {
        return [['boxie'], ['default'], ['minimal'], ['mosaic']];
    }

    private function theme(array $templates = [], ?string $less = null): string
    {
        $root = TestTheme::create($templates, $less);
        $this->paths[] = $root;
        return $root;
    }
}
