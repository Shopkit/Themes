<?php

declare(strict_types=1);

namespace Shopkit\Themes;

use FilesystemIterator;
use InvalidArgumentException;
use RecursiveDirectoryIterator;
use RecursiveIteratorIterator;
use RuntimeException;
use Throwable;

final class Application
{
    public const VERSION = '1.0.0';

    /** @var resource */
    private $output;

    /** @var resource */
    private $error;

    private string $packageRoot;

    public function __construct($output, $error, string $packageRoot)
    {
        if (!is_resource($output) || !is_resource($error)) {
            throw new InvalidArgumentException('CLI output streams are required.');
        }

        $root = realpath($packageRoot);
        if ($root === false || !is_dir($root)) {
            throw new InvalidArgumentException('Package root does not exist.');
        }

        $this->output = $output;
        $this->error = $error;
        $this->packageRoot = $root;
    }

    public function run(array $arguments): int
    {
        $command = $arguments[1] ?? '--help';

        try {
            return match ($command) {
                '--help', '-h', 'help' => $this->help(),
                '--version', '-V', 'version' => $this->version(),
                'new' => $this->create($arguments),
                'check' => $this->check($arguments),
                'serve' => $this->serve($arguments),
                default => $this->usageError(sprintf('Unknown command: %s', $this->safeArgument($command))),
            };
        } catch (InvalidArgumentException|RuntimeException $exception) {
            $this->write($this->error, 'Error: '.$this->safeError($exception).PHP_EOL);
            return 1;
        } catch (Throwable) {
            $this->write($this->error, 'Error: The command could not be completed.'.PHP_EOL);
            return 1;
        }
    }

    private function help(): int
    {
        $this->write($this->output, <<<'HELP'
Shopkit Themes — local theme development

Usage:
  shopkit-themes new <directory> [default|boxie|minimal|mosaic]
  shopkit-themes check <theme-directory>
  shopkit-themes serve <theme-directory> [--page=home] [--port=4173]

No Shopkit account, private codebase, Docker, or external service is required.
HELP
        );
        $this->write($this->output, PHP_EOL);
        return 0;
    }

    private function version(): int
    {
        $this->write($this->output, 'shopkit-themes '.self::VERSION.PHP_EOL);
        return 0;
    }

    private function create(array $arguments): int
    {
        if (!isset($arguments[2]) || isset($arguments[4])) {
            return $this->usageError('Usage: shopkit-themes new <directory> [default|boxie|minimal|mosaic]');
        }

        $destination = $arguments[2];
        $starter = $arguments[3] ?? 'default';
        if (!in_array($starter, ['default', 'boxie', 'minimal', 'mosaic'], true)) {
            throw new InvalidArgumentException('Unknown official theme.');
        }
        if ($destination === '' || str_contains($destination, "\0")) {
            throw new InvalidArgumentException('Invalid destination directory.');
        }
        if (file_exists($destination) || is_link($destination)) {
            throw new InvalidArgumentException('Destination already exists.');
        }

        $source = $this->packageRoot.'/'.$starter;
        new ThemeProject($source);

        if (!mkdir($destination, 0755, true)) {
            throw new RuntimeException('Destination directory could not be created.');
        }

        try {
            $destinationRoot = realpath($destination);
            if ($destinationRoot === false
                || $destinationRoot === $source
                || str_starts_with($destinationRoot, $source.DIRECTORY_SEPARATOR)) {
                throw new InvalidArgumentException('Destination must not be inside the official theme source.');
            }

            $iterator = new RecursiveIteratorIterator(
                new RecursiveDirectoryIterator($source, FilesystemIterator::SKIP_DOTS),
                RecursiveIteratorIterator::SELF_FIRST
            );
            foreach ($iterator as $item) {
                $relative = substr($item->getPathname(), strlen($source) + 1);
                $target = $destination.DIRECTORY_SEPARATOR.$relative;
                if ($item->isDir()) {
                    if (!mkdir($target, 0755) && !is_dir($target)) {
                        throw new RuntimeException('Theme directory could not be copied.');
                    }
                    continue;
                }
                if (!$item->isFile() || $item->isLink() || !copy($item->getPathname(), $target)) {
                    throw new RuntimeException('Theme file could not be copied.');
                }
            }

            foreach ([
                $this->packageRoot.'/LICENSE' => $destination.'/LICENSE',
                $this->packageRoot.'/LICENSES/Apache-2.0.txt' => $destination.'/LICENSE-APACHE-2.0.txt',
            ] as $document => $target) {
                if (!is_file($document) || !copy($document, $target)) {
                    throw new RuntimeException('Theme license notices could not be copied.');
                }
            }

            if (file_put_contents(
                $destination.'/THIRD_PARTY_NOTICES.md',
                $this->themeThirdPartyNotices($starter),
                LOCK_EX
            ) === false) {
                throw new RuntimeException('Theme license notices could not be copied.');
            }
        } catch (Throwable $exception) {
            $this->removeDirectory($destination);
            throw $exception;
        }

        $this->write($this->output, sprintf('Theme created in %s%s', $destination, PHP_EOL));
        if ($starter === 'mosaic') {
            $this->write(
                $this->output,
                'Notice: Mosaic includes Isotope with separate commercial-use terms; read THIRD_PARTY_NOTICES.md.'.PHP_EOL
            );
        }
        return 0;
    }

