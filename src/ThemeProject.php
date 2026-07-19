<?php

declare(strict_types=1);

namespace Shopkit\Themes;

use FilesystemIterator;
use InvalidArgumentException;
use RecursiveDirectoryIterator;
use RecursiveIteratorIterator;
use SplFileInfo;

final class ThemeProject
{
    private const MAX_FILES = 100;
    private const MAX_TOTAL_BYTES = 10_485_760;
    private const MAX_TEMPLATE_BYTES = 262_144;
    private const MAX_LESS_BYTES = 1_048_576;
    private const MAX_JAVASCRIPT_BYTES = 2_097_152;

    private string $root;
    private array $templates = [];
    private string $less = '';

    public function __construct(string $path)
    {
        if (str_contains($path, "\0")) {
            throw new InvalidArgumentException('Theme path contains a null byte.');
        }

        $root = realpath($path);
        if ($root === false || !is_dir($root) || !is_readable($root)) {
            throw new InvalidArgumentException('Theme directory does not exist or is not readable.');
        }

        $linkPath = rtrim($path, "/\\");
        if ($linkPath !== '' && is_link($linkPath)) {
            throw new InvalidArgumentException('Theme directory must not be a symbolic link.');
        }

        $this->root = $root;
        $this->load();
    }

    public function root(): string
    {
        return $this->root;
    }

    public function name(): string
    {
        return basename($this->root);
    }

    public function fixtureName(): string
    {
        $header = substr($this->templates['base.tpl'] ?? '', 0, 1_024);
        foreach (['boxie', 'default', 'minimal', 'mosaic'] as $fixture) {
            if (preg_match('/Shopkit Starter:\s*'.preg_quote($fixture, '/').'\b/i', $header) === 1) {
                return $fixture;
            }
        }

        foreach ([
            'boxie' => '/Template Name:\s*Boxie\b/i',
            'minimal' => '/Template Name:\s*Minimal\b/i',
            'mosaic' => '/Template Name:\s*Mosaic\b/i',
            'default' => '/Template Name:\s*Shopkit Default Template\b/i',
        ] as $fixture => $pattern) {
            if (preg_match($pattern, $header) === 1) {
                return $fixture;
            }
        }

        return 'default';
    }

    public function templates(): array
    {
        return $this->templates;
    }

    public function less(): string
    {
        return $this->less;
    }

    public function pages(): array
    {
        return array_map(
            static fn (string $name): string => substr($name, 0, -4),
            array_keys($this->templates)
        );
    }

    private function load(): void
    {
        $iterator = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($this->root, FilesystemIterator::SKIP_DOTS),
            RecursiveIteratorIterator::SELF_FIRST
        );

        $seen = [];
        $count = 0;
        $entries = 0;
        $totalBytes = 0;

