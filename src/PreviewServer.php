<?php

declare(strict_types=1);

namespace Shopkit\Themes;

use DOMAttr;
use DOMComment;
use DOMDocument;
use DOMElement;
use DOMNode;
use DOMXPath;
use RuntimeException;

final class PreviewServer
{
    public const MAX_PREVIEW_BYTES = 2_000_000;
    private const MAX_MARKUP_DELIMITERS = 100_000;
    private const MAX_DATA_IMAGE_BYTES = 1_000_000;

    private const CSP = "default-src 'none'; script-src 'none'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self' data:; connect-src 'none'; media-src 'self'; frame-src 'none'; object-src 'none'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'; worker-src 'none'; manifest-src 'none'";

    /** @var array<string, true> */
    private const BLOCKED_ELEMENTS = [
        'applet' => true,
        'base' => true,
        'embed' => true,
        'fencedframe' => true,
        'frame' => true,
        'frameset' => true,
        'iframe' => true,
        'noscript' => true,
        'object' => true,
        'portal' => true,
        'script' => true,
    ];

    /** @var array<string, true> */
    private const URL_ATTRIBUTES = [
        'archive' => true,
        'background' => true,
        'cite' => true,
        'classid' => true,
        'codebase' => true,
        'data' => true,
        'dynsrc' => true,
        'href' => true,
        'icon' => true,
        'longdesc' => true,
        'lowsrc' => true,
        'manifest' => true,
        'poster' => true,
        'profile' => true,
        'src' => true,
        'usemap' => true,
    ];

    public static function contentSecurityPolicy(): string
    {
        return self::CSP;
    }

    public function sanitize(string $html): string
    {
        if ($html === '') {
            return '';
        }
        if (strlen($html) > self::MAX_PREVIEW_BYTES
            || substr_count($html, '<') > self::MAX_MARKUP_DELIMITERS) {
            throw new RuntimeException('The preview HTML exceeds resource limits.');
        }

        // libxml's HTML4 parser treats the HTML5 <embed> void element as a
        // container. Remove its tags before parsing so a valid, unclosed
        // <embed> cannot make the sanitizer discard the rest of the page.
        $html = preg_replace('/<\s*\/?\s*embed\b[^>]*>/i', '', $html) ?? '';

        $document = new DOMDocument('1.0', 'UTF-8');
        $previousErrors = libxml_use_internal_errors(true);

        try {
            $loaded = $document->loadHTML(
                $html,
                LIBXML_NONET | LIBXML_NOERROR | LIBXML_NOWARNING | LIBXML_COMPACT
            );
        } finally {
            libxml_clear_errors();
            libxml_use_internal_errors($previousErrors);
        }

        if ($loaded === false) {
            throw new RuntimeException('The preview HTML could not be parsed.');
        }

        if ($document->doctype !== null && $document->doctype->parentNode !== null) {
            $document->doctype->parentNode->removeChild($document->doctype);
        }

        $xpath = new DOMXPath($document);
        $elements = [];
        foreach ($xpath->query('//*') ?: [] as $node) {
            if ($node instanceof DOMElement) {
                $elements[] = $node;
            }
        }

        // Work from leaves to roots so namespace and foreign-content descendants
        // are sanitized before a blocked parent is detached.
        foreach (array_reverse($elements) as $element) {
            if ($element->parentNode === null) {
                continue;
            }

            $name = $this->localName($element);
            if (isset(self::BLOCKED_ELEMENTS[$name]) || $this->isBlockedMeta($element, $name)) {
                $element->parentNode->removeChild($element);
                continue;
            }

            $this->sanitizeAttributes($element, $name);

            if ($name === 'link' && $this->isEmptyStylesheet($element)) {
                $element->parentNode->removeChild($element);
                continue;
            }

            if ($name === 'style') {
                $element->textContent = $this->sanitizeCss($element->textContent);
            }
        }

        // Conditional comments can be interpreted as markup by old embedded
        // browsers. Comments are not needed to preview a theme.
        $comments = [];
        foreach ($xpath->query('//comment()') ?: [] as $node) {
            if ($node instanceof DOMComment) {
                $comments[] = $node;
            }
        }
        foreach ($comments as $comment) {
            if ($comment->parentNode !== null) {
                $comment->parentNode->removeChild($comment);
            }
        }

        $safe = $document->saveHTML();

        if ($safe === false) {
            throw new RuntimeException('The preview HTML could not be serialized.');
        }

        return $safe;
    }

