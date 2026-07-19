<?php

declare(strict_types=1);

use Shopkit\Themes\Fixtures;
use Shopkit\Themes\Renderer;
use Shopkit\Themes\ThemeProject;

$autoload = $_SERVER['SHOPKIT_THEMES_AUTOLOAD'] ?? null;
if (!is_string($autoload) || !is_file($autoload)) {
    exit(1);
}

require $autoload;

try {
    $input = stream_get_contents(STDIN, 16_384);
    if (!is_string($input) || $input === '' || !feof(STDIN)) {
        throw new RuntimeException('Renderer input is invalid.');
    }

    $request = json_decode($input, true, 8, JSON_THROW_ON_ERROR);
    if (!is_array($request) || !is_string($request['operation'] ?? null) || !is_string($request['theme_root'] ?? null)) {
        throw new RuntimeException('Renderer request is invalid.');
    }

    $project = new ThemeProject($request['theme_root']);
    $renderer = new Renderer(new Fixtures(dirname(__DIR__)));

    $result = match ($request['operation']) {
        'render' => $renderer->render(
            $project,
            is_string($request['page'] ?? null) ? $request['page'] : '',
            is_string($request['asset_base'] ?? null) ? $request['asset_base'] : ''
        ),
        'css' => $renderer->compileCss($project),
        'check' => (static function () use ($renderer, $project): array {
            $errors = $renderer->check($project);
            try {
                $renderer->compileCss($project);
            } catch (Throwable $exception) {
                $errors[] = 'css/style.less: '.$exception->getMessage();
            }
            return $errors;
        })(),
        default => throw new RuntimeException('Renderer operation is invalid.'),
    };

    echo json_encode(['ok' => true, 'result' => $result], JSON_THROW_ON_ERROR);
    exit(0);
} catch (Throwable $exception) {
    $message = preg_replace('/[\r\n\t]+/', ' ', $exception->getMessage()) ?? '';
    $message = preg_replace('#(?:[A-Za-z]:)?[/\\\\](?:[^\s:]+[/\\\\])+[^\s:]+#', '[path]', $message) ?? '';
    echo json_encode([
        'ok' => false,
        'error' => substr(trim($message), 0, 500),
    ], JSON_UNESCAPED_SLASHES);
    exit(1);
}
