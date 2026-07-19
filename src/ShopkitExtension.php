<?php

declare(strict_types=1);

namespace Shopkit\Themes;

use DateTimeImmutable;
use Throwable;
use Twig\Extension\AbstractExtension;
use Twig\TwigFilter;
use Twig\TwigFunction;

final class ShopkitExtension extends AbstractExtension
{
    private Fixtures $fixtures;
    private string $assetBase;

    public function __construct(Fixtures $fixtures, string $assetBase)
    {
        $this->fixtures = $fixtures;
        $this->assetBase = '/'.trim($assetBase, '/');
    }

    public function getFunctions(): array
    {
        return [
            new TwigFunction('products', fn (string $query = ''): array => $this->localize($this->fixtures->products($query))),
            new TwigFunction('categories', fn (string $query = ''): array => $this->localize($this->fixtures->categories($query))),
            new TwigFunction('category', fn (int|string|null $id = null): array => $this->localize($this->fixtures->category($id))),
            new TwigFunction('brands', fn (string $query = ''): array => $this->localize($this->fixtures->brands($query))),
            new TwigFunction('blog_posts', fn (string $query = ''): array => $this->localize($this->fixtures->blogPosts($query))),
            new TwigFunction('reviews', fn (string $query = ''): array => $this->localize($this->fixtures->reviews($query))),
            new TwigFunction('product', fn (): array => $this->localize($this->fixtures->products()[0] ?? [])),
            new TwigFunction('pages', fn (): array => []),
            new TwigFunction('page', fn (): array => []),
            new TwigFunction('tags', fn (string $query = ''): array => $this->localize([
                ['handle' => 'demo', 'title' => 'Demo', 'url' => '/tag/demo'],
            ])),
            new TwigFunction('price_range', fn (string $query = ''): array => [
                ['price_min' => 12.5, 'price_max' => 24.9],
            ]),
            new TwigFunction('pagination', static fn (string $query = ''): string => ''),
            new TwigFunction('assets_url', fn (string $path = ''): string => $this->localUrl('__theme/placeholder.svg')),
            new TwigFunction('site_url', fn (string $path = ''): string => $this->localUrl($path)),
            new TwigFunction('current_url', fn (): string => $this->localUrl('')),
            new TwigFunction('form_open', fn (string $action = '', mixed $attributes = []): string => $this->form($attributes)),
            new TwigFunction('form_open_cart', fn (int|string|null $productId = null, mixed $attributes = []): string => $this->form($attributes)),
            new TwigFunction('form_close', static fn (): string => '</form>'),
            new TwigFunction('icons', static fn (string $name, string $classes = ''): string => self::icon($name, $classes)),
            new TwigFunction('safe_mailto', static fn (string $email): string => self::safeMailto($email)),
            new TwigFunction('word_limiter', static fn (string $value, int $limit = 100, string $suffix = '…'): string => self::wordLimit($value, $limit, $suffix)),
            new TwigFunction('character_limiter', static fn (string $value, int $limit = 100, string $suffix = '…'): string => self::characterLimit($value, $limit, $suffix)),
            new TwigFunction('line_break', static fn (string $value): string => nl2br(self::escape($value))),
            new TwigFunction('md5', static fn (string $value): string => md5($value)),
        ];
    }

    public function getFilters(): array
    {
        return [
            new TwigFilter('money_with_sign', static fn (mixed $value): string => self::money($value).' €'),
            new TwigFilter('money_without_trailing_zeros', static fn (mixed $value): string => self::money($value, true)),
            new TwigFilter('slug', static fn (mixed $value): string => self::slug((string) $value)),
            new TwigFilter('json_decode', static fn (mixed $value): mixed => self::decodeJson($value)),
            new TwigFilter('first_word', static fn (mixed $value): string => strtok(trim((string) $value), " \t\r\n") ?: ''),
            new TwigFilter('t', static fn (mixed $value, mixed $parameters = []): string => self::translate((string) $value)),
            new TwigFilter('rewards_label', static fn (mixed $value): string => self::translate((string) $value)),
            new TwigFilter('rewards_message', static fn (mixed $value, mixed ...$parameters): string => self::translate((string) $value)),
            new TwigFilter('e_attr', static fn (mixed $value): string => self::escape((string) $value)),
            new TwigFilter('shuffle', static fn (mixed $value): mixed => is_array($value) ? array_values($value) : $value),
            new TwigFilter('format_datetime', static fn (mixed $value, string $format = 'medium', string $timeFormat = 'short'): string => self::formatDate($value)),
        ];
    }

    private function localUrl(string $path): string
    {
        $path = ltrim($path, '/');
        return $path === '' ? $this->assetBase.'/' : $this->assetBase.'/'.$path;
    }

    private function localize(mixed $value): mixed
    {
        if (is_array($value)) {
            foreach ($value as $key => $item) {
                $value[$key] = $this->localize($item);
            }
            return $value;
        }

        if ($value === '/assets/placeholder.svg') {
            return $this->localUrl('__theme/placeholder.svg');
        }

        if (is_string($value) && str_starts_with($value, '/')) {
            if ($value === $this->assetBase || str_starts_with($value, $this->assetBase.'/')) {
                return $value;
            }
            return $this->localUrl($value);
        }

        return $value;
    }

