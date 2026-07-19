<?php

declare(strict_types=1);

namespace Shopkit\Themes\Tests;

use PHPUnit\Framework\TestCase;
use Shopkit\Themes\PreviewServer;

final class PreviewServerTest extends TestCase
{
    public function testCspAllowsOnlyLocalNonExecutablePreviewResources(): void
    {
        $csp = PreviewServer::contentSecurityPolicy();

        self::assertSame(
            "default-src 'none'; script-src 'none'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self' data:; connect-src 'none'; media-src 'self'; frame-src 'none'; object-src 'none'; base-uri 'none'; form-action 'none'; frame-ancestors 'none'; worker-src 'none'; manifest-src 'none'",
            $csp
        );

        foreach ([
            "default-src 'none'",
            "script-src 'none'",
            "connect-src 'none'",
            "frame-src 'none'",
            "object-src 'none'",
            "form-action 'none'",
            "img-src 'self' data:",
        ] as $directive) {
            self::assertStringContainsString($directive, $csp);
        }
    }

    public function testSanitizesActiveAndExternalBrowserCapabilities(): void
    {
        $html = <<<'HTML'
<!doctype html><html><head>
<link rel="stylesheet" href="https://cdn.example/theme.css">
<script src="/theme.js"></script>
</head><body onload="steal()">
<a href="javascript:steal()">bad</a>
<a href="https://example.com">external</a>
<form action="https://example.com/pay"><input></form>
<iframe src="https://example.com"></iframe>
<img src="https://example.com/pixel.gif">
</body></html>
HTML;

        $safe = (new PreviewServer())->sanitize($html);

        self::assertStringNotContainsString('<script', $safe);
        self::assertStringNotContainsString('<iframe', $safe);
        self::assertStringNotContainsString('onload=', $safe);
        self::assertStringNotContainsString('javascript:', $safe);
        self::assertStringNotContainsString('https://', $safe);
        self::assertStringContainsString('<form', $safe);
        self::assertStringContainsString('action="#"', $safe);
    }

    public function testRemovesAttributionAndDocumentReferrerOverrides(): void
    {
        $html = <<<'HTML'
<html><head><meta name="referrer" content="unsafe-url"></head><body>
<img src="/image.jpg" attributionsrc="https://evil.example/register">
</body></html>
HTML;

        $safe = (new PreviewServer())->sanitize($html);

        self::assertStringNotContainsStringIgnoringCase('attributionsrc', $safe);
        self::assertDoesNotMatchRegularExpression('/<meta\b[^>]*name=["\']?referrer/i', $safe);
        self::assertStringNotContainsString('evil.example', $safe);
    }

    public function testRejectsPreviewMarkupThatExceedsResourceLimits(): void
    {
        $html = '<html><body>'.str_repeat('<i></i>', 250_001).'</body></html>';

        $this->expectException(\RuntimeException::class);
        $this->expectExceptionMessage('resource limits');

        (new PreviewServer())->sanitize($html);
    }

    public function testPreservesLocalResourcesAndImageDataUrls(): void
    {
        $html = <<<'HTML'
<html><head>
<link rel="stylesheet" href="/assets/theme.css">
<style>.hero { background-image: url('/assets/hero.jpg') } .icon { background-image: url(data:image/png;base64,iVBORw0KGgo=) }</style>
</head><body>
<a href="/products/example?color=red#details">Product</a>
<img src="./images/product.jpg" srcset="./images/product.jpg 1x, /images/product@2x.jpg 2x">
<img src="data:image/png;base64,iVBORw0KGgo=">
</body></html>
HTML;

        $safe = (new PreviewServer())->sanitize($html);

        self::assertStringContainsString('href="/assets/theme.css"', $safe);
        self::assertStringContainsString('href="/products/example?color=red#details"', $safe);
        self::assertStringContainsString('src="./images/product.jpg"', $safe);
        self::assertStringContainsString('srcset="./images/product.jpg 1x, /images/product@2x.jpg 2x"', $safe);
        self::assertStringContainsString('data:image/png;base64,iVBORw0KGgo=', $safe);
        self::assertStringContainsString("url('/assets/hero.jpg')", $safe);
    }

    public function testSanitizesMixedCaseSvgMathMlAndNamespacedCapabilities(): void
    {
        $html = <<<'HTML'
<html><head>
<META HTTP-EQUIV="ReFrEsH" CONTENT="0; URL=https://evil.example">
<BASE href="https://evil.example/">
</head><body>
<ScRiPt>alert(1)</ScRiPt>
<FrAmE src="//evil.example"></FrAmE>
<OBJECT data="/payload"></OBJECT><EMBED src="/payload"><APPLET code="Bad.class"></APPLET>
<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
  <script>alert(2)</script>
  <a xlink:href="JaVaScRiPt:alert(3)" ONCLICK="alert(4)"><text>safe label</text></a>
  <image href="https://evil.example/track.svg"></image>
  <foreignObject><iframe src="/nested"></iframe></foreignObject>
</svg>
<math xmlns="http://www.w3.org/1998/Math/MathML">
  <annotation-xml encoding="text/html"><script>alert(5)</script><a href="data:text/html,&lt;script&gt;alert(6)&lt;/script&gt;">bad</a></annotation-xml>
</math>
</body></html>
HTML;

        $safe = (new PreviewServer())->sanitize($html);

        self::assertDoesNotMatchRegularExpression('/<(?:script|frame|iframe|object|embed|applet|base)\b/i', $safe);
        self::assertDoesNotMatchRegularExpression('/<meta\b[^>]*http-equiv=["\']?refresh/i', $safe);
        self::assertDoesNotMatchRegularExpression('/\son[a-z0-9:_-]*\s*=/i', $safe);
        self::assertStringNotContainsStringIgnoringCase('javascript:', $safe);
        self::assertStringNotContainsStringIgnoringCase('data:text/html', $safe);
        self::assertStringNotContainsString('evil.example', $safe);
        self::assertStringContainsString('safe label', $safe);
    }

