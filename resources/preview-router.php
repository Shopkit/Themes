<?php

declare(strict_types=1);

use Shopkit\Themes\PreviewServer;
use Shopkit\Themes\RendererProcess;
use Shopkit\Themes\ThemeProject;

$environment = static function (string $name): ?string {
    $value = getenv($name);
    return is_string($value) ? $value : null;
};

$autoload = $environment('SHOPKIT_THEMES_AUTOLOAD');
$bootstrapCss = $environment('SHOPKIT_THEMES_BOOTSTRAP_CSS');
$packageRoot = $environment('SHOPKIT_THEMES_PACKAGE_ROOT');
$themeRoot = $environment('SHOPKIT_THEMES_THEME_ROOT');
$token = $environment('SHOPKIT_THEMES_TOKEN');
$port = $environment('SHOPKIT_THEMES_PORT');
$defaultPage = $environment('SHOPKIT_THEMES_PAGE');

if (!is_string($autoload) || !is_file($autoload)
    || !is_string($bootstrapCss) || !is_file($bootstrapCss)
    || !is_string($packageRoot) || !is_dir($packageRoot)
    || !is_string($themeRoot) || !is_dir($themeRoot)
    || !is_string($token) || preg_match('/\A[a-f0-9]{64}\z/D', $token) !== 1
    || !is_string($port) || preg_match('/\A\d{1,5}\z/D', $port) !== 1
    || !is_string($defaultPage) || preg_match('/\A[a-z0-9][a-z0-9-]*\z/D', $defaultPage) !== 1) {
    http_response_code(500);
    exit;
}

require $autoload;

$method = is_string($_SERVER['REQUEST_METHOD'] ?? null) ? $_SERVER['REQUEST_METHOD'] : '';

$respond = static function (int $status, string $contentType, string $body, array $headers = []) use ($method): void {
    http_response_code($status);
    header_remove('X-Powered-By');
    header('Content-Type: '.$contentType);
    header('Content-Security-Policy: '.PreviewServer::contentSecurityPolicy());
    header('Cache-Control: no-store');
    header('Cross-Origin-Resource-Policy: same-origin');
    header('Permissions-Policy: accelerometer=(), attribution-reporting=(), camera=(), geolocation=(), gyroscope=(), microphone=(), payment=(), usb=()');
    header('Referrer-Policy: no-referrer');
    header('X-Content-Type-Options: nosniff');
    header('X-Frame-Options: DENY');
    foreach ($headers as $name => $value) {
        header($name.': '.$value);
    }
    header('Content-Length: '.strlen($body));

    if ($method !== 'HEAD') {
        echo $body;
    }
};

$host = $_SERVER['HTTP_HOST'] ?? null;
$expectedHost = '127.0.0.1:'.$port;
if (!is_string($host) || !hash_equals($expectedHost, $host)) {
    $respond(421, 'text/plain; charset=UTF-8', "Misdirected request.\n");
    return;
}

if (!in_array($method, ['GET', 'HEAD'], true)) {
    $respond(405, 'text/plain; charset=UTF-8', "Method not allowed.\n", ['Allow' => 'GET, HEAD']);
    return;
}

$requestUri = $_SERVER['REQUEST_URI'] ?? null;
$path = is_string($requestUri) ? parse_url($requestUri, PHP_URL_PATH) : false;
if (!is_string($path) || !str_starts_with($path, '/')) {
    $respond(404, 'text/plain; charset=UTF-8', "Not found.\n");
    return;
}

$segments = explode('/', substr($path, 1), 2);
$requestToken = $segments[0] ?? '';
if (preg_match('/\A[a-f0-9]{64}\z/D', $requestToken) !== 1 || !hash_equals($token, $requestToken)) {
    $respond(404, 'text/plain; charset=UTF-8', "Not found.\n");
    return;
}

$route = $segments[1] ?? '';
$preview = new PreviewServer();

try {
    $project = new ThemeProject($themeRoot);
    $renderer = new RendererProcess($packageRoot);

    if ($route === '__theme/style.css') {
        $css = $renderer->compileCss($project);
        if ($project->fixtureName() === 'mosaic') {
            // Mosaic normally sizes its grid and reveals lazy images with
            // theme JavaScript. The safe preview never executes that code, so
            // reproduce only the non-executable layout behavior in CSS.
            $css .= <<<'CSS'

/* Shopkit local Mosaic layout fallback */
.main .products,
.main .categories-list,
.main .brands-list {
  display: grid !important;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
}
.main .products > li,
.main .categories-list > li,
.main .brands-list > li {
  position: relative !important;
  top: auto !important;
  left: auto !important;
  width: 100% !important;
  height: auto !important;
  aspect-ratio: 1 / 1;
  transform: none !important;
}
.main .products > li img,
.main .categories-list > li img,
.main .brands-list > li img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  opacity: 1 !important;
}
CSS;
        }
        $css = $preview->sanitizeStylesheet($css);
        $respond(200, 'text/css; charset=UTF-8', $css);
        return;
    }

    if ($route === '__theme/placeholder.svg') {
        $svg = '<svg xmlns="http://www.w3.org/2000/svg" width="640" height="480" viewBox="0 0 640 480"><rect width="640" height="480" fill="#f2f2f2"/><path d="M220 310l70-80 55 60 35-40 70 80H190z" fill="#c9c9c9"/><circle cx="250" cy="175" r="28" fill="#c9c9c9"/><text x="320" y="390" text-anchor="middle" font-family="sans-serif" font-size="18" fill="#777">Shopkit theme preview</text></svg>';
        $respond(200, 'image/svg+xml; charset=UTF-8', $svg);
        return;
    }

    if ($route === '__theme/bootstrap.css') {
        $css = file_get_contents($bootstrapCss);
        if (!is_string($css) || strlen($css) > PreviewServer::MAX_PREVIEW_BYTES) {
            throw new RuntimeException('Local preview stylesheet is unavailable.');
        }
        $respond(200, 'text/css; charset=UTF-8', $css);
        return;
    }

    $pages = $project->pages();
    $page = null;
    if ($route === '') {
        $page = $defaultPage;
    } elseif (preg_match('/\A[a-z0-9][a-z0-9-]*\z/D', $route) === 1
        && in_array($route, $pages, true)) {
        $page = $route;
    } else {
        $parts = explode('/', trim($route, '/'));
        $page = match ($parts[0] ?? '') {
            'product' => 'product',
            'category' => 'category',
            'brand' => 'brand',
            'tag' => 'tag',
            'page', 'terms', 'privacy', 'rewards' => 'page',
            'blog' => count($parts) > 1 ? 'post' : 'blog',
            'cart' => ($parts[1] ?? '') === 'data' ? 'data' : 'cart',
            'wishlist' => 'account-wishlist',
            'account' => match ($parts[1] ?? '') {
                'orders' => 'account-orders',
                'profile' => 'account-profile',
                'rewards' => 'account-rewards',
                'wishlist' => 'account-wishlist',
                default => 'account',
            },
            'rss' => 'blog',
            default => null,
        };
    }

    if (!is_string($page) || !in_array($page, $pages, true)) {
        $respond(404, 'text/plain; charset=UTF-8', "Not found.\n");
        return;
    }

    $html = $renderer->render($project, $page, '/'.$token);
    if ($project->fixtureName() === 'boxie') {
        $html = str_replace(
            'https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css',
            '/'.$token.'/__theme/bootstrap.css',
            $html
        );
    }
    $respond(200, 'text/html; charset=UTF-8', $preview->sanitize($html));
} catch (Throwable) {
    $respond(422, 'text/plain; charset=UTF-8', "Preview could not be rendered.\n");
}