    public function sanitizeStylesheet(string $css): string
    {
        if (strlen($css) > self::MAX_PREVIEW_BYTES) {
            throw new RuntimeException('The preview stylesheet exceeds resource limits.');
        }

        return $this->sanitizeCss($css);
    }

    private function sanitizeAttributes(DOMElement $element, string $elementName): void
    {
        $attributes = [];
        foreach ($element->attributes as $attribute) {
            if ($attribute instanceof DOMAttr) {
                $attributes[] = $attribute;
            }
        }

        foreach ($attributes as $attribute) {
            $name = $this->localName($attribute);
            $qualifiedName = $attribute->nodeName;

            if (str_starts_with($name, 'on') || in_array($name, ['attributionsrc', 'ping', 'srcdoc'], true)) {
                $element->removeAttributeNode($attribute);
                continue;
            }

            if ($name === 'style') {
                $css = $this->sanitizeCss($attribute->value);
                if (trim($css) === '') {
                    $element->removeAttributeNode($attribute);
                } else {
                    $element->setAttribute($qualifiedName, $css);
                }
                continue;
            }

            // SVG presentation attributes such as filter, fill, mask and
            // clip-path accept CSS url() values even though they are not
            // ordinary URL attributes.
            if (preg_match('/url\s*\(/i', $attribute->value) === 1) {
                $element->setAttribute($qualifiedName, $this->sanitizeCss($attribute->value));
                continue;
            }

            if ($name === 'action' || $name === 'formaction') {
                $element->setAttribute($qualifiedName, '#');
                continue;
            }

            if ($name === 'srcset' || $name === 'imagesrcset') {
                $allowDataImage = in_array($elementName, ['img', 'source'], true);
                if (!$this->isSafeSrcset($attribute->value, $allowDataImage)) {
                    $element->removeAttributeNode($attribute);
                }
                continue;
            }

            if (!isset(self::URL_ATTRIBUTES[$name])) {
                continue;
            }

            $allowDataImage = $name === 'src' && in_array($elementName, ['img', 'source'], true);
            if ($this->isSafeUrl($attribute->value, $allowDataImage)) {
                continue;
            }

            if ($name === 'href') {
                $element->setAttribute($qualifiedName, '#');
            } else {
                $element->removeAttributeNode($attribute);
            }
        }
    }

    private function sanitizeCss(string $css): string
    {
        // Imports are unnecessary after LESS compilation and permit fetches
        // before ordinary declarations are evaluated.
        $css = preg_replace(
            '/@import\s+(?:url\s*\([^;]*\)|["\'][^"\']*["\'])[^;]*;?/is',
            '',
            $css
        ) ?? '';

        $css = preg_replace_callback(
            '/url\s*\(\s*(?:([' . "'\"" . '])(.*?)\1|([^)]*))\s*\)/is',
            function (array $match): string {
                $quote = $match[1] ?? '';
                $url = $match[2] !== '' ? $match[2] : ($match[3] ?? '');

                if (!$this->isSafeUrl($url, true)) {
                    return 'url("")';
                }

                return 'url(' . $quote . trim($url) . $quote . ')';
            },
            $css
        ) ?? '';

        // These legacy CSS features can execute or load browser-specific
        // bindings. Dropping the containing declaration is safer than trying
        // to parse their grammars without a full CSS parser.
        $css = preg_replace(
            '/(?:^|;)\s*[^;{}]*(?:expression\s*\(|behavior\s*:|-moz-binding\s*:)[^;{}]*;?/is',
            ';',
            $css
        ) ?? '';

        return $css;
    }