    private function check(array $arguments): int
    {
        if (!isset($arguments[2]) || isset($arguments[3])) {
            return $this->usageError('Usage: shopkit-themes check <theme-directory>');
        }

        $project = new ThemeProject($arguments[2]);
        $errors = (new RendererProcess($this->packageRoot))->check($project);

        if ($errors !== []) {
            foreach ($errors as $error) {
                $this->write($this->error, 'Error: '.$error.PHP_EOL);
            }
            return 1;
        }

        $this->write($this->output, sprintf('Theme valid (%d templates).%s', count($project->templates()), PHP_EOL));
        return 0;
    }

    private function serve(array $arguments): int
    {
        if (!isset($arguments[2])) {
            return $this->usageError('Usage: shopkit-themes serve <theme-directory> [--page=home] [--port=4173]');
        }

        $page = 'home';
        $port = 4173;
        $seen = [];
        foreach (array_slice($arguments, 3) as $option) {
            if (!is_string($option) || preg_match('/\A--(page|port)=(.*)\z/D', $option, $matches) !== 1) {
                return $this->usageError('Usage: shopkit-themes serve <theme-directory> [--page=home] [--port=4173]');
            }
            if (isset($seen[$matches[1]])) {
                return $this->usageError('Preview options must not be repeated.');
            }
            $seen[$matches[1]] = true;
            if ($matches[1] === 'page') {
                $page = $matches[2];
            } elseif (preg_match('/\A\d{1,5}\z/D', $matches[2]) === 1) {
                $port = (int) $matches[2];
            } else {
                return $this->usageError('Preview port must be a number between 1 and 65535.');
            }
        }

        if (preg_match('/\A[a-z0-9][a-z0-9-]*\z/D', $page) !== 1) {
            return $this->usageError('Preview page must be a theme page name.');
        }
        if ($port < 1 || $port > 65_535) {
            return $this->usageError('Preview port must be a number between 1 and 65535.');
        }

        $project = new ThemeProject($arguments[2]);
        if (!in_array($page, $project->pages(), true)) {
            throw new InvalidArgumentException('Preview page does not exist in the theme.');
        }

        $errors = (new RendererProcess($this->packageRoot))->check($project);
        if ($errors !== []) {
            foreach ($errors as $error) {
                $this->write($this->error, 'Error: '.$error.PHP_EOL);
            }
            return 1;
        }

        return $this->runPreviewServer($project, $page, $port);
    }

