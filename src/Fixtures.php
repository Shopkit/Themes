<?php

declare(strict_types=1);

namespace Shopkit\Themes;

use InvalidArgumentException;
use JsonException;
use RuntimeException;

final class Fixtures
{
    private const THEMES = ['boxie', 'default', 'minimal', 'mosaic'];

    private string $fixtureRoot;
    private array $data;
    private array $themeOptions = [];

    public function __construct(?string $packageRoot = null)
    {
        $packageRoot ??= dirname(__DIR__);
        $fixtureRoot = realpath($packageRoot.'/resources/fixtures');

        if ($fixtureRoot === false || !is_dir($fixtureRoot) || !is_readable($fixtureRoot)) {
            throw new InvalidArgumentException('Fixture directory is not readable.');
        }

        $this->fixtureRoot = $fixtureRoot;
        $this->data = $this->readJson($fixtureRoot.'/storefront.json');

        $expected = ['globals', 'products', 'categories', 'brands', 'posts', 'reviews'];
        if (array_keys($this->data) !== $expected) {
            throw new RuntimeException('Storefront fixture has an invalid structure.');
        }
    }

    public function context(string $theme, string $assetBase): array
    {
        $options = $this->themeOptions($theme);
        $context = $this->data['globals'];
        $runtimeOptions = $context['store']['theme_options'];

        $context['store']['theme_options'] = array_replace($options, $runtimeOptions);
        $context['store']['basecolor'] = $options['basecolor'];
        $context['store']['assets']['css'] = $this->assetUrl($assetBase, '/__theme/style.css');

        return $this->localizeAssets($context, $assetBase);
    }

    public function products(string $query = ''): array
    {
        $products = $this->limit($this->data['products'], $query);

        if (preg_match('/(?:^|\s)search(?:\s|$)/i', $query) === 1) {
            return [
                'query' => 'demo',
                'total_results' => count($this->data['products']),
                'results' => $products,
            ];
        }

        return $products;
    }

    public function categories(string $query = ''): array
    {
        $categories = $this->data['categories'];

        if (preg_match('/(?:^|\s)parent:(\d+)(?:\s|$)/', $query, $matches) === 1) {
            $parent = (int) $matches[1];
            $categories = array_values(array_filter(
                $categories,
                static fn (array $category): bool => $category['parent'] === $parent
            ));
        }

        return $this->limit($categories, $query);
    }

    public function category(int|string|null $id): array
    {
        foreach ($this->data['categories'] as $category) {
            if ((string) $category['id'] === (string) $id) {
                return $category;
            }
        }

        return [];
    }

    public function brands(string $query = ''): array
    {
        return $this->limit($this->data['brands'], $query);
    }

    public function blogPosts(string $query = ''): array
    {
        return $this->limit($this->data['posts'], $query);
    }

    public function reviews(string $query = ''): array
    {
        $reviews = $this->data['reviews'];
        $reviews['reviews'] = $this->limit($reviews['reviews'], $query);

        return $reviews;
    }

    public function themeOptions(string $theme): array
    {
        $this->assertTheme($theme);

        if (!isset($this->themeOptions[$theme])) {
            $options = $this->readJson($this->fixtureRoot.'/theme-options/'.$theme.'.json');
            $options += [
                'logo_height' => '60',
                'footer_images_height' => in_array($theme, ['boxie', 'minimal'], true) ? '50' : '40',
                'show_rating_filter' => 'none',
                'show_section_gpsr' => 'block',
            ];
            $this->themeOptions[$theme] = $options;
        }

        return $this->themeOptions[$theme];
    }

    public function templateVariables(string $theme): string
    {
        $options = $this->themeOptions($theme);
        $template = $this->readFile($this->fixtureRoot.'/template-vars.less');

        preg_match_all('/@([a-zA-Z0-9_-]+)/', $template, $matches);
        $variables = array_values(array_unique($matches[1]));
        $declarations = [];

        foreach ($variables as $variable) {
            if (!array_key_exists($variable, $options)) {
                throw new RuntimeException(sprintf('Theme fixture is missing LESS variable: %s.', $variable));
            }
            $declarations[] = sprintf('@%s: %s;', $variable, $this->lessValue($options[$variable]));
        }

        return implode("\n", $declarations)."\n\n".$template;
    }

    private function limit(array $items, string $query): array
    {
        if (preg_match('/(?:^|\s)limit:(\d+)(?:\s|$)/', $query, $matches) !== 1) {
            return array_values($items);
        }

        return array_slice(array_values($items), 0, (int) $matches[1]);
    }

    private function assetUrl(string $assetBase, string $path): string
    {
        if ($assetBase === '') {
            return $path;
        }

        if (
            $assetBase[0] !== '/'
            || str_starts_with($assetBase, '//')
            || str_contains($assetBase, '\\')
            || str_contains($assetBase, '://')
            || strpbrk($assetBase, '?#') !== false
            || preg_match('/[\x00-\x1F\x7F]/', $assetBase) === 1
            || preg_match('~(?:^|/)\.\.(?:/|$)~', $assetBase) === 1
        ) {
            throw new InvalidArgumentException('Asset base must be a local absolute path.');
        }

        return rtrim($assetBase, '/').$path;
    }

    private function localizeAssets(mixed $value, string $assetBase): mixed
    {
        if (is_array($value)) {
            foreach ($value as $key => $item) {
                $value[$key] = $this->localizeAssets($item, $assetBase);
            }
            return $value;
        }

        if ($value === '/assets/placeholder.svg') {
            return $this->assetUrl($assetBase, '/__theme/placeholder.svg');
        }

        if (is_string($value) && str_starts_with($value, '/')) {
            $base = rtrim($assetBase, '/');
            if ($base !== '' && ($value === $base || str_starts_with($value, $base.'/'))) {
                return $value;
            }

            return $this->assetUrl($assetBase, $value);
        }

        return $value;
    }

    private function assertTheme(string $theme): void
    {
        if (!in_array($theme, self::THEMES, true)) {
            throw new InvalidArgumentException('Unknown fixture theme.');
        }
    }

    private function readJson(string $path): array
    {
        try {
            $data = json_decode($this->readFile($path), true, 32, JSON_THROW_ON_ERROR);
        } catch (JsonException $exception) {
            throw new RuntimeException('Fixture contains invalid JSON.', 0, $exception);
        }

        if (!is_array($data)) {
            throw new RuntimeException('Fixture JSON root must be an object.');
        }

        return $data;
    }

    private function readFile(string $path): string
    {
        $contents = file_get_contents($path);
        if ($contents === false) {
            throw new RuntimeException('Fixture file is not readable.');
        }

        return $contents;
    }

    private function lessValue(mixed $value): string
    {
        if ($value === 'basecolor' || $value === 'secondarycolor') {
            return '@'.$value;
        }

        if (is_bool($value)) {
            return $value ? 'true' : 'false';
        }

        if (is_int($value) || is_float($value) || is_string($value)) {
            return (string) $value;
        }

        if ($value === null) {
            return 'none';
        }

        throw new RuntimeException('Theme fixture contains an invalid LESS value.');
    }
}