        /** @var SplFileInfo $file */
        foreach ($iterator as $file) {
            $absolute = $file->getPathname();
            $relative = str_replace(DIRECTORY_SEPARATOR, '/', substr($absolute, strlen($this->root) + 1));

            ++$entries;
            if ($entries > self::MAX_FILES + 2) {
                throw new InvalidArgumentException('Theme contains too many files or directories.');
            }

            if ($file->isLink()) {
                throw new InvalidArgumentException(sprintf('Theme contains a symbolic link: %s.', $relative));
            }

            if ($file->isDir()) {
                if (!in_array($relative, ['css', 'js'], true)) {
                    throw new InvalidArgumentException(sprintf('Theme contains a directory that is not allowed: %s.', $relative));
                }
                continue;
            }

            if (!$file->isFile()) {
                throw new InvalidArgumentException(sprintf('Theme contains a non-regular file: %s.', $relative));
            }

            $key = strtolower($relative);
            if (isset($seen[$key]) && $seen[$key] !== $relative) {
                throw new InvalidArgumentException(sprintf(
                    'Theme contains a case-insensitive filename collision: %s and %s.',
                    $seen[$key],
                    $relative
                ));
            }
            $seen[$key] = $relative;

            ++$count;
            if ($count > self::MAX_FILES) {
                throw new InvalidArgumentException('Theme contains too many files.');
            }

            if ($this->isTemplate($relative)) {
                if ($file->getSize() > self::MAX_TEMPLATE_BYTES) {
                    throw new InvalidArgumentException(sprintf('Template exceeds 256 KB: %s.', $relative));
                }
                $source = $this->readStable(
                    $absolute,
                    $relative,
                    self::MAX_TEMPLATE_BYTES,
                    sprintf('Template exceeds 256 KB: %s.', $relative)
                );
                $this->addTotalBytes($totalBytes, strlen($source));
                $this->assertUtf8($source, $relative);
                $this->templates[$relative] = $source;
                continue;
            }

            if ($relative === 'css/style.less') {
                if ($file->getSize() > self::MAX_LESS_BYTES) {
                    throw new InvalidArgumentException('css/style.less exceeds 1 MB.');
                }
                $this->less = $this->readStable(
                    $absolute,
                    $relative,
                    self::MAX_LESS_BYTES,
                    'css/style.less exceeds 1 MB.'
                );
                $this->addTotalBytes($totalBytes, strlen($this->less));
                $this->assertUtf8($this->less, $relative);
                continue;
            }

            if (in_array($relative, ['js/plugins.js', 'js/script.js'], true)) {
                if ($file->getSize() > self::MAX_JAVASCRIPT_BYTES) {
                    throw new InvalidArgumentException(sprintf('JavaScript file exceeds 2 MB: %s.', $relative));
                }
                $source = $this->readStable(
                    $absolute,
                    $relative,
                    self::MAX_JAVASCRIPT_BYTES,
                    sprintf('JavaScript file exceeds 2 MB: %s.', $relative)
                );
                $this->addTotalBytes($totalBytes, strlen($source));
                $this->assertUtf8($source, $relative);
                continue;
            }

            if (in_array($relative, ['README.md', 'LICENSE', 'THIRD_PARTY_NOTICES.md', 'LICENSE-APACHE-2.0.txt'], true)) {
                $source = $this->readStable(
                    $absolute,
                    $relative,
                    self::MAX_TOTAL_BYTES,
                    $relative.' exceeds the theme size limit.'
                );
                $this->addTotalBytes($totalBytes, strlen($source));
                $this->assertUtf8($source, $relative);
                continue;
            }

            throw new InvalidArgumentException(sprintf('File is not allowed in a Shopkit theme: %s.', $relative));
        }

        ksort($this->templates, SORT_STRING);

        foreach (['base.tpl', 'home.tpl'] as $required) {
            if (!array_key_exists($required, $this->templates)) {
                throw new InvalidArgumentException(sprintf('Theme is missing required file: %s.', $required));
            }
        }

        if ($this->less === '') {
            throw new InvalidArgumentException('Theme is missing required file: css/style.less.');
        }
    }

    private function isTemplate(string $relative): bool
    {
        return preg_match('/\A[a-z0-9][a-z0-9-]*\.tpl\z/D', $relative) === 1;
    }

    private function assertUtf8(string $source, string $relative): void
    {
        if (preg_match('//u', $source) !== 1) {
            throw new InvalidArgumentException(sprintf('File is not valid UTF-8: %s.', $relative));
        }
    }

    private function readStable(string $absolute, string $relative, int $maxBytes, string $sizeError): string
    {
        $before = lstat($absolute);
        if ($before === false || !is_file($absolute) || is_link($absolute)) {
            throw new InvalidArgumentException(sprintf('File changed while being read: %s.', $relative));
        }

        $handle = @fopen($absolute, 'rb');
        if ($handle === false) {
            throw new InvalidArgumentException(sprintf('File could not be read: %s.', $relative));
        }

        try {
            $opened = fstat($handle);
            if ($opened === false || !$this->sameFile($before, $opened)) {
                throw new InvalidArgumentException(sprintf('File changed while being read: %s.', $relative));
            }

            $source = stream_get_contents($handle, $maxBytes + 1);
            $openedAfter = fstat($handle);
        } finally {
            fclose($handle);
        }

        $pathAfter = lstat($absolute);

        if (is_string($source) && strlen($source) > $maxBytes) {
            throw new InvalidArgumentException($sizeError);
        }

        if ($source === false
            || $openedAfter === false
            || $pathAfter === false
            || !$this->sameFile($before, $openedAfter)
            || !$this->sameFile($openedAfter, $pathAfter)
            || strlen($source) !== $openedAfter['size']) {
            throw new InvalidArgumentException(sprintf('File changed while being read: %s.', $relative));
        }

        return $source;
    }

    private function sameFile(array $before, array $after): bool
    {
        foreach (['dev', 'ino', 'mode', 'size', 'mtime', 'ctime'] as $key) {
            if ($before[$key] !== $after[$key]) {
                return false;
            }
        }

        return true;
    }

    private function addTotalBytes(int &$totalBytes, int $bytes): void
    {
        $totalBytes += $bytes;
        if ($totalBytes > self::MAX_TOTAL_BYTES) {
            throw new InvalidArgumentException('Theme exceeds the 10 MB size limit.');
        }
    }
}
