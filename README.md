# Shopkit Themes

Official Shopkit themes and a small, standalone CLI for developing them locally.

The CLI runs from this public repository. It does not require access to Shopkit's
private codebase, an account, API credentials, Docker, or any external service.
Preview data is local sample data; nothing is read from or written to a store.

## Requirements

- PHP 8.2 or newer
- [Composer](https://getcomposer.org/)
- PHP extensions `dom` and `json`
- Standard PHP process and local socket functions must not be disabled

## Install

### Composer global

Until a tagged package is available through Packagist, Composer can install the
CLI directly from this repository:

```console
composer global config repositories.shopkit-themes vcs https://github.com/Shopkit/Themes.git
composer global require shopkit/themes:dev-master
```

Add Composer's global binary directory to your `PATH` if needed. Its location is
shown by:

```console
composer global config bin-dir --absolute
```

### Clone the repository

```console
git clone https://github.com/Shopkit/Themes.git shopkit-themes
cd shopkit-themes
composer install
./bin/shopkit-themes --help
```

No Docker setup or Shopkit configuration is needed.

## Quick start

Create a new theme from one of the official starters:

```console
shopkit-themes new my-theme default
cd my-theme
shopkit-themes check .
shopkit-themes serve .
```

The preview is bound to `127.0.0.1` and the command prints its local URL. Press
`Ctrl-C` to stop it.

## Commands

```text
shopkit-themes new <directory> [default|boxie|minimal|mosaic]
shopkit-themes check <theme-directory>
shopkit-themes serve <theme-directory> [--page=home] [--port=4173]
shopkit-themes help
shopkit-themes version
```

- `new` copies an official theme into a new directory and never overwrites an
  existing path. It also copies the notices required by bundled third-party
  components.
- `check` validates the theme layout and parses its Twig templates locally.
- `serve` validates the theme, then serves a local preview with sample catalog
  data. JavaScript is not executed in the preview.
- `help` and `version` also accept `--help` and `--version`.

There are deliberately no login, upload, publish, or deployment commands.

## Theme structure

Shopkit themes use the existing flat template layout: Twig templates are at the
theme root, while styles and optional JavaScript live in their dedicated
directories.

```text
my-theme/
├── base.tpl             # required
├── home.tpl             # required
├── product.tpl          # other pages use <page>.tpl
├── ...
├── css/
│   └── style.less       # required
├── js/
│   ├── plugins.js       # optional
│   └── script.js        # optional
├── README.md            # optional
├── LICENSE
├── THIRD_PARTY_NOTICES.md
└── LICENSE-APACHE-2.0.txt
```

Template filenames use lowercase letters, digits, and hyphens. Nested template
directories, symbolic links, and arbitrary extra files are rejected. The
official themes in `default/`, `boxie/`, `minimal/`, and `mosaic/` are working
examples of this structure.

Rendered HTML and compiled CSS are each limited to 2 MB in validation and
preview.

The `Shopkit Starter: …` line near the top of `base.tpl` selects the matching
local style fixture. You may change `Template Name`, but keep the starter line
so previews retain the starter's theme options.

## Template API

Templates receive synthetic `store`, `cart`, `user`, `product`, `category`,
`brand`, `tag`, `blog_post`, `page`, `order`, `events`, and form-state values.
The complete public sample shape lives in
`resources/fixtures/storefront.json`; theme option samples live in
`resources/fixtures/theme-options/`.

A minimal page looks like this:

```twig
{% extends 'base.tpl' %}
{% block content %}
  {% for item in products('limit:4') %}
    <a href="{{ item.url }}">{{ item.title }} — {{ item.price|money_with_sign }}</a>
  {% endfor %}
{% endblock %}
```

Collection helpers are `products`, `categories`, `brands`, `blog_posts`,
`reviews`, `pages`, `tags`, and `price_range`. Single-item helpers are
`product`, `category`, and `page`. `products('limit:4')` limits the sample list;
adding `search` returns an object with `query`, `total_results`, and `results`.

URL and markup helpers are `site_url`, `current_url`, `assets_url`,
`form_open`, `form_open_cart`, `form_close`, `icons`, and `safe_mailto`.
Text helpers are `word_limiter`, `character_limiter`, `line_break`, and `md5`.
The supported Shopkit filters are `money_with_sign`,
`money_without_trailing_zeros`, `slug`, `json_decode`, `first_word`, `t`,
`rewards_label`, `rewards_message`, `e_attr`, `shuffle`, and
`format_datetime`, alongside the safe Twig filters used by the official
themes.

Allowed Twig tags are `block`, `extends`, `for`, `from`, `if`, `import`,
`include`, `macro`, and `set`. Includes resolve only to root-level `.tpl` files
inside the validated theme. Object methods, dynamic attributes, arbitrary PHP
functions, filesystem access, and network access are unavailable.

`css/style.less` must contain exactly one of these imports:

```less
@import "template-vars.less";
```

The CLI supplies that virtual file from local fixtures. Other LESS imports and
LESS features that can read files or execute code are rejected.

## Local preview and security model

Theme source is handled outside the Shopkit application:

- Twig templates are loaded from a validated in-memory file map and run with an
  explicit sandbox allowlist.
- Twig and LESS work runs in a child PHP process with time, memory, output,
  filesystem, environment, and dangerous-function restrictions.
- The preview server listens only on `127.0.0.1`, uses a random URL token, and
  accepts preview requests only. It has no database, Shopkit secrets, store
  credentials, or API connection.
- Rendered HTML and CSS are sanitized. A restrictive Content Security Policy
  blocks scripts, forms, frames, network connections, and external resources.
- Theme JavaScript is kept as a theme file but is not served or executed by the
  local preview.
- Boxie's Bootstrap stylesheet is constrained to the 4.5.3 release line and is
  served locally through the tokenized preview URL; no CDN request is required.

This is defense in depth for a local development tool, not a virtual machine or
an operating-system security boundary. It relies on the security of the local
PHP runtime and installed Composer dependencies, and it necessarily reads the
theme directory selected by the developer. Keep dependencies updated and do not
use the CLI as a general-purpose service for source from unknown users.

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md) for the local setup and test commands.
Please report suspected vulnerabilities privately as described there.

## License

Shopkit-authored code and documentation in this repository are available under
the [MIT License](LICENSE). Bundled third-party components retain their own
licenses and notices; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
