# Contributing

Thanks for helping improve Shopkit themes and the local development CLI.

## Local setup

Requirements are PHP 8.2 or newer, Composer, the PHP `dom` and `json`
extensions, and the standard PHP process and local socket functions.

```console
git clone https://github.com/Shopkit/Themes.git shopkit-themes
cd shopkit-themes
composer install
```

The project does not require Docker, Shopkit's private codebase, credentials, or
external services.

## Before submitting a change

Keep changes small and scoped. For theme changes, preserve the flat structure
documented in [README.md](README.md) and verify the affected theme:

```console
./bin/shopkit-themes check default
./bin/shopkit-themes serve default
```

Replace `default` with the affected theme. For CLI changes, add or update tests
that demonstrate the behavior, then run:

```console
composer validate --strict
php -l bin/shopkit-themes
find resources src tests -type f -name '*.php' -print0 | xargs -0 -n1 php -l
composer test
```

Do not commit `vendor/`, PHPUnit cache files, editor state, generated bundles,
credentials, or local configuration. Preserve copyright and license notices in
bundled third-party files.

The files in `resources/fixtures/` are the public, synthetic preview contract.
Keep them free of real customer data and external URLs. When an official theme
option changes, update its JSON fixture and rely on the render and LESS tests to
verify compatibility; the fixtures deliberately have no private-source hashes.

## Pull requests

In the pull request description, include:

- the problem and the smallest change that solves it;
- the themes or CLI commands affected;
- the exact validation commands run and their results;
- screenshots only when the rendered result changes;
- any compatibility or licensing considerations.

## Reporting security vulnerabilities

Do not open a public issue for a suspected vulnerability and do not include
secrets, customer data, or exploit details in public discussions.

Use GitHub's private vulnerability reporting option for this repository when it
is available. Otherwise email `support@shopk.it` with the subject
`[SECURITY] Shopkit Themes`. Include a concise description, affected version or
commit, reproduction steps, and impact. Use only local sample data when
reproducing a report.
