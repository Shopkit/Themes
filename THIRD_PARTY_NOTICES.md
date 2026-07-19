# Third-party notices

The repository-level [MIT License](LICENSE) applies to Shopkit-authored code and
documentation. It does not replace or relicense third-party code bundled with
the official themes. Third-party components remain subject to their respective
copyright, license, and attribution notices in the files that contain them.

## Isotope v1.5.25

`mosaic/js/plugins.js` includes Isotope v1.5.25, copyright 2013 Metafizzy. Its
retained notice states that commercial use requires purchase of a commercial
license and that non-commercial use is licensed under the MIT License.

The original notice is preserved in `mosaic/js/plugins.js` and remains the
authoritative notice for that bundled copy. See the license URL recorded there:
<http://isotope.metafizzy.co/docs/license.html>.

Users are responsible for reviewing the retained notices before redistributing
or using bundled third-party components, particularly for commercial use.

## Apache License 2.0 components

The following bundles include software licensed under the Apache License 2.0:

- Bootstrap 2.3.2 in `default/js/plugins.js` and `mosaic/js/plugins.js`;
- Bootstrap 3 Typeahead 4.0.2 in `default/js/plugins.js`,
  `boxie/js/plugins.js`, `minimal/js/plugins.js`, and `mosaic/js/plugins.js`.

The required license text is available at
[LICENSES/Apache-2.0.txt](LICENSES/Apache-2.0.txt). Themes created by the CLI
also receive it as `LICENSE-APACHE-2.0.txt` beside this notice.

## MIT-licensed components

The CLI uses Bootstrap 4.5.3 (`twbs/bootstrap`) only to render Boxie previews.
Composer constrains it below 4.5.4 so the matching MIT-licensed stylesheet is
served locally and is not copied into this repository.

The official theme JavaScript bundles also retain notices for MIT-licensed
components including Bootstrap, imagesLoaded, Masonry, FlexSlider, FancyBox,
priority-nav, Popper, intl-tel-input, LazyLoad, and spin.js. Copyright and
version details are preserved alongside each bundled copy.
