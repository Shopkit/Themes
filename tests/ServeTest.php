<?php

declare(strict_types=1);

namespace Shopkit\Themes\Tests;

use PHPUnit\Framework\TestCase;

final class ServeTest extends TestCase
{
    private array $themes = [];
    private array $servers = [];

    protected function tearDown(): void
    {
        foreach (array_reverse($this->servers) as $server) {
            $this->stopServer($server);
        }
        foreach (array_reverse($this->themes) as $theme) {
            TestTheme::remove($theme);
        }
    }

    public function testServesTokenizedHtmlCssAndPlaceholderOnlyOnLoopback(): void
    {
        $server = $this->startServer(dirname(__DIR__).'/default');

        $html = $this->request($server, 'GET', '/'.$server['token'].'/home');
        self::assertSame(200, $html['status']);
        self::assertStringContainsString('Produto de exemplo', $html['body']);
        self::assertSame('no-store', $html['headers']['cache-control'] ?? null);
        self::assertSame('nosniff', $html['headers']['x-content-type-options'] ?? null);
        self::assertSame('same-origin', $html['headers']['cross-origin-resource-policy'] ?? null);
        self::assertStringContainsString("script-src 'none'", $html['headers']['content-security-policy'] ?? '');
        self::assertStringContainsString('attribution-reporting=()', $html['headers']['permissions-policy'] ?? '');
        self::assertArrayNotHasKey('set-cookie', $html['headers']);
        self::assertArrayNotHasKey('access-control-allow-origin', $html['headers']);

        $css = $this->request($server, 'GET', '/'.$server['token'].'/__theme/style.css');
        self::assertSame(200, $css['status']);
        self::assertStringStartsWith('text/css', $css['headers']['content-type'] ?? '');
        self::assertStringNotContainsStringIgnoringCase('@import', $css['body']);
        self::assertDoesNotMatchRegularExpression('/url\([^)]*(?:https?:)?\/\//i', $css['body']);

        $image = $this->request($server, 'GET', '/'.$server['token'].'/__theme/placeholder.svg');
        self::assertSame(200, $image['status']);
        self::assertStringStartsWith('image/svg+xml', $image['headers']['content-type'] ?? '');
        self::assertStringContainsString('<svg', $image['body']);

        usleep(50_000);
        $stderr = stream_get_contents($server['pipes'][2]) ?: '';
        self::assertStringNotContainsString($server['token'], $stderr);
        self::assertStringNotContainsString('GET /', $stderr);
    }

    public function testRejectsWrongHostTokenAndMethodsAndHeadHasNoBody(): void
    {
        $server = $this->startServer(dirname(__DIR__).'/default');

        self::assertSame(404, $this->request($server, 'GET', '/')['status']);
        self::assertSame(404, $this->request($server, 'GET', '/'.str_repeat('0', 64).'/home')['status']);
        self::assertSame(421, $this->request($server, 'GET', '/'.$server['token'].'/home', 'evil.example')['status']);

        $post = $this->request($server, 'POST', '/'.$server['token'].'/home');
        self::assertSame(405, $post['status']);
        self::assertSame('GET, HEAD', $post['headers']['allow'] ?? null);

        $head = $this->request($server, 'HEAD', '/'.$server['token'].'/home');
        self::assertSame(200, $head['status']);
        self::assertSame('', $head['body']);
        self::assertStringContainsString("default-src 'none'", $head['headers']['content-security-policy'] ?? '');
    }

    public function testBoxieUsesThePinnedLocalBootstrapStylesheet(): void
    {
        $server = $this->startServer(dirname(__DIR__).'/boxie');

        $html = $this->request($server, 'GET', '/'.$server['token'].'/home');
        self::assertSame(200, $html['status']);
        self::assertStringNotContainsString('cdn.jsdelivr.net', $html['body']);
        self::assertStringContainsString('/'.$server['token'].'/__theme/bootstrap.css', $html['body']);

        $css = $this->request($server, 'GET', '/'.$server['token'].'/__theme/bootstrap.css');
        self::assertSame(200, $css['status']);
        self::assertStringStartsWith('text/css', $css['headers']['content-type'] ?? '');
        self::assertStringContainsString('.container-fluid', $css['body']);
        self::assertSame(
            'TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2',
            base64_encode(hash('sha384', $css['body'], true))
        );
    }