    private function isSafeUrl(string $url, bool $allowDataImage): bool
    {
        $url = html_entity_decode($url, ENT_QUOTES | ENT_HTML5, 'UTF-8');
        $url = trim($url);

        if ($url === '') {
            return true;
        }

        // Backslashes and embedded ASCII whitespace are interpreted
        // inconsistently between URL consumers. Do not accept them in the
        // preview's deliberately small local-URL subset.
        if (str_contains($url, '\\')) {
            return false;
        }

        $compact = preg_replace('/[\x00-\x20\x7f]+/', '', $url) ?? '';
        $lower = strtolower($compact);

        if ($allowDataImage && str_starts_with($lower, 'data:')) {
            return $this->isSafeDataImage($compact);
        }

        if (str_starts_with($lower, '//')) {
            return false;
        }

        if (preg_match('/^[a-z][a-z0-9+.-]*:/i', $lower) === 1) {
            return false;
        }

        return true;
    }

    private function isSafeDataImage(string $url): bool
    {
        if (preg_match(
            '#\Adata:image/(png|gif|jpeg|webp|avif);base64,([a-z0-9+/]+={0,2})\z#iD',
            $url,
            $matches
        ) !== 1 || strlen($matches[2]) > 1_333_336) {
            return false;
        }

        $bytes = base64_decode($matches[2], true);
        if ($bytes === false || $bytes === '' || strlen($bytes) > self::MAX_DATA_IMAGE_BYTES) {
            return false;
        }

        return match (strtolower($matches[1])) {
            'png' => str_starts_with($bytes, "\x89PNG\r\n\x1a\n"),
            'gif' => str_starts_with($bytes, 'GIF87a') || str_starts_with($bytes, 'GIF89a'),
            'jpeg' => str_starts_with($bytes, "\xff\xd8\xff"),
            'webp' => strlen($bytes) >= 12
                && str_starts_with($bytes, 'RIFF')
                && substr($bytes, 8, 4) === 'WEBP',
            'avif' => strlen($bytes) >= 12
                && substr($bytes, 4, 4) === 'ftyp'
                && in_array(substr($bytes, 8, 4), ['avif', 'avis'], true),
            default => false,
        };
    }

    private function isEmptyStylesheet(DOMElement $element): bool
    {
        $relations = preg_split('/\s+/', strtolower(trim($element->getAttribute('rel'))), -1, PREG_SPLIT_NO_EMPTY) ?: [];
        if (!in_array('stylesheet', $relations, true)) {
            return false;
        }

        return in_array(trim($element->getAttribute('href')), ['', '#'], true);
    }

    private function isSafeSrcset(string $srcset, bool $allowDataImage): bool
    {
        $srcset = html_entity_decode($srcset, ENT_QUOTES | ENT_HTML5, 'UTF-8');

        if (str_contains($srcset, '\\')) {
            return false;
        }

        $compact = strtolower(preg_replace('/[\x00-\x20\x7f]+/', '', $srcset) ?? '');
        if (preg_match('/(?:^|,)\/\//', $compact) === 1) {
            return false;
        }

        if (str_contains($compact, 'data:')) {
            return false;
        }

        if (preg_match('/[a-z][a-z0-9+.-]*:/i', $compact) === 1) {
            return false;
        }

        return true;
    }

    private function isBlockedMeta(DOMElement $element, string $name): bool
    {
        if ($name !== 'meta') {
            return false;
        }

        foreach ($element->attributes as $attribute) {
            if ($attribute instanceof DOMAttr
                && $this->localName($attribute) === 'http-equiv') {
                return true;
            }
            if ($attribute instanceof DOMAttr
                && $this->localName($attribute) === 'name'
                && strtolower(trim($attribute->value)) === 'referrer') {
                return true;
            }
        }

        return false;
    }

    private function localName(DOMNode $node): string
    {
        $name = $node->localName ?: $node->nodeName;
        $colon = strrpos($name, ':');
        if ($colon !== false) {
            $name = substr($name, $colon + 1);
        }

        return strtolower($name);
    }
}