    public function testHandlesMalformedHtmlWithoutLeavingExecutableMarkup(): void
    {
        $html = <<<'HTML'
<!doctype html><title>Preview</title><body>
<div><SCRIPT SRC=//evil.example/x.js><p>broken
<img src=//evil.example/pixel onerror=alert(1)>
<form action=//evil.example/pay><button formaction="jav&#x09;ascript:alert(2)">Pay
<noscript><meta http-equiv=refresh content="0;url=//evil.example/escape"></noscript>
HTML;

        $safe = (new PreviewServer())->sanitize($html);

        self::assertNotSame('', trim($safe));
        self::assertDoesNotMatchRegularExpression('/<(?:script|iframe|frame|object|embed|base|noscript)\b/i', $safe);
        self::assertDoesNotMatchRegularExpression('/\son[a-z0-9:_-]*\s*=/i', $safe);
        self::assertStringNotContainsString('evil.example', $safe);
        self::assertStringNotContainsStringIgnoringCase('javascript:', $safe);
    }

    public function testSanitizesExternalAndExecutableUrlsInAttributesAndCss(): void
    {
        $html = <<<'HTML'
<html><head><style>
@import "https://evil.example/theme.css";
.external { background: url(//evil.example/pixel) }
.local { background: url(/images/local.png) }
</style></head><body>
<a href="  java&#x0A;script:alert(1)">one</a>
<a href="data:text/html;base64,PHNjcmlwdD4=">two</a>
<a href="//evil.example/path">three</a>
<img src="https://evil.example/pixel" srcset="/safe.png 1x, https://evil.example/two.png 2x">
<div style="background:url(&quot;https://evil.example/style&quot;); color:red">content</div>
<svg><rect filter="url(https://evil.example/filter.svg#blur)" fill="url(/images/local.svg#gradient)"></rect></svg>
<form action="/pay"><button formaction="/pay">Pay</button></form>
</body></html>
HTML;

        $safe = (new PreviewServer())->sanitize($html);

        self::assertStringNotContainsString('evil.example', $safe);
        self::assertStringNotContainsStringIgnoringCase('javascript:', $safe);
        self::assertStringNotContainsStringIgnoringCase('data:text/html', $safe);
        self::assertStringContainsString('url(/images/local.png)', $safe);
        self::assertStringContainsString('fill="url(/images/local.svg#gradient)"', $safe);
        self::assertStringContainsString('color:red', $safe);
        self::assertStringContainsString('action="#"', $safe);
        self::assertStringContainsString('formaction="#"', $safe);
    }

    public function testSanitizesACompiledStylesheetBeforeServingIt(): void
    {
        $css = <<<'CSS'
@import "https://evil.example/theme.css";
.external { background: url(https://evil.example/pixel.png); behavior: url(/evil.htc) }
.local { background: url('/images/local.png') }
CSS;

        $safe = (new PreviewServer())->sanitizeStylesheet($css);

        self::assertStringNotContainsString('evil.example', $safe);
        self::assertStringNotContainsStringIgnoringCase('@import', $safe);
        self::assertStringNotContainsStringIgnoringCase('behavior:', $safe);
        self::assertStringContainsString("url('/images/local.png')", $safe);
    }

    public function testRejectsSvgAndNonBase64DataImages(): void
    {
        $html = <<<'HTML'
<html><body>
<img src="data:image/svg+xml,&lt;svg onload=alert(1)&gt;">
<img src="data:image/png,not-base64">
<img src="data:image/webp;base64,UklGRgAAAABXRUJQ">
</body></html>
HTML;

        $safe = (new PreviewServer())->sanitize($html);

        self::assertStringNotContainsString('svg+xml', $safe);
        self::assertStringNotContainsString('not-base64', $safe);
        self::assertStringContainsString('data:image/webp;base64,UklGRgAAAABXRUJQ', $safe);
    }

    public function testRejectsDataImagesWhoseBytesDoNotMatchTheirMimeType(): void
    {
        $html = <<<'HTML'
<html><body>
<img src="data:image/png;base64,PHN2Zz48L3N2Zz4=">
<img src="data:image/gif;base64,iVBORw0KGgo=">
<img src="data:image/png;base64,iVBORw0KGgo=">
</body></html>
HTML;

        $safe = (new PreviewServer())->sanitize($html);

        self::assertStringNotContainsString('PHN2Zz48L3N2Zz4=', $safe);
        self::assertStringNotContainsString('data:image/gif;base64,iVBORw0KGgo=', $safe);
        self::assertStringContainsString('data:image/png;base64,iVBORw0KGgo=', $safe);
    }

    public function testRemovesEmptyOrBlockedStylesheetLinks(): void
    {
        $html = <<<'HTML'
<html><head>
<link rel="stylesheet" href="">
<link rel="stylesheet preload" href="https://evil.example/theme.css">
<link rel="stylesheet" href="/local.css">
</head><body></body></html>
HTML;

        $safe = (new PreviewServer())->sanitize($html);

        self::assertStringNotContainsString('evil.example', $safe);
        self::assertDoesNotMatchRegularExpression('/<link\b[^>]*rel="[^"]*stylesheet[^"]*"[^>]*href="(?:|#)"/i', $safe);
        self::assertStringContainsString('href="/local.css"', $safe);
    }
}