    public function testMosaicHomeHasALocalCssLayoutFallbackWithoutJavascript(): void
    {
        $server = $this->startServer(dirname(__DIR__).'/mosaic');

        $html = $this->request($server, 'GET', '/'.$server['token'].'/home');
        self::assertSame(200, $html['status']);
        self::assertStringContainsString('class="unstyled products"', $html['body']);
        self::assertStringNotContainsStringIgnoringCase('<script', $html['body']);

        $css = $this->request($server, 'GET', '/'.$server['token'].'/__theme/style.css');
        self::assertSame(200, $css['status']);
        self::assertStringContainsString('Shopkit local Mosaic layout fallback', $css['body']);
        self::assertStringContainsString('grid-template-columns:', $css['body']);
        self::assertStringContainsString('opacity: 1 !important', $css['body']);
    }

    public function testFixtureLinksNavigateWithinEveryLocalThemePreview(): void
    {
        foreach (['default', 'boxie', 'minimal', 'mosaic'] as $theme) {
            $server = $this->startServer(dirname(__DIR__).'/'.$theme);
            $prefix = '/'.$server['token'];

            $home = $this->request($server, 'GET', $prefix.'/home');
            self::assertSame(200, $home['status'], $theme.'/home');
            self::assertStringContainsString($prefix.'/product/demo-product', $home['body'], $theme);
            self::assertStringNotContainsString('href="/product/', $home['body'], $theme);

            foreach ([
                '/product/demo-product',
                '/catalog',
                '/brand/demo-brand',
                '/blog/demo-post',
                '/cart/data',
            ] as $path) {
                self::assertSame(
                    200,
                    $this->request($server, 'GET', $prefix.$path)['status'],
                    $theme.$path
                );
            }

            $this->stopServer($server);
        }
    }

    public function testActiveMarkupIsSanitizedAndAResourceFailureDoesNotKillTheServer(): void
    {
        $theme = TestTheme::create([
            'home.tpl' => <<<'TWIG'
<html><body onload="steal()"><script>steal()</script><iframe src="https://evil.example"></iframe><form action="/pay"><button formaction="javascript:steal()">Pay</button></form><img src="https://evil.example/pixel"></body></html>
TWIG,
        ]);
        $this->themes[] = $theme;
        $server = $this->startServer($theme);

        $response = $this->request($server, 'GET', '/'.$server['token'].'/home');
        self::assertSame(200, $response['status']);
        self::assertStringNotContainsStringIgnoringCase('<script', $response['body']);
        self::assertStringNotContainsStringIgnoringCase('<iframe', $response['body']);
        self::assertStringNotContainsStringIgnoringCase('onload=', $response['body']);
        self::assertStringNotContainsString('evil.example', $response['body']);
        self::assertStringContainsString('action="#"', $response['body']);

        file_put_contents($theme.'/home.tpl', "{% for item in range(0, 100000000) %}x{% endfor %}");
        $failed = $this->request($server, 'GET', '/'.$server['token'].'/home', null, 12.0);
        self::assertSame(422, $failed['status']);
        self::assertStringNotContainsString('Stack trace', $failed['body']);

        file_put_contents($theme.'/home.tpl', '<html><body>Recovered</body></html>');
        $recovered = $this->request($server, 'GET', '/'.$server['token'].'/home');
        self::assertSame(200, $recovered['status']);
        self::assertStringContainsString('Recovered', $recovered['body']);
    }

    public function testOccupiedPortFailsClearlyWithoutLeavingAChildServer(): void
    {
        $listener = stream_socket_server('tcp://127.0.0.1:0', $errorNumber, $errorMessage);
        self::assertIsResource($listener, $errorMessage);
        $name = stream_socket_get_name($listener, false);
        self::assertIsString($name);
        $port = (int) substr(strrchr($name, ':'), 1);

        $pipes = [];
        $process = proc_open([
            PHP_BINARY,
            dirname(__DIR__).'/bin/shopkit-themes',
            'serve',
            dirname(__DIR__).'/default',
            '--port='.$port,
        ], [
            0 => ['pipe', 'r'],
            1 => ['pipe', 'w'],
            2 => ['pipe', 'w'],
        ], $pipes, dirname(__DIR__));
        self::assertIsResource($process);
        fclose($pipes[0]);
        stream_set_blocking($pipes[1], false);
        stream_set_blocking($pipes[2], false);

        $stdout = '';
        $stderr = '';
        $deadline = microtime(true) + 10.0;
        while (proc_get_status($process)['running'] && microtime(true) < $deadline) {
            $stdout .= stream_get_contents($pipes[1]) ?: '';
            $stderr .= stream_get_contents($pipes[2]) ?: '';
            usleep(20_000);
        }
        $stdout .= stream_get_contents($pipes[1]) ?: '';
        $stderr .= stream_get_contents($pipes[2]) ?: '';

        self::assertFalse(proc_get_status($process)['running'], 'CLI must not hang when the port is occupied.');
        self::assertSame('', $stdout);
        self::assertStringContainsString('could not start', $stderr);
        self::assertStringNotContainsString('Stack trace', $stderr);

        fclose($pipes[1]);
        fclose($pipes[2]);
        proc_close($process);
        fclose($listener);
    }

