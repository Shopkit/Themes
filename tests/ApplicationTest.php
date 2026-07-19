<?php

declare(strict_types=1);

namespace Shopkit\Themes\Tests;

use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;
use Shopkit\Themes\Application;

final class ApplicationTest extends TestCase
{
    private array $paths = [];

    protected function tearDown(): void
    {
        foreach (array_reverse($this->paths) as $path) {
            TestTheme::remove($path);
        }
    }

    public function testHelpIsSmallAndListsOnlyPublicCommands(): void
    {
        [$status, $out, $err] = $this->runCli(['shopkit-themes', '--help']);

        self::assertSame(0, $status);
        self::assertStringContainsString('new', $out);
        self::assertStringContainsString('check', $out);
        self::assertStringContainsString('serve', $out);
        self::assertStringNotContainsString('login', $out);
        self::assertStringNotContainsString('publish', $out);
        self::assertSame('', $err);
    }

    public function testCheckValidatesAThemeWithoutShopkitConfiguration(): void
    {
        $root = $this->theme();
        [$status, $out, $err] = $this->runCli(['shopkit-themes', 'check', $root]);

        self::assertSame(0, $status);
        self::assertStringContainsString('Theme valid', $out);
        self::assertSame('', $err);
    }

    public function testNewCopiesAnOfficialThemeWithoutOverwriting(): void
    {
        $parent = sys_get_temp_dir().'/shopkit-theme-new-'.bin2hex(random_bytes(8));
        mkdir($parent, 0700, true);
        $this->paths[] = $parent;
        $destination = $parent.'/my-theme';

        [$status] = $this->runCli(['shopkit-themes', 'new', $destination, 'boxie']);
        self::assertSame(0, $status);
        self::assertFileExists($destination.'/base.tpl');
        self::assertFileExists($destination.'/css/style.less');
        self::assertFileExists($destination.'/LICENSE');
        self::assertFileExists($destination.'/THIRD_PARTY_NOTICES.md');
        self::assertFileExists($destination.'/LICENSE-APACHE-2.0.txt');
        self::assertSame(
            file_get_contents(dirname(__DIR__).'/LICENSE'),
            file_get_contents($destination.'/LICENSE')
        );
        self::assertSame(
            file_get_contents(dirname(__DIR__).'/LICENSES/Apache-2.0.txt'),
            file_get_contents($destination.'/LICENSE-APACHE-2.0.txt')
        );

        $generatedNotice = file_get_contents($destination.'/THIRD_PARTY_NOTICES.md');
        self::assertIsString($generatedNotice);
        self::assertStringContainsString('`js/plugins.js`', $generatedNotice);
        self::assertStringContainsString(
            '[LICENSE-APACHE-2.0.txt](LICENSE-APACHE-2.0.txt)',
            $generatedNotice
        );
        self::assertStringNotContainsString('boxie/js/plugins.js', $generatedNotice);
        self::assertStringNotContainsString('default/js/plugins.js', $generatedNotice);
        self::assertStringNotContainsString('mosaic/js/plugins.js', $generatedNotice);
        self::assertStringNotContainsString('Isotope v1.5.25', $generatedNotice);
        self::assertSame('boxie', (new \Shopkit\Themes\ThemeProject($destination))->fixtureName());

        [$secondStatus, , $secondError] = $this->runCli(['shopkit-themes', 'new', $destination, 'boxie']);
        self::assertNotSame(0, $secondStatus);
        self::assertStringContainsString('already exists', $secondError);
    }

    public function testUnknownCommandFailsWithoutAStackTrace(): void
    {
        [$status, , $err] = $this->runCli(['shopkit-themes', 'deploy']);

        self::assertSame(2, $status);
        self::assertStringContainsString('Unknown command', $err);
        self::assertStringNotContainsString('Stack trace', $err);
    }

    public function testNewMakesMosaicCommercialTermsVisible(): void
    {
        $parent = sys_get_temp_dir().'/shopkit-theme-mosaic-'.bin2hex(random_bytes(8));
        mkdir($parent, 0700, true);
        $this->paths[] = $parent;

        [$status, $out, $err] = $this->runCli([
            'shopkit-themes',
            'new',
            $parent.'/theme',
            'mosaic',
        ]);

        self::assertSame(0, $status);
        self::assertStringContainsString('separate commercial-use terms', $out);
        self::assertSame('', $err);

        $generatedNotice = file_get_contents($parent.'/theme/THIRD_PARTY_NOTICES.md');
        self::assertIsString($generatedNotice);
        self::assertStringContainsString('Isotope v1.5.25', $generatedNotice);
        self::assertStringContainsString('`js/plugins.js`', $generatedNotice);
        self::assertStringNotContainsString('mosaic/js/plugins.js', $generatedNotice);
    }