    private function runPreviewServer(ThemeProject $project, string $page, int $port): int
    {
        if (!function_exists('stream_socket_client')) {
            throw new RuntimeException('Local preview requires PHP local socket functions.');
        }

        $autoload = $this->findAutoload();
        $bootstrapCss = $this->findBootstrapCss($autoload);
        $router = $this->packageRoot.'/resources/preview-router.php';
        if (!is_file($router)) {
            throw new RuntimeException('Local preview server is unavailable.');
        }

        $token = bin2hex(random_bytes(32));
        $address = '127.0.0.1:'.$port;
        $disabled = implode(',', [
            'exec', 'passthru', 'shell_exec', 'system', 'popen', 'pcntl_exec',
            'curl_exec', 'curl_multi_exec', 'fsockopen', 'pfsockopen',
            'stream_socket_client', 'socket_create', 'socket_connect', 'mail', 'putenv',
        ]);

        $command = [
            PHP_BINARY,
            '-d', 'allow_url_fopen=0',
            '-d', 'allow_url_include=0',
            '-d', 'display_errors=0',
            '-d', 'expose_php=0',
            '-d', 'html_errors=0',
            '-d', 'log_errors=0',
            '-d', 'max_execution_time=10',
            '-d', 'memory_limit=192M',
            '-d', 'open_basedir='.implode(PATH_SEPARATOR, array_unique([
                $this->packageRoot,
                $project->root(),
                dirname($autoload),
            ])),
            '-d', 'disable_functions='.$disabled,
            '-S', $address,
            $router,
        ];

        $environment = [
            'HOME' => sys_get_temp_dir(),
            'LANG' => 'C',
            'LC_ALL' => 'C',
            'PATH' => '/usr/bin:/bin',
            'SHOPKIT_THEMES_AUTOLOAD' => $autoload,
            'SHOPKIT_THEMES_BOOTSTRAP_CSS' => $bootstrapCss,
            'SHOPKIT_THEMES_PACKAGE_ROOT' => $this->packageRoot,
            'SHOPKIT_THEMES_PAGE' => $page,
            'SHOPKIT_THEMES_PORT' => (string) $port,
            'SHOPKIT_THEMES_THEME_ROOT' => $project->root(),
            'SHOPKIT_THEMES_TOKEN' => $token,
        ];
        if (isset($_SERVER['SystemRoot']) && is_string($_SERVER['SystemRoot'])) {
            $environment['SystemRoot'] = $_SERVER['SystemRoot'];
        }

        $pipes = [];
        $process = @proc_open($command, [
            0 => ['pipe', 'r'],
            1 => ['pipe', 'w'],
            2 => ['pipe', 'w'],
        ], $pipes, $this->packageRoot, $environment);

        if (!is_resource($process)) {
            throw new RuntimeException('Local preview server could not be started.');
        }

        fclose($pipes[0]);
        stream_set_blocking($pipes[1], false);
        stream_set_blocking($pipes[2], false);

        $stopped = false;
        $stop = static function () use ($process, &$stopped): void {
            if (!$stopped && is_resource($process)) {
                $stopped = true;
                @proc_terminate($process, 15);
            }
        };
        register_shutdown_function($stop);

        $running = true;
        if (function_exists('pcntl_async_signals') && function_exists('pcntl_signal')) {
            pcntl_async_signals(true);
            pcntl_signal(SIGINT, static function () use (&$running): void { $running = false; });
            pcntl_signal(SIGTERM, static function () use (&$running): void { $running = false; });
        }

        $ready = false;
        $deadline = microtime(true) + 4.0;
        while (microtime(true) < $deadline) {
            $this->discardServerOutput($pipes);
            $status = proc_get_status($process);
            if (!$status['running']) {
                break;
            }
            if ($this->previewServerIsReady($address, $token)) {
                $ready = true;
                break;
            }
            usleep(20_000);
        }

        if (!$ready) {
            $stop();
            $this->closeProcess($process, $pipes);
            throw new RuntimeException('Local preview server could not start on '.$address.'.');
        }

        $this->write($this->output, sprintf(
            "Preview: http://%s/%s/%s%sPress Ctrl-C to stop.%s",
            $address,
            $token,
            $page,
            PHP_EOL,
            PHP_EOL
        ));

        while ($running) {
            $this->discardServerOutput($pipes);
            if (!proc_get_status($process)['running']) {
                $running = false;
                break;
            }
            usleep(20_000);
        }

        $stop();
        $this->closeProcess($process, $pipes);
        return 0;
    }

    private function findAutoload(): string
    {
        foreach ([
            $this->packageRoot.'/vendor/autoload.php',
            dirname($this->packageRoot, 2).'/autoload.php',
        ] as $candidate) {
            $path = realpath($candidate);
            if ($path !== false && is_file($path)) {
                return $path;
            }
        }
        throw new RuntimeException('Composer autoloader is unavailable.');
    }

    private function findBootstrapCss(string $autoload): string
    {
        $relative = 'twbs/bootstrap/dist/css/bootstrap.min.css';
        foreach ([
            $this->packageRoot.'/vendor/'.$relative,
            dirname($autoload).'/'.$relative,
        ] as $candidate) {
            $path = realpath($candidate);
            if ($path !== false && is_file($path)) {
                return $path;
            }
        }

        throw new RuntimeException('Local Bootstrap preview stylesheet is unavailable.');
    }

