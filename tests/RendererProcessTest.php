<?php

declare(strict_types=1);

namespace Shopkit\Themes\Tests;

use PHPUnit\Framework\TestCase;
use RuntimeException;
use Shopkit\Themes\RendererProcess;
use Shopkit\Themes\ThemeProject;

final class RendererProcessTest extends TestCase
{
    private array $paths = [];

    protected function tearDown(): void
    {
        foreach (array_reverse($this->paths) as $path) {
            TestTheme::remove($path);
        }
    }

    public function testRendersAndCompilesInAnIsolatedPhpProcess(): void
    {
        $root = $this->theme([
            'home.tpl' => "{% extends 'base.tpl' %}{% block content %}{{ products('limit:1')[0].title }}{% endblock %}",
        ]);
        $process = new RendererProcess(dirname(__DIR__));
        $project = new ThemeProject($root);

        $html = $process->render($project, 'home', '/token');
        $css = $process->compileCss($project);

        self::assertStringContainsString('Produto de exemplo', $html);
        self::assertStringContainsString('body', $css);
        self::assertSame([], $process->check($project));
    }

    public function testFailsClosedWhenTheIsolatedPhpRuntimeIsUnavailable(): void
    {
        $root = $this->theme();
        $process = new RendererProcess(dirname(__DIR__), '/definitely/missing/php');

        $this->expectException(RuntimeException::class);
        $process->render(new ThemeProject($root), 'home', '/token');
    }

    public function testStopsMemoryAmplificationWithoutCrashingTheCliProcess(): void
    {
        $root = $this->theme([
            'home.tpl' => "{% for item in range(0, 100000000) %}x{% endfor %}",
        ]);
        $started = microtime(true);

        try {
            (new RendererProcess(dirname(__DIR__)))->render(new ThemeProject($root), 'home', '/token');
            self::fail('The renderer must reject amplified output.');
        } catch (RuntimeException $exception) {
            self::assertLessThan(12.0, microtime(true) - $started);
            self::assertStringNotContainsString('Stack trace', $exception->getMessage());
        }
    }

    public function testStopsRecursiveLessWithoutAParentProcessCrash(): void
    {
        $root = $this->theme([], "@import \"template-vars.less\";\n.loop() { .loop(); }\n.preview { .loop(); }");
        $started = microtime(true);

        try {
            (new RendererProcess(dirname(__DIR__)))->compileCss(new ThemeProject($root));
            self::fail('The renderer must stop recursive LESS.');
        } catch (RuntimeException $exception) {
            self::assertLessThan(12.0, microtime(true) - $started);
            self::assertStringNotContainsString('Stack trace', $exception->getMessage());
        }
    }

    public function testRejectsFilesystemFunctionAliasesInsideTheWorker(): void
    {
        $root = $this->theme([], "@import \"template-vars.less\";\n.preview { value: datauri(\"composer.json\"); }");

        $this->expectException(RuntimeException::class);
        $this->expectExceptionMessage('forbidden filesystem');

        (new RendererProcess(dirname(__DIR__)))->compileCss(new ThemeProject($root));
    }

    public function testWorkerOutputIsBoundedWhileItIsBeingRead(): void
    {
        $package = sys_get_temp_dir().'/shopkit-renderer-package-'.bin2hex(random_bytes(8));
        mkdir($package.'/resources', 0700, true);
        mkdir($package.'/vendor', 0700, true);
        file_put_contents($package.'/vendor/autoload.php', "<?php\n");
        file_put_contents($package.'/resources/renderer-worker.php', <<<'PHP'
<?php
for ($index = 0; $index < 1_024; ++$index) {
    fwrite(STDOUT, str_repeat('x', 65_536));
}
PHP
        );
        $this->paths[] = $package;
        $theme = $this->theme();

        $runner = sprintf(
            <<<'PHP'
require %s;
try {
    (new Shopkit\Themes\RendererProcess(%s))->render(
        new Shopkit\Themes\ThemeProject(%s),
        'home',
        '/preview'
    );
} catch (RuntimeException $exception) {
    if (str_contains($exception->getMessage(), 'output limit')) {
        fwrite(STDOUT, 'bounded');
        exit(0);
    }
}
exit(2);
PHP,
            var_export(dirname(__DIR__).'/vendor/autoload.php', true),
            var_export($package, true),
            var_export($theme, true)
        );

        $pipes = [];
        $process = proc_open([
            PHP_BINARY,
            '-d',
            'memory_limit=32M',
            '-r',
            $runner,
        ], [
            0 => ['pipe', 'r'],
            1 => ['pipe', 'w'],
            2 => ['pipe', 'w'],
        ], $pipes, dirname(__DIR__));
        self::assertIsResource($process);
        fclose($pipes[0]);
        $stdout = stream_get_contents($pipes[1]);
        $stderr = stream_get_contents($pipes[2]);
        fclose($pipes[1]);
        fclose($pipes[2]);

        self::assertSame(0, proc_close($process), $stderr ?: 'Bounded reader subprocess failed.');
        self::assertSame('bounded', $stdout);
    }

    private function theme(array $templates = [], ?string $less = null): string
    {
        $root = TestTheme::create($templates, $less);
        $this->paths[] = $root;
        return $root;
    }
}
