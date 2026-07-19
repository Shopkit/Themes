<?php

declare(strict_types=1);

namespace Shopkit\Themes\Tests;

use PHPUnit\Framework\TestCase;

final class BinaryTest extends TestCase
{
    public function testBinaryRunsOutsideTheRepositoryWithoutPrivateConfiguration(): void
    {
        [$status, $stdout, $stderr] = $this->execute([
            PHP_BINARY,
            dirname(__DIR__).'/bin/shopkit-themes',
            '--version',
        ], sys_get_temp_dir());

        self::assertSame(0, $status);
        self::assertSame("shopkit-themes 1.0.0\n", $stdout);
        self::assertSame('', $stderr);
    }

    public function testCheckExplainsWhenPhpProcessFunctionsAreDisabled(): void
    {
        [$status, $stdout, $stderr] = $this->execute([
            PHP_BINARY,
            '-d',
            'disable_functions=proc_open',
            dirname(__DIR__).'/bin/shopkit-themes',
            'check',
            dirname(__DIR__).'/default',
        ], sys_get_temp_dir());

        self::assertSame(1, $status);
        self::assertSame('', $stdout);
        self::assertStringContainsString('requires PHP process functions', $stderr);
        self::assertStringNotContainsString('Stack trace', $stderr);
    }

    public function testServeExplainsWhenLocalSocketFunctionsAreDisabled(): void
    {
        [$status, $stdout, $stderr] = $this->execute([
            PHP_BINARY,
            '-d',
            'disable_functions=stream_socket_client',
            dirname(__DIR__).'/bin/shopkit-themes',
            'serve',
            dirname(__DIR__).'/default',
        ], sys_get_temp_dir());

        self::assertSame(1, $status);
        self::assertSame('', $stdout);
        self::assertStringContainsString('requires PHP local socket functions', $stderr);
        self::assertStringNotContainsString('Stack trace', $stderr);
    }

    private function execute(array $command, string $workingDirectory): array
    {
        $pipes = [];
        $process = proc_open($command, [
            0 => ['pipe', 'r'],
            1 => ['pipe', 'w'],
            2 => ['pipe', 'w'],
        ], $pipes, $workingDirectory, [
            'HOME' => sys_get_temp_dir(),
            'PATH' => getenv('PATH') ?: '/usr/bin:/bin',
        ]);

        self::assertIsResource($process);
        fclose($pipes[0]);
        $stdout = stream_get_contents($pipes[1]);
        $stderr = stream_get_contents($pipes[2]);
        fclose($pipes[1]);
        fclose($pipes[2]);

        return [proc_close($process), $stdout, $stderr];
    }
}
