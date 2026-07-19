<?php

declare(strict_types=1);

namespace Shopkit\Themes;

use Less_Parser;
use RuntimeException;
use Throwable;
use Twig\Environment;
use Twig\Extension\SandboxExtension;
use Twig\Loader\ArrayLoader;
use Twig\Sandbox\SecurityPolicy;

final class Renderer
{
    private const VIRTUAL_IMPORT_PATTERN = '/^\h*@import\h+"template-vars\.less"\h*;\h*\r?$/m';

    private const TAGS = [
        'block', 'extends', 'for', 'from', 'if', 'import', 'include', 'macro', 'set',
    ];

    private const FILTERS = [
        'column', 'date', 'date_modify', 'default', 'e', 'escape', 'e_attr', 'filter',
        'first', 'first_word', 'format', 'format_datetime', 'join', 'json_decode',
        'json_encode', 'keys', 'last', 'length', 'lower', 'merge', 'money_with_sign',
        'money_without_trailing_zeros', 'nl2br', 'replace', 'rewards_label',
        'rewards_message', 'round', 'shuffle', 'slice', 'slug', 'split', 't',
        'url_encode',
    ];

    private const FUNCTIONS = [
        'assets_url', 'blog_posts', 'brands', 'categories', 'category', 'date',
        'character_limiter', 'current_url', 'form_close', 'form_open',
        'form_open_cart', 'icons', 'line_break', 'md5', 'page', 'pages',
        'min', 'pagination', 'price_range', 'product', 'products', 'range', 'reviews',
        'safe_mailto', 'site_url', 'tags', 'word_limiter',
    ];

    private const TESTS = ['defined', 'empty', 'null', 'same as'];

    private Fixtures $fixtures;

    public function __construct(?Fixtures $fixtures = null)
    {
        $this->fixtures = $fixtures ?? new Fixtures();
    }

    public function render(ThemeProject $project, string $page, string $assetBase): string
    {
        if (preg_match('/\A[a-z0-9][a-z0-9-]*\z/D', $page) !== 1) {
            throw new RuntimeException('Invalid theme page.');
        }

        $template = $page.'.tpl';
        if (!array_key_exists($template, $project->templates())) {
            throw new RuntimeException('Theme page does not exist.');
        }

        if (preg_match('#\A/[a-zA-Z0-9/_-]+\z#D', $assetBase) !== 1) {
            throw new RuntimeException('Invalid preview asset path.');
        }

        try {
            $context = $this->fixtures->context($project->fixtureName(), $assetBase);
            $context['current_page'] = $page;
            $html = $this->environment($project, $assetBase)->render($template, $context);
        } catch (Throwable $exception) {
            throw new RuntimeException('Theme could not be rendered: '.$this->safeMessage($exception), 0, $exception);
        }

        if (strlen($html) > PreviewServer::MAX_PREVIEW_BYTES) {
            throw new RuntimeException('Rendered theme exceeds the 2 MB output limit.');
        }

        return $html;
    }

    public function check(ThemeProject $project): array
    {
        $errors = [];
        $environment = $this->environment($project, '/preview');
        $context = $this->fixtures->context($project->fixtureName(), '/preview');

        foreach (array_keys($project->templates()) as $template) {
            try {
                $environment->load($template);
                $context['current_page'] = substr($template, 0, -4);
                $html = $environment->render($template, $context);
                if (strlen($html) > PreviewServer::MAX_PREVIEW_BYTES) {
                    throw new RuntimeException('Rendered theme exceeds the 2 MB output limit.');
                }
            } catch (Throwable $exception) {
                $errors[] = $template.': '.$this->safeMessage($exception);
            }
        }

        return $errors;
    }

    public function compileCss(ThemeProject $project): string
    {
        $less = $project->less();
        $this->assertSafeLess($less);

        $variables = $this->fixtures->templateVariables($project->fixtureName());
        $less = preg_replace(self::VIRTUAL_IMPORT_PATTERN, $variables, $less, 1, $count);
        if ($less === null || $count !== 1) {
            throw new RuntimeException('css/style.less must import template-vars.less exactly once.');
        }

        try {
            $parser = new Less_Parser([
                'compress' => false,
                'relativeUrls' => false,
            ]);
            $parser->parse($less);
            $css = $parser->getCss();
        } catch (Throwable $exception) {
            throw new RuntimeException('LESS could not be compiled: '.$this->safeMessage($exception), 0, $exception);
        }

        if (strlen($css) > PreviewServer::MAX_PREVIEW_BYTES) {
            throw new RuntimeException('Compiled CSS exceeds the 2 MB output limit.');
        }

        return $css;
    }

    private function environment(ThemeProject $project, string $assetBase): Environment
    {
        $environment = new Environment(new ArrayLoader($project->templates()), [
            'autoescape' => false,
            'cache' => false,
            'debug' => false,
            'strict_variables' => false,
        ]);
        $environment->addExtension(new ShopkitExtension($this->fixtures, $assetBase));

        $policy = new SecurityPolicy(self::TAGS, self::FILTERS, [], [], self::FUNCTIONS, self::TESTS);
        $policy->setStrict(true);
        $environment->addExtension(new SandboxExtension($policy, true));

        return $environment;
    }

    private function assertSafeLess(string $less): void
    {
        if (preg_match('/@plugin\b|\b(?:data-?uri|image-?(?:size|width|height))\s*\(|`/i', $less) === 1) {
            throw new RuntimeException('LESS contains a forbidden filesystem or code capability.');
        }

        $withoutVirtualImport = preg_replace(
            self::VIRTUAL_IMPORT_PATTERN,
            '',
            $less,
            -1,
            $count
        );

        if ($withoutVirtualImport === null || $count !== 1 || preg_match('/@import\b/i', $withoutVirtualImport) === 1) {
            throw new RuntimeException('LESS may only import template-vars.less exactly once.');
        }
    }

    private function safeMessage(Throwable $exception): string
    {
        $message = preg_replace('/[\r\n\t]+/', ' ', $exception->getMessage()) ?? '';
        $message = preg_replace('#(?:[A-Za-z]:)?[/\\\\](?:[^\s:]+[/\\\\])+[^\s:]+#', '[path]', $message) ?? '';
        $message = trim($message);

        return substr($message === '' ? 'Invalid theme source.' : $message, 0, 500);
    }
}