    public function testRepositoryNoticeKeepsRepositoryPaths(): void
    {
        $rootNotice = file_get_contents(dirname(__DIR__).'/THIRD_PARTY_NOTICES.md');

        self::assertIsString($rootNotice);
        self::assertStringContainsString('`mosaic/js/plugins.js`', $rootNotice);
        self::assertStringContainsString('`default/js/plugins.js`', $rootNotice);
        self::assertStringContainsString(
            '[LICENSES/Apache-2.0.txt](LICENSES/Apache-2.0.txt)',
            $rootNotice
        );
    }

    #[DataProvider('officialStarterNotices')]
    public function testNewWritesAStarterScopedNotice(
        string $starter,
        bool $includesBootstrapTwo,
        bool $includesIsotope
    ): void {
        $parent = sys_get_temp_dir().'/shopkit-theme-notice-'.bin2hex(random_bytes(8));
        mkdir($parent, 0700, true);
        $this->paths[] = $parent;

        [$status, , $error] = $this->runCli([
            'shopkit-themes',
            'new',
            $parent.'/theme',
            $starter,
        ]);

        self::assertSame(0, $status, $error);
        $notice = file_get_contents($parent.'/theme/THIRD_PARTY_NOTICES.md');
        self::assertIsString($notice);
        self::assertStringContainsString('`js/plugins.js`', $notice);
        self::assertStringNotContainsString('Masonry, FlexSlider', $notice);
        self::assertSame($includesBootstrapTwo, str_contains($notice, 'Bootstrap 2.3.2'));
        self::assertSame($includesIsotope, str_contains($notice, 'Isotope v1.5.25'));
        self::assertStringNotContainsString($starter.'/js/plugins.js', $notice);
    }

    public static function officialStarterNotices(): array
    {
        return [
            'default' => ['default', true, false],
            'boxie' => ['boxie', false, false],
            'minimal' => ['minimal', false, false],
            'mosaic' => ['mosaic', true, true],
        ];
    }

    public function testVersionIsStableAndNeedsNoConfiguration(): void
    {
        [$status, $out, $err] = $this->runCli(['shopkit-themes', '--version']);

        self::assertSame(0, $status);
        self::assertSame("shopkit-themes 1.0.0\n", $out);
        self::assertSame('', $err);
    }

    public function testCheckReportsInvalidTwigWithoutLeakingItsAbsolutePath(): void
    {
        $root = $this->theme();
        file_put_contents($root.'/home.tpl', '{% if %}');

        [$status, $out, $err] = $this->runCli(['shopkit-themes', 'check', $root]);

        self::assertSame(1, $status);
        self::assertSame('', $out);
        self::assertStringContainsString('home.tpl', $err);
        self::assertStringNotContainsString($root, $err);
        self::assertStringNotContainsString('Stack trace', $err);
    }

    public function testRejectsInvalidServeOptionsBeforeStartingAProcess(): void
    {
        $root = $this->theme();

        [$portStatus, , $portError] = $this->runCli(['shopkit-themes', 'serve', $root, '--port=70000']);
        [$pageStatus, , $pageError] = $this->runCli(['shopkit-themes', 'serve', $root, '--page=../../secret']);

        self::assertSame(2, $portStatus);
        self::assertStringContainsString('between 1 and 65535', $portError);
        self::assertSame(2, $pageStatus);
        self::assertStringContainsString('page name', $pageError);
    }

    public function testNewRejectsADestinationInsideItsStarterSource(): void
    {
        $packageRoot = sys_get_temp_dir().'/shopkit-package-test-'.bin2hex(random_bytes(8));
        mkdir($packageRoot, 0700, true);
        $this->paths[] = $packageRoot;
        $starter = TestTheme::create();
        rename($starter, $packageRoot.'/default');
        $destination = $packageRoot.'/default/nested-theme';

        [$status, , $error] = $this->runCli(
            ['shopkit-themes', 'new', $destination, 'default'],
            $packageRoot
        );

        self::assertSame(1, $status);
        self::assertStringContainsString('inside', $error);
        self::assertDirectoryDoesNotExist($destination);
    }

    private function runCli(array $arguments, ?string $packageRoot = null): array
    {
        $out = fopen('php://temp', 'w+');
        $err = fopen('php://temp', 'w+');
        $status = (new Application($out, $err, $packageRoot ?? dirname(__DIR__)))->run($arguments);
        rewind($out);
        rewind($err);
        return [$status, stream_get_contents($out), stream_get_contents($err)];
    }

    private function theme(): string
    {
        $root = TestTheme::create();
        $this->paths[] = $root;
        return $root;
    }
}
