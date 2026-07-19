<?php

declare(strict_types=1);

namespace Shopkit\Themes\Tests;

use InvalidArgumentException;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;
use Shopkit\Themes\ThemeProject;

final class ThemeProjectTest extends TestCase
{
    private array $paths = [];

    protected function tearDown(): void
    {
        foreach (array_reverse($this->paths) as $path) {
            TestTheme::remove($path);
        }
    }

    public function testLoadsTheExistingFlatShopkitThemeShape(): void
    {
        $root = $this->theme();
        $project = new ThemeProject($root);

        self::assertSame(['base', 'home'], $project->pages());
        self::assertArrayHasKey('base.tpl', $project->templates());
        self::assertStringContainsString('template-vars.less', $project->less());
    }

    public function testKeepsTheOfficialStarterFixtureAfterTheThemeIsRenamed(): void
    {
        $root = TestTheme::create([
            'base.tpl' => "{#\nTemplate Name: My custom theme\nShopkit Starter: boxie\n#}<html>{% block content %}{% endblock %}</html>",
        ]);
        $this->paths[] = $root;

        self::assertSame('boxie', (new ThemeProject($root))->fixtureName());
    }

    #[DataProvider('publicThemes')]
    public function testAcceptsEveryPublicTheme(string $theme): void
    {
        $project = new ThemeProject(dirname(__DIR__).'/'.$theme);

        self::assertGreaterThanOrEqual(31, count($project->templates()));
        self::assertContains('home', $project->pages());
        self::assertContains('product', $project->pages());
    }

    public static function publicThemes(): array
    {
        return [['boxie'], ['default'], ['minimal'], ['mosaic']];
    }

    public function testRejectsSymlinks(): void
    {
        $root = $this->theme();
        $target = $root.'/target.tpl';
        file_put_contents($target, 'safe');

        if (!@symlink($target, $root.'/linked.tpl')) {
            self::markTestSkipped('Symlinks are unavailable on this platform.');
        }

        $this->expectException(InvalidArgumentException::class);
        $this->expectExceptionMessage('symbolic link');
        new ThemeProject($root);
    }

    public function testRejectsCaseInsensitiveFilenameCollisions(): void
    {
        $root = $this->theme();
        file_put_contents($root.'/Home.tpl', 'collision');

        if (fileinode($root.'/home.tpl') === fileinode($root.'/Home.tpl')) {
            self::markTestSkipped('Case-distinct filenames are unavailable on this filesystem.');
        }

        $this->expectException(InvalidArgumentException::class);
        $this->expectExceptionMessage('case-insensitive');
        new ThemeProject($root);
    }

    public function testRejectsInvalidUtf8Templates(): void
    {
        $root = $this->theme();
        file_put_contents($root.'/home.tpl', "\xC3\x28");

        $this->expectException(InvalidArgumentException::class);
        $this->expectExceptionMessage('UTF-8');
        new ThemeProject($root);
    }

    public function testRejectsUnexpectedNestedFiles(): void
    {
        $root = $this->theme();
        mkdir($root.'/private');
        file_put_contents($root.'/private/secret.txt', 'not part of a theme');

        $this->expectException(InvalidArgumentException::class);
        $this->expectExceptionMessage('not allowed');
        new ThemeProject($root);
    }

    public function testRejectsUnexpectedEmptyDirectories(): void
    {
        $root = $this->theme();
        mkdir($root.'/private');

        $this->expectException(InvalidArgumentException::class);
        $this->expectExceptionMessage('directory');
        new ThemeProject($root);
    }

    public function testRejectsSymbolicLinkAsThemeRoot(): void
    {
        $root = $this->theme();
        $link = $root.'-link';
        $this->paths[] = $link;

        if (!@symlink($root, $link)) {
            self::markTestSkipped('Symlinks are unavailable on this platform.');
        }

        $this->expectException(InvalidArgumentException::class);
        $this->expectExceptionMessage('symbolic link');
        new ThemeProject($link);
    }

    public function testRejectsNullBytesAndArchiveOrPolyglotFiles(): void
    {
        $root = $this->theme();

        try {
            new ThemeProject($root."\0/private");
            self::fail('A null byte must be rejected.');
        } catch (InvalidArgumentException $exception) {
            self::assertStringContainsString('null byte', $exception->getMessage());
        }

        file_put_contents($root.'/theme.zip', "PK\x03\x04<script>alert(1)</script>");
        $this->expectException(InvalidArgumentException::class);
        $this->expectExceptionMessage('not allowed');
        new ThemeProject($root);
    }

    public function testRejectsOversizedTemplateLessAndJavascriptFiles(): void
    {
        $cases = [
            ['home.tpl', 262_145, '256 KB'],
            ['css/style.less', 1_048_577, '1 MB'],
            ['js/script.js', 2_097_153, '2 MB'],
        ];

        foreach ($cases as [$file, $bytes, $message]) {
            $root = $this->theme();
            $directory = dirname($root.'/'.$file);
            if (!is_dir($directory)) {
                mkdir($directory, 0700, true);
            }
            file_put_contents($root.'/'.$file, str_repeat('x', $bytes));

            try {
                new ThemeProject($root);
                self::fail($file.' must exceed its quota.');
            } catch (InvalidArgumentException $exception) {
                self::assertStringContainsString($message, $exception->getMessage());
            }
        }
    }

    public function testRejectsTooManyFiles(): void
    {
        $root = $this->theme();
        for ($index = 0; $index < 101; ++$index) {
            file_put_contents($root.'/page-'.$index.'.tpl', 'safe');
        }

        $this->expectException(InvalidArgumentException::class);
        $this->expectExceptionMessage('too many');
        new ThemeProject($root);
    }

    public function testRejectsThemesOverTheTotalSizeQuota(): void
    {
        $root = $this->theme();
        for ($index = 0; $index < 43; ++$index) {
            file_put_contents($root.'/large-'.$index.'.tpl', str_repeat('x', 250_000));
        }

        $this->expectException(InvalidArgumentException::class);
        $this->expectExceptionMessage('10 MB');
        new ThemeProject($root);
    }

    public function testRejectsInvalidUtf8InLessAndJavascript(): void
    {
        foreach (['css/style.less', 'js/script.js'] as $file) {
            $root = $this->theme();
            $directory = dirname($root.'/'.$file);
            if (!is_dir($directory)) {
                mkdir($directory, 0700, true);
            }
            file_put_contents($root.'/'.$file, "\xC3\x28");

            try {
                new ThemeProject($root);
                self::fail($file.' must be valid UTF-8.');
            } catch (InvalidArgumentException $exception) {
                self::assertStringContainsString('UTF-8', $exception->getMessage());
            }
        }
    }

    public function testRejectsSpecialFilesWithoutReadingThem(): void
    {
        if (!function_exists('posix_mkfifo')) {
            self::markTestSkipped('FIFO creation is unavailable on this platform.');
        }

        $root = $this->theme();
        $fifo = $root.'/fifo.tpl';
        if (!posix_mkfifo($fifo, 0600)) {
            self::markTestSkipped('FIFO creation failed on this platform.');
        }

        $this->expectException(InvalidArgumentException::class);
        $this->expectExceptionMessage('non-regular');
        new ThemeProject($root);
    }

    private function theme(): string
    {
        $root = TestTheme::create();
        $this->paths[] = $root;
        return $root;
    }
}