    private function startServer(string $theme): array
    {
        $port = $this->freePort();
        $pipes = [];
        $process = proc_open([
            PHP_BINARY,
            dirname(__DIR__).'/bin/shopkit-themes',
            'serve',
            $theme,
            '--port='.$port,
            '--page=home',
        ], [
            0 => ['pipe', 'r'],
            1 => ['pipe', 'w'],
            2 => ['pipe', 'w'],
        ], $pipes, dirname(__DIR__), [
            'HOME' => sys_get_temp_dir(),
            'PATH' => getenv('PATH') ?: '/usr/bin:/bin',
        ]);

        self::assertIsResource($process);
        fclose($pipes[0]);
        stream_set_blocking($pipes[1], false);
        stream_set_blocking($pipes[2], false);

        $stdout = '';
        $stderr = '';
        $deadline = microtime(true) + 8.0;
        $token = null;
        while (microtime(true) < $deadline) {
            $stdout .= stream_get_contents($pipes[1]) ?: '';
            $stderr .= stream_get_contents($pipes[2]) ?: '';
            if (preg_match('#http://127\.0\.0\.1:'.$port.'/([a-f0-9]{64})/home#', $stdout, $matches) === 1) {
                $token = $matches[1];
                break;
            }
            $status = proc_get_status($process);
            if (!$status['running']) {
                break;
            }
            usleep(20_000);
        }

        if ($token === null) {
            $this->stopServer(compact('process', 'pipes', 'stdout', 'stderr', 'port'));
            self::fail('Preview server did not start. stdout='.$stdout.' stderr='.$stderr);
        }

        $server = compact('process', 'pipes', 'stdout', 'stderr', 'port', 'token');
        $this->servers[] = $server;
        return $server;
    }

    private function stopServer(array $server): void
    {
        $process = $server['process'] ?? null;
        if (!is_resource($process)) {
            return;
        }

        @proc_terminate($process, 15);
        $deadline = microtime(true) + 3.0;
        while (proc_get_status($process)['running'] && microtime(true) < $deadline) {
            usleep(20_000);
        }
        if (proc_get_status($process)['running']) {
            @proc_terminate($process, 9);
        }

        foreach (($server['pipes'] ?? []) as $pipe) {
            if (is_resource($pipe)) {
                fclose($pipe);
            }
        }
        @proc_close($process);

        if (isset($server['port'])) {
            $socket = @stream_socket_client('tcp://127.0.0.1:'.$server['port'], $errorNumber, $errorMessage, 0.2);
            if (is_resource($socket)) {
                fclose($socket);
                self::fail('Preview server child remained reachable after the CLI stopped.');
            }
        }
    }

    private function request(array $server, string $method, string $path, ?string $host = null, float $timeout = 8.0): array
    {
        $errorNumber = 0;
        $errorMessage = '';
        $socket = stream_socket_client(
            'tcp://127.0.0.1:'.$server['port'],
            $errorNumber,
            $errorMessage,
            $timeout
        );
        self::assertIsResource($socket, $errorMessage);
        stream_set_timeout($socket, (int) ceil($timeout));

        $host ??= '127.0.0.1:'.$server['port'];
        fwrite($socket, $method.' '.$path." HTTP/1.1\r\nHost: ".$host."\r\nConnection: close\r\n\r\n");
        $raw = stream_get_contents($socket);
        fclose($socket);

        self::assertIsString($raw);
        [$head, $body] = array_pad(preg_split("/\r?\n\r?\n/", $raw, 2) ?: [], 2, '');
        $lines = preg_split("/\r?\n/", $head) ?: [];
        self::assertMatchesRegularExpression('#^HTTP/\d(?:\.\d)?\s+(\d{3})#', $lines[0] ?? '');
        preg_match('#^HTTP/\d(?:\.\d)?\s+(\d{3})#', array_shift($lines), $statusMatch);

        $headers = [];
        foreach ($lines as $line) {
            if (!str_contains($line, ':')) {
                continue;
            }
            [$name, $value] = explode(':', $line, 2);
            $headers[strtolower(trim($name))] = trim($value);
        }

        return ['status' => (int) $statusMatch[1], 'headers' => $headers, 'body' => $body];
    }

    private function freePort(): int
    {
        $socket = stream_socket_server('tcp://127.0.0.1:0', $errorNumber, $errorMessage);
        self::assertIsResource($socket, $errorMessage);
        $name = stream_socket_get_name($socket, false);
        fclose($socket);
        self::assertIsString($name);
        return (int) substr(strrchr($name, ':'), 1);
    }
}
