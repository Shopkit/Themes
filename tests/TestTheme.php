<?php

declare(strict_types=1);

namespace Shopkit\Themes\Tests;

final class TestTheme
{
    public static function create(array $templates = [], ?string $less = null): string
    {
        $root = sys_get_temp_dir().'/shopkit-theme-test-'.bin2hex(random_bytes(8));
        mkdir($root.'/css', 0700, true);

        $templates += [
            'base.tpl' => '<!doctype html><html><head><link rel="stylesheet" href="{{ store.assets.css }}"></head><body>{% block content %}{% endblock %}</body></html>',
            'home.tpl' => "{% extends 'base.tpl' %}{% block content %}Home{% endblock %}",
        ];

        foreach ($templates as $name => $source) {
            file_put_contents($root.'/'.$name, $source);
        }

        file_put_contents(
            $root.'/css/style.less',
            $less ?? "@import \"template-vars.less\";\nbody { color: @body_text_color; }\n"
        );

        return $root;
    }

    public static function remove(string $path): void
    {
        if (is_link($path) || (file_exists($path) && !is_dir($path))) {
            unlink($path);
            return;
        }

        if (!is_dir($path)) {
            return;
        }

        foreach (new \FilesystemIterator($path) as $item) {
            self::remove($item->getPathname());
        }

        rmdir($path);
    }
}
