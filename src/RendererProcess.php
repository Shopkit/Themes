<?php

declare(strict_types=1);

namespace Shopkit\Themes;

use JsonException;
use RuntimeException;
use Throwable;

final class RendererProcess
{
    private const MAX_PROCESS_OUTPUT_BYTES = 6_291_456;
    private const TIMEOUT_SECONDS = 8.0;

    private string $packageRoot;
    private string $phpBinary;
    private string $autoload;

    public function __construct(string $packageRoot, ?string $phpBinary = null)
    {
        $root = realpath($packageRoot);
        if ($root === false || !is_dir($root)) {
            throw new RuntimeException('Renderer package root is unavailable.');
        }

        $this->packageRoot = $root;
        $this->phpBinary = $phpBinary ?? PHP_BINARY;
        $this->autoload = $this->findAutoload($root);
    }

    public function render(ThemeProject $project, string $page, string $assetBase): string
    {
        $result = $this->run($project, 'render', [
            'page' => $page,
            'asset_base' => $assetBase,
        ]);

        if (!is_string($result)) {
            throw new RuntimeException('Renderer returned an invalid HTML response.');
        }

        return $result;
    }

    public function compileCss(ThemeProject $project): string
    {
        $result = $this->run($project, 'css');
        if (!is_string($result)) {
            throw new RuntimeException('Renderer returned an invalid CSS response.');
        }

        return $result;
    }

    public function check(ThemeProject $project): array
    {
        $result = $this->run($project, 'check');
        if (!is_array($result) || array_filter($result, 'is_string') !== $result) {
            throw new RuntimeException('Renderer returned an invalid validation response.');
        }

        return array_values($result);
    }

