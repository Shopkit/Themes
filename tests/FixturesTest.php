<?php

declare(strict_types=1);

namespace Shopkit\Themes\Tests;

use InvalidArgumentException;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;
use Shopkit\Themes\Fixtures;

final class FixturesTest extends TestCase
{
    private Fixtures $fixtures;

    protected function setUp(): void
    {
        $this->fixtures = new Fixtures(dirname(__DIR__));
    }

    #[DataProvider('officialThemes')]
    public function testLoadsCompleteOfficialThemeOptionFiles(string $theme, string $basecolor): void
    {
        $options = $this->fixtures->themeOptions($theme);

        self::assertSame($basecolor, $options['basecolor']);
        self::assertSame('60', $options['logo_height']);
        self::assertSame('block', $options['show_section_gpsr']);
        self::assertArrayHasKey('body_background_color', $options);
        self::assertArrayHasKey('body_text_color', $options);
    }

    public static function officialThemes(): array
    {
        return [
            'default' => ['default', '#db0a5b'],
            'boxie' => ['boxie', '#088765'],
            'minimal' => ['minimal', '#0f7884'],
            'mosaic' => ['mosaic', '#c44f40'],
        ];
    }

    public function testBuildsACompleteLocalContextWithoutRealStoreData(): void
    {
        $context = $this->fixtures->context('boxie', '/preview-token');

        foreach ([
            'title', 'description', 'tags', 'canonical_url', 'fonts', 'icon_library', 'head_content',
            'footer_content', 'css_class', 'current_page', 'rewards_label', 'pagination_segment',
            'countries', 'locales', 'store', 'apps', 'cart', 'user', 'events', 'errors', 'warnings',
            'success', 'get', 'product', 'category', 'brand', 'tag', 'blog_post', 'page', 'order',
        ] as $root) {
            self::assertArrayHasKey($root, $context);
        }

        self::assertSame('/preview-token/__theme/style.css', $context['store']['assets']['css']);
        self::assertSame('#088765', $context['store']['theme_options']['basecolor']);
        self::assertSame('preview@example.invalid', $context['user']['email']);
        self::assertSame('/preview-token/__theme/placeholder.svg', $context['product']['image']['full']);
        self::assertSame('/preview-token/product/demo-product', $context['product']['url']);
        self::assertSame('/preview-token/catalog', $context['store']['navigation']['primary'][1]['menu_url']);

        $encoded = json_encode($context, JSON_THROW_ON_ERROR);
        self::assertDoesNotMatchRegularExpression('~https?://(?!127\.0\.0\.1(?::\d+)?(?:/|"))~i', $encoded);
        self::assertStringNotContainsString('shopkit.test', $encoded);
        self::assertStringNotContainsString('usercontent', $encoded);
    }

    public function testProductAliasesAreDeterministicAndSearchHasItsExpectedShape(): void
    {
        $first = $this->fixtures->products('limit:1');
        $again = $this->fixtures->products('limit:1');
        $search = $this->fixtures->products('search order:relevance limit:1');

        self::assertSame($first, $again);
        self::assertCount(1, $first);
        self::assertSame('Produto de exemplo', $first[0]['title']);
        self::assertSame('demo', $search['query']);
        self::assertSame(2, $search['total_results']);
        self::assertCount(1, $search['results']);
    }

    public function testCollectionAliasesUseSmallSyntheticDatasets(): void
    {
        self::assertCount(2, $this->fixtures->categories());
        self::assertSame('Accessories', $this->fixtures->category(11)['title']);
        self::assertSame([], $this->fixtures->category(999));
        self::assertSame('Demo brand', $this->fixtures->brands()[0]['title']);
        self::assertSame('Demo post', $this->fixtures->blogPosts()[0]['title']);
        self::assertSame('Preview Reviewer', $this->fixtures->reviews()['reviews'][0]['name']);
    }

    #[DataProvider('officialThemes')]
    public function testGeneratesCompleteLessVariablesFromOfficialDefaults(string $theme): void
    {
        $less = $this->fixtures->templateVariables($theme);

        self::assertStringContainsString(':root {', $less);
        self::assertStringContainsString('@logo_height: 60;', $less);
        self::assertStringContainsString('@link_color: @basecolor;', $less);
        self::assertStringContainsString('--basecolor: @basecolor;', $less);

        preg_match_all('/@([a-zA-Z0-9_-]+)\s*:/', $less, $declarations);
        preg_match_all('/@([a-zA-Z0-9_-]+)/', $less, $references);
        self::assertSame(
            [],
            array_values(array_diff(array_unique($references[1]), array_unique($declarations[1]))),
            'Every fixture LESS variable must be declared.'
        );
    }

    public function testRejectsUnknownThemeNames(): void
    {
        $this->expectException(InvalidArgumentException::class);
        $this->fixtures->themeOptions('../private');
    }

    #[DataProvider('invalidAssetBases')]
    public function testRejectsAssetBasesThatAreNotPlainLocalPaths(string $assetBase): void
    {
        $this->expectException(InvalidArgumentException::class);
        $this->fixtures->context('default', $assetBase);
    }

    public static function invalidAssetBases(): array
    {
        return [
            'scheme-relative URL' => ['//example.invalid/theme'],
            'query string' => ['/preview?asset=remote'],
            'fragment' => ['/preview#remote'],
            'control character' => ["/preview\nremote"],
        ];
    }
}