    private function discardServerOutput(array $pipes): void
    {
        foreach ([1, 2] as $index) {
            if (isset($pipes[$index]) && is_resource($pipes[$index])) {
                stream_get_contents($pipes[$index]);
            }
        }
    }

    private function previewServerIsReady(string $address, string $token): bool
    {
        $socket = @stream_socket_client('tcp://'.$address, $errorNumber, $errorMessage, 0.2);
        if (!is_resource($socket)) {
            return false;
        }

        stream_set_timeout($socket, 1);
        fwrite(
            $socket,
            'GET /'.$token.'/__theme/placeholder.svg HTTP/1.1'."\r\n"
            .'Host: '.$address."\r\nConnection: close\r\n\r\n"
        );
        $response = stream_get_contents($socket, 8_192);
        fclose($socket);

        return is_string($response)
            && str_starts_with($response, 'HTTP/1.1 200')
            && str_contains($response, 'Shopkit theme preview');
    }

    /** @param resource $process */
    private function closeProcess($process, array $pipes): void
    {
        $deadline = microtime(true) + 2.0;
        while (proc_get_status($process)['running'] && microtime(true) < $deadline) {
            usleep(10_000);
        }
        if (proc_get_status($process)['running']) {
            @proc_terminate($process, 9);
        }
        foreach ([1, 2] as $index) {
            if (isset($pipes[$index]) && is_resource($pipes[$index])) {
                fclose($pipes[$index]);
            }
        }
        @proc_close($process);
    }

    private function usageError(string $message): int
    {
        $this->write($this->error, $message.PHP_EOL);
        return 2;
    }

    private function safeArgument(mixed $argument): string
    {
        $argument = is_scalar($argument) ? (string) $argument : '';
        $argument = preg_replace('/[^a-zA-Z0-9:_-]/', '', $argument) ?? '';
        return substr($argument, 0, 80);
    }

    private function safeError(Throwable $exception): string
    {
        $message = preg_replace('/[\r\n\t]+/', ' ', $exception->getMessage()) ?? '';
        return substr(trim($message), 0, 500);
    }

    private function removeDirectory(string $path): void
    {
        if (!is_dir($path) || is_link($path)) {
            return;
        }
        foreach (new FilesystemIterator($path) as $item) {
            if ($item->isDir() && !$item->isLink()) {
                $this->removeDirectory($item->getPathname());
            } else {
                @unlink($item->getPathname());
            }
        }
        @rmdir($path);
    }

    private function themeThirdPartyNotices(string $starter): string
    {
        $isotope = '';
        if ($starter === 'mosaic') {
            $isotope = <<<'NOTICE'
## Isotope v1.5.25

`js/plugins.js` includes Isotope v1.5.25, copyright 2013 Metafizzy. Its
retained notice states that commercial use requires purchase of a commercial
license and that non-commercial use is licensed under the MIT License.

The original notice is preserved in `js/plugins.js` and remains authoritative.
See the license URL recorded there:
<http://isotope.metafizzy.co/docs/license.html>.

NOTICE;
        }

        $apacheComponents = '- Bootstrap 3 Typeahead 4.0.2 in `js/plugins.js`.';
        if (in_array($starter, ['default', 'mosaic'], true)) {
            $apacheComponents = '- Bootstrap 2.3.2 in `js/plugins.js`;'.PHP_EOL
                .'- Bootstrap 3 Typeahead 4.0.2 in `js/plugins.js`.';
        }

        return <<<'NOTICE'
# Third-party notices

The [MIT License](LICENSE) applies to Shopkit-authored files in this theme. It
does not replace or relicense third-party code bundled in `js/plugins.js`.
Third-party components retain their own copyright, license, and attribution
notices in that file.

NOTICE
            .$isotope
            .<<<NOTICE
## Apache License 2.0 components

The JavaScript bundle includes software licensed under the Apache License 2.0:

{$apacheComponents}

The required license text is available at
[LICENSE-APACHE-2.0.txt](LICENSE-APACHE-2.0.txt).

## Other third-party components

`js/plugins.js` also contains third-party components whose copyright, version,
license, and attribution notices are preserved alongside each bundled copy.
Those retained notices remain authoritative for the components present in this
starter.
NOTICE;
    }

    /** @param resource $stream */
    private function write($stream, string $message): void
    {
        fwrite($stream, $message);
    }
}