    private function form(mixed $attributes): string
    {
        $safe = ['action' => '#'];
        if (is_string($attributes)) {
            preg_match_all('/\b(class|id|method|role|name|enctype|autocomplete)\s*=\s*(["\'])(.*?)\2/i', $attributes, $matches, PREG_SET_ORDER);
            $attributes = [];
            foreach ($matches as $match) {
                $attributes[strtolower($match[1])] = $match[3];
            }
        }
        if (!is_array($attributes)) {
            $attributes = [];
        }
        foreach ($attributes as $name => $value) {
            if (!is_string($name) || preg_match('/\A(?:class|id|method|role|name|enctype|autocomplete)\z/iD', $name) !== 1) {
                continue;
            }
            $safe[strtolower($name)] = (string) $value;
        }

        $html = '<form';
        foreach ($safe as $name => $value) {
            $html .= ' '.self::escape($name).'="'.self::escape($value).'"';
        }

        return $html.'>';
    }

    private static function icon(string $name, string $classes): string
    {
        $tokens = preg_split('/\s+/', trim($name.' '.$classes)) ?: [];
        $tokens = array_filter($tokens, static fn (string $token): bool => preg_match('/\A[a-z0-9_-]+\z/iD', $token) === 1);
        return '<span aria-hidden="true" class="icon '.self::escape(implode(' ', $tokens)).'"></span>';
    }

    private static function safeMailto(string $email): string
    {
        if (filter_var($email, FILTER_VALIDATE_EMAIL) === false || strlen($email) > 254) {
            return '';
        }

        $safe = self::escape($email);
        return '<a href="mailto:'.$safe.'">'.$safe.'</a>';
    }

    private static function wordLimit(string $value, int $limit, string $suffix): string
    {
        $limit = max(0, min($limit, 1_000));
        $words = preg_split('/\s+/u', trim($value), -1, PREG_SPLIT_NO_EMPTY) ?: [];
        if (count($words) <= $limit) {
            return $value;
        }

        return implode(' ', array_slice($words, 0, $limit)).$suffix;
    }

    private static function characterLimit(string $value, int $limit, string $suffix): string
    {
        $limit = max(0, min($limit, 10_000));
        if (function_exists('mb_strlen') && mb_strlen($value, 'UTF-8') <= $limit) {
            return $value;
        }
        if (!function_exists('mb_strlen') && strlen($value) <= $limit) {
            return $value;
        }

        $short = function_exists('mb_substr') ? mb_substr($value, 0, $limit, 'UTF-8') : substr($value, 0, $limit);
        return $short.$suffix;
    }

    private static function money(mixed $value, bool $trimZeros = false): string
    {
        $formatted = number_format(is_numeric($value) ? (float) $value : 0.0, 2, ',', '.');
        if ($trimZeros) {
            $formatted = preg_replace('/,00\z/D', '', $formatted) ?? $formatted;
        }
        return $formatted;
    }

    private static function slug(string $value): string
    {
        $ascii = function_exists('iconv')
            ? iconv('UTF-8', 'ASCII//TRANSLIT//IGNORE', $value)
            : false;
        $value = $ascii === false ? $value : $ascii;
        $value = strtolower($value);
        $value = preg_replace('/[^a-z0-9]+/', '-', $value) ?? '';
        return trim($value, '-');
    }

    private static function decodeJson(mixed $value): mixed
    {
        if (!is_string($value) || strlen($value) > 65_536) {
            return null;
        }

        return json_decode($value, true, 16);
    }

    private static function formatDate(mixed $value): string
    {
        if (!is_scalar($value) || strlen((string) $value) > 128) {
            return '';
        }
        try {
            return (new DateTimeImmutable((string) $value))->format('d/m/Y H:i');
        } catch (Throwable) {
            return '';
        }
    }

    private static function translate(string $value): string
    {
        $prefix = 'lang.storefront.';
        if (!str_starts_with($value, $prefix)) {
            return $value;
        }

        $parts = explode('.', substr($value, strlen($prefix)));
        $generic = [
            'button', 'default', 'description', 'label', 'message',
            'placeholder', 'plural', 'singular', 'text', 'title',
        ];
        while (count($parts) > 1 && in_array(end($parts), $generic, true)) {
            array_pop($parts);
        }

        $term = (string) end($parts);
        $labels = [
            'add_to_cart' => 'Add to cart',
            'ask_country' => 'Select your country',
            'change_country' => 'Change country',
            'checkout' => 'Checkout',
            'choose_country' => 'Choose country',
            'copyright' => 'All rights reserved',
            'greetings' => 'Hello',
            'keep_buying' => 'Continue shopping',
            'my_account' => 'My account',
            'poweredby' => 'Powered by Shopkit',
            'see_cart' => 'View cart',
            'signin' => 'Sign in',
        ];
        if (isset($labels[$term])) {
            return $labels[$term];
        }

        $label = preg_replace('/[_-]+/', ' ', $term) ?? $term;
        return ucfirst($label);
    }

    private static function escape(string $value): string
    {
        return htmlspecialchars($value, ENT_QUOTES | ENT_SUBSTITUTE | ENT_HTML5, 'UTF-8');
    }
}