    private function run(ThemeProject $project, string $operation, array $parameters = []): mixed
    {
        foreach (['proc_open', 'proc_get_status', 'proc_terminate', 'proc_close'] as $function) {
            if (!function_exists($function)) {
                throw new RuntimeException('The isolated renderer requires PHP process functions.');
            }
        }

        $worker = $this->packageRoot.'/resources/renderer-worker.php';
        if (!is_file($worker) || !is_file($this->autoload)) {
            throw new RuntimeException('Isolated renderer is unavailable.');
        }

        $payload = json_encode([
            'operation' => $operation,
            'theme_root' => $project->root(),
        ] + $parameters, JSON_THROW_ON_ERROR);

        $openBaseDir = implode(PATH_SEPARATOR, array_unique([
            $this->packageRoot,
            $project->root(),
            dirname($this->autoload),
        ]));

        $disabled = implode(',', [
            'exec', 'passthru', 'shell_exec', 'system', 'proc_open', 'popen',
            'pcntl_exec', 'pcntl_fork', 'dl', 'curl_exec', 'curl_multi_exec',
            'fsockopen', 'pfsockopen', 'stream_socket_client',
            'stream_socket_server', 'stream_socket_sendto', 'socket_create',
            'socket_connect', 'socket_bind', 'socket_listen', 'socket_accept',
            'socket_send', 'socket_sendto', 'socket_write', 'dns_get_record',
            'gethostbyname', 'gethostbynamel', 'getmxrr', 'ftp_connect',
            'ftp_ssl_connect', 'mail', 'putenv',
        ]);

        $command = [
            $this->phpBinary,
            '-d', 'allow_url_fopen=0',
            '-d', 'allow_url_include=0',
            '-d', 'auto_append_file=',
            '-d', 'auto_prepend_file=',
            '-d', 'display_errors=stderr',
            '-d', 'expose_php=0',
            '-d', 'ffi.enable=0',
            '-d', 'html_errors=0',
            '-d', 'log_errors=0',
            '-d', 'max_input_time=1',
            '-d', 'max_execution_time=5',
            '-d', 'memory_limit=192M',
            '-d', 'sys_temp_dir=/nonexistent',
            '-d', 'open_basedir='.$openBaseDir,
            '-d', 'disable_functions='.$disabled,
            $worker,
        ];

        $environment = [
            'HOME' => '/nonexistent',
            'LANG' => 'C',
            'LC_ALL' => 'C',
            'PATH' => '/usr/bin:/bin',
            'TMPDIR' => '/nonexistent',
            'SHOPKIT_THEMES_AUTOLOAD' => $this->autoload,
        ];
        if (isset($_SERVER['SystemRoot']) && is_string($_SERVER['SystemRoot'])) {
            $environment['SystemRoot'] = $_SERVER['SystemRoot'];
        }

        $pipes = [];
        $process = @proc_open($command, [
            0 => ['pipe', 'r'],
            1 => ['pipe', 'w'],
            2 => ['pipe', 'w'],
        ], $pipes, $project->root(), $environment);

        if (!is_resource($process)) {
            throw new RuntimeException('Isolated renderer could not be started.');
        }

        $stdout = '';
        $stderr = '';
        $exitCode = -1;
        $terminated = false;

        try {
            $this->writePayload($pipes[0], $payload);
            fclose($pipes[0]);
            stream_set_blocking($pipes[1], false);
            stream_set_blocking($pipes[2], false);

            $deadline = microtime(true) + self::TIMEOUT_SECONDS;
            while (true) {
                if (!$this->readWithinBudget(
                    $pipes[1],
                    $stdout,
                    self::MAX_PROCESS_OUTPUT_BYTES - strlen($stderr)
                ) || !$this->readWithinBudget(
                    $pipes[2],
                    $stderr,
                    self::MAX_PROCESS_OUTPUT_BYTES - strlen($stdout)
                )) {
                    $terminated = true;
                    proc_terminate($process, 9);
                    throw new RuntimeException('Isolated renderer exceeded its output limit.');
                }

                $status = proc_get_status($process);
                if (!$status['running']) {
                    $exitCode = $status['exitcode'];
                    break;
                }

                if (microtime(true) >= $deadline) {
                    $terminated = true;
                    proc_terminate($process, 9);
                    throw new RuntimeException('Isolated renderer exceeded its time limit.');
                }

                usleep(10_000);
            }

            stream_set_blocking($pipes[1], true);
            stream_set_blocking($pipes[2], true);
            if (!$this->readWithinBudget(
                $pipes[1],
                $stdout,
                self::MAX_PROCESS_OUTPUT_BYTES - strlen($stderr)
            ) || !$this->readWithinBudget(
                $pipes[2],
                $stderr,
                self::MAX_PROCESS_OUTPUT_BYTES - strlen($stdout)
            )) {
                throw new RuntimeException('Isolated renderer exceeded its output limit.');
            }
        } finally {
            foreach ([1, 2] as $index) {
                if (isset($pipes[$index]) && is_resource($pipes[$index])) {
                    fclose($pipes[$index]);
                }
            }
            if ($terminated) {
                @proc_terminate($process, 9);
            }
            $closedCode = proc_close($process);
            if ($exitCode < 0 && $closedCode >= 0) {
                $exitCode = $closedCode;
            }
        }

        if (strlen($stdout) > self::MAX_PROCESS_OUTPUT_BYTES) {
            throw new RuntimeException('Isolated renderer exceeded its output limit.');
        }

        try {
            $response = json_decode($stdout, true, 16, JSON_THROW_ON_ERROR);
        } catch (JsonException) {
            throw new RuntimeException('Isolated renderer failed safely.');
        }

        if (!is_array($response) || ($response['ok'] ?? false) !== true || $exitCode !== 0) {
            $message = is_array($response) && is_string($response['error'] ?? null)
                ? $this->safeMessage($response['error'])
                : 'Isolated renderer failed safely.';
            throw new RuntimeException($message);
        }

        return $response['result'] ?? null;
    }

    /** @param resource $stream */
    private function writePayload($stream, string $payload): void
    {
        $offset = 0;
        $length = strlen($payload);
        while ($offset < $length) {
            $written = fwrite($stream, substr($payload, $offset));
            if ($written === false || $written === 0) {
                throw new RuntimeException('Isolated renderer input could not be written.');
            }
            $offset += $written;
        }
    }

    /** @param resource $stream */
    private function readWithinBudget($stream, string &$buffer, int $budget): bool
    {
        if ($budget < strlen($buffer)) {
            return false;
        }

        while (true) {
            $remaining = $budget - strlen($buffer);
            $chunk = fread($stream, min(65_536, $remaining + 1));
            if ($chunk === false || $chunk === '') {
                return true;
            }
            if (strlen($chunk) > $remaining) {
                return false;
            }
            $buffer .= $chunk;
        }
    }

    private function findAutoload(string $root): string
    {
        foreach ([
            $root.'/vendor/autoload.php',
            dirname($root, 2).'/autoload.php',
        ] as $candidate) {
            $path = realpath($candidate);
            if ($path !== false && is_file($path)) {
                return $path;
            }
        }

        throw new RuntimeException('Composer autoloader is unavailable.');
    }

    private function safeMessage(string $message): string
    {
        $message = preg_replace('/[\r\n\t]+/', ' ', $message) ?? '';
        $message = preg_replace('#(?:[A-Za-z]:)?[/\\\\](?:[^\s:]+[/\\\\])+[^\s:]+#', '[path]', $message) ?? '';
        return substr(trim($message), 0, 500);
    }
}
