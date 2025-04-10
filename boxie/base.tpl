{#
Template Name: Boxie
Author: Shopkit
Version: 1.0
#}

{% import 'macros.tpl' as generic_macros %}

{# Vars #}
{% set products_per_page_catalog = store.products_per_page_catalog ?: 12 %}
{% set categories_per_page = store.categories_per_page ?: 16 %}
{% set categories_per_row = store.theme_options.categories_per_row ?: 4 %}
{% set mobile_categories_per_row = store.theme_options.mobile_categories_per_row ?: 1 %}
{% set brands_per_page = store.brands_per_page ?: 32 %}
{% set brands_per_row = store.theme_options.brands_per_row ?: 6 %}
{% set mobile_brands_per_row = store.theme_options.mobile_brands_per_row ?: 1 %}
{% set category_badges = ['yellow', 'blue', 'pink', 'green', 'red', 'purple', 'orange', 'dark-green', 'blue-gray', 'maroon']|shuffle %}
{% set store_name = store.name|e_attr  %}
{% set layout_container = store.theme_options.layout_container == 'fluid' ? 'container-fluid' : 'container' %}
{% set mobile_products_per_row = store.theme_options.mobile_products_per_row %}
{% set products_per_row = store.theme_options.products_per_row is not null ? store.theme_options.products_per_row : '4' %}
{% set posts_per_page = store.theme_options.posts_per_page ?: 3 %}
{% set posts_per_row = store.theme_options.posts_per_row ?: 1 %}
{% set show_filters = store.theme_options.show_filters == 'show' ? 'show' : 'hidden' %}
{% set show_search_filters = store.theme_options.show_search_filters == 'show' ? 'show' : 'hidden' %}
{% set show_search_suggestions = store.theme_options.show_search_suggestions == 'block' ? '' : 'remove-typeahead' %}

<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if IE 9]>         <html class="no-js ie9"> <![endif]-->
<!--[if gt IE 9]><!--> <html class="no-js"><!--<![endif]-->
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>{{ title }}</title>

    <meta name="description" content="{{ description|e_attr }}">
    <meta name="keywords" content="{{ tags|e_attr }}">
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
    <meta name="theme-color" content="{{ store.basecolor }}">

    {% if store.show_branding %}
        <meta name="author" content="Shopkit">
    {% endif %}

    {% if store.translate_meta %}
        <meta name="google-translate-customization" content="{{ store.translate_meta }}">
    {% endif %}

    {% if apps.facebook_comments.username %}
        <meta property="fb:admins" content="{{ apps.facebook_comments.username }}">
    {% endif %}
    <!-- End Facebook Meta -->

    <link rel="canonical" href="{{ canonical_url }}" />

    {% if store.favicon %}
        <link rel="shortcut icon" href="{{ store.favicon }}">
    {% endif %}

    <link href="{{ site_url('rss') }}" rel="alternate" type="application/rss+xml" title="{{ store_name }}">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="{{ fonts }}" rel="stylesheet">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/css/bootstrap.min.css" integrity="sha384-TX8t27EcRE3e/ihU7zmQxVncDAy5uIKz4rEkgIXeMed4M0jlfIDPvg6uqKI2xXr2" crossorigin="anonymous">
    <link id="theme-css" href="{{ store.assets.css }}" rel="stylesheet">

    {% if store.custom_css %}
        <style>{{ store.custom_css }}</style>
    {% endif %}

    {{ icon_library }}
    <script src="{{ assets_url('assets/common/vendor/modernizr/2.7.1/modernizr.min.js') }}"></script>
    <script src="{{ assets_url('assets/common/vendor/jquery/1.11.2/jquery.min.js') }}"></script>

    <script>
        var viewportmeta = document.querySelector('meta[name="viewport"]');
        if (viewportmeta) {
            if (screen.width < 375) {
                var newScale = screen.width / 375;
                viewportmeta.content = 'width=375, minimum-scale=' + newScale + ', maximum-scale=1.0, user-scalable=no, initial-scale=' + newScale + '';
            } else {
                viewportmeta.content = 'width=device-width, maximum-scale=1.0, initial-scale=1.0, user-scalable=no';
            }
        }
    </script>

    {{ head_content }}
</head>

<body class="{{ css_class }} {{ store.theme_options.header_position }} {{ store.theme_options.modal_mask_blur != '0' ? 'modal-backdrop-blur' }} {{ store.theme_options.icon_library }}">

    {% if store.notice or apps.google_translate %}
        <div class="store-notice {{ not store.notice ? 'd-md-none' }}">
            {% if store.notice %}
                <div class="store-notice-text text-center h5">
                    {{ store.notice }}
                </div>
            {% endif %}
            {% if apps.google_translate %}
                {{ generic_macros.google_translate(apps.google_translate, 'd-md-none') }}
            {% endif %}
        </div>
    {% endif %}

    <div id="nav-spacer" class="hidden"></div>

    <header class="header {{ store.theme_options.header_position }}">
        <div class="{{ layout_container }} d-flex align-items-center">
            {% if store.logo %}
                <a href="{{ site_url() }}" class="logo d-none d-lg-block"><img src="{{ store.logo }}" alt="{{ store.name|e_attr }}" title="{{ store.name|e_attr }}" height="60"></a>
            {% else %}
                <h1 class="logo d-none d-lg-block"><a href="{{ site_url() }}">{{ store.name }}</a></h1>
            {% endif %}

            <div class="trigger-wrapper d-flex">
                <button class="trigger-header-menu"></button>
            </div>

            {% if store.logo %}
                <a href="{{ site_url() }}" class="logo d-lg-none"><img src="{{ store.logo }}" alt="{{ store.name|e_attr }}" title="{{ store.name|e_attr }}" height="60"></a>
            {% else %}
                <h1 class="logo d-lg-none"><a href="{{ site_url() }}">{{ store.name }}</a></h1>
            {% endif %}

            <div class="header-control">
                {% if store.theme_options.show_search %}
                    <div class="header-item d-none d-sm-none d-md-block">
                        <div class="search {{ show_search_suggestions }}">
                            {{ form_open(site_url('search'), { 'method' : 'get', 'role' : 'search' }) }}
                                <div class="input-wrapper">
                                    <input type="text" name="q" value="{{ search ? search.query }}" placeholder="{{ 'lang.storefront.layout.header.search'|t }}" class="search-input" required="">
                                </div>
                                <button type="submit" class="search-button">
                                    {{ icons('search') }}
                                </button>
                            {{ form_close() }}
                        </div>
                    </div>
                {% endif %}
                <div class="header-item ">
                    <a href="{{ site_url('cart') }}" class="link-cart header-link {{ cart.items ? 'has-products' }}">
                        {{ icons('shopping-cart') }}
                    </a>
                    {% if cart.items %}
                        <div class="cart-body">
                            <div class="cart-list well-featured {{ store.theme_options.well_featured_shadow }}">
                                {% for item in cart.items %}
                                    <div class="cart-item" data-product="{{ item.product_id }}" data-product-option="{{ item.options|keys[0] }}">
                                        <div class="item-image">
                                            <a href="{{ item.product_url }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ item.image }}" alt="{{ item.title|e_attr }}" title="{{ item.title|e_attr }}" class="lazy"></a>
                                        </div>

                                        <div class="details">
                                            <a href="{{ item.product_url }}" class="item-product {% if not item.extras %}margin-bottom-xs{% endif %}">{{ item.title }}</a>

                                            {% if item.extras %}
                                                <div class="items-extra-wrapper">
                                                    {% set item_extra_tip = '' %}
                                                    {% for key, extra in item.extras %}
                                                        {% set item_extra_tip = item_extra_tip ~ extra.title ~': '~ extra.value ~ (loop.last ? '' : '</br>') %}
                                                    {% endfor %}
                                                    <span href="#item-extra-{{ item.item_id }}" class="small" data-toggle="tooltip" title="{{ item_extra_tip }}" data-html="true">{{ item.extras|length }} {{ item.extras|length > 1 ? 'lang.storefront.product.extra_options.plural.label'|t : 'lang.storefront.product.extra_options.singular.label'|t }} <span class="text-muted">({{ item.subtotal_extras > 0 ? item.subtotal_extras | money_with_sign : 'lang.storefront.cart.order_summary.shipping_total.free'|t }})</span></span>
                                                </div>
                                            {% endif %}

                                            <div class="price">{{ item.subtotal | money_with_sign }}</div>
                                        </div>
                                        <a href="{{ item.remove_link }}" class="remove btn-default {{ store.theme_options.button_default_shadow }}">
                                            {{ icons('trash-alt') }}
                                        </a>
                                    </div>
                                {% endfor %}

                                <div class="cart-total">
                                    <div class="cart-total-text">{{ 'lang.storefront.order.total'|t }}:</div>
                                    <div class="cart-total-text">{{ cart.subtotal | money_with_sign }}</div>
                                </div>
                                <div class="cart-btns">
                                    <a class="cart-btn btn btn-default {{ store.theme_options.button_default_shadow }}" href="{{ site_url('cart') }}">{{ 'lang.storefront.layout.button.see_cart'|t }}</a>
                                    <a class="cart-btn btn btn-primary {{ store.theme_options.button_primary_shadow }}" href="{{ site_url('cart/data') }}">{{ 'lang.storefront.layout.button.checkout'|t }}</a>
                                </div>

                            </div>
                        </div>
                    {% endif %}
                </div>
                {% if store.settings.cart.users_registration != 'disabled' %}
                    <div class="header-item d-none d-sm-none d-md-block">
                        {% if user.is_logged_in %}
                            <div class="user-loggedin">
                                <a href="{{ site_url('account') }}" class="link-account header-link">
                                    {{ icons('user') }}
                                    <span class="user-name">{{ 'lang.storefront.layout.greetings'|t }} <strong>{{ user.name|first_word }}</strong></span>
                                </a>
                            </div>
                            <div class="user-body">
                                <div class="dropdown-menu dropdown-user-actions dropdown-menu-right well-featured {{ store.theme_options.well_featured_shadow }}">
                                    <li class="{{ current_page == 'account-orders' ? 'active' }} dropdown-item"><a href="{{ site_url('account/orders')}}" class="link-inherit">{{ icons('shopping-bag') }} {{ 'lang.storefront.layout.orders.title'|t }}</a></li>
                                    <li class="{{ current_page == 'account-profile' ? 'active' }} dropdown-item"><a href="{{ site_url('account/profile')}}" class="link-inherit">{{ icons('user') }} {{ 'lang.storefront.layout.client.title'|t }}</a></li>
                                    <li class="{{ current_page == 'account-wishlist' ? 'active' }} dropdown-item"><a href="{{ site_url('account/wishlist')}}" class="link-inherit">{{ icons('heart') }} {{ 'lang.storefront.layout.wishlist.title'|t }}</a></li>
                                    <li class="dropdown-item"><a href="{{ site_url('account/logout')}}" class="link-inherit">{{ icons('log-out') }} {{ 'lang.storefront.layout.logout.title'|t }}</a></li>
                                </div>
                            </div>
                        {% else %}
                            <a href="{{ site_url('signin') }}" class="header-link">
                                {{ icons('user') }}
                            </a>
                        {% endif %}
                    </div>
                {% endif %}
                {% if apps.google_translate %}
                    {{ generic_macros.google_translate(apps.google_translate, 'header-item d-none d-md-block') }}
                {% endif %}
            </div> <!-- end header-control -->

        </div> <!-- end container-fluid -->

        <div class="header-menu">
            <div class="{{ layout_container }}">
                {% if store.theme_options.show_search %}
                    {{ form_open(site_url('search'), { 'method' : 'get', 'role' : 'search', 'class' : 'menu-search' }) }}
                        <div class="search {{ show_search_suggestions }}">
                            <div class="input-wrapper">
                                <input type="text" name="q" value="{{ search ? search.query }}" placeholder="{{ 'lang.storefront.layout.header.search'|t }}" class="search-input">
                                <button class="search-button" type="submit">
                                    {{ icons('search') }}
                                </button>
                            </div>
                        </div>
                    {{ form_close() }}
                {% endif %}

                <div class="menu-container">
                    <div class="menu-list">

                        {% for catalog_menu in store.navigation.catalogs_menus %}
                            <div class="menu-item menu-{{ catalog_menu.menu_item }} {{ current_page == catalog_menu.menu_item ? 'active' }} {{ store.theme_options['show_menu_' ~ catalog_menu.menu_item] ? '' : 'hidden' }}">
                                <a class="menu-link" href="{{ catalog_menu.menu_url }}">{{ ('lang.storefront.' ~ catalog_menu.menu_item ~ '.title')|t }}</a>
                            </div>
                        {% endfor %}

                        {% if categories %}
                            {% for products_category in categories %}
                                {% set products_category_id = products_category.id %}

                                <div class="menu-item menu-{{ products_category.handle }} {% if (category.id == products_category_id or category.parent == products_category_id) %} active {% endif %}">
                                    {% if products_category.children %}
                                        <div class="menu-head js-menu-head">{{ products_category.title }}
                                            {{ icons('angle-right') }}
                                        </div>

                                        <div class="menu-body">
                                            <button class="menu-close js-menu-close">
                                                {{ icons('times') }}
                                            </button>
                                            <button class="menu-back js-menu-back">
                                                {{ icons('angle-left') }}
                                            </button>

                                            <div class="menu-group">
                                                {% for sub_category in products_category.children %}
                                                    <div class="menu-item menu-{{ sub_category.handle }} {% if (category.id == sub_category.id or category.parent == sub_category.id) %} active {% endif %}">
                                                        {% if sub_category.children %}
                                                            <div class="menu-head js-submenu-head">{{ sub_category.title }}
                                                                {{ icons('angle-right') }}
                                                            </div>

                                                            <div class="submenu-body">
                                                                <div class="submenu-group">
                                                                    {% for children in sub_category.children %}
                                                                        <div class="submenu-item menu-{{ children.handle }} {% if (category.id == children.id or category.parent == children.id) %} active {% endif %}">
                                                                            <a class="submenu-link" href="{{ children.url }}">{{ children.title }}</a>
                                                                        </div>
                                                                    {% endfor %}
                                                                </div>
                                                            </div>
                                                        {% else %}
                                                            <a class="menu-link" href="{{ sub_category.url }}">{{ sub_category.title }}</a>
                                                        {% endif %}
                                                    </div>
                                                {% endfor %}
                                            </div>
                                        </div>
                                    {% else %}
                                        <a class="menu-link" href="{{ products_category.url }}">{{ products_category.title }}</a>
                                    {% endif %}
                                </div>
                            {% endfor %}
                        {% endif %}

                    </div>
                </div> <!-- end menu-container -->

                {% if store.settings.cart.users_registration != 'disabled' %}
                    <div class="menu-login">
                        {% if user.is_logged_in %}
                            <a href="{{ site_url('account') }}" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} btn-block link-account">
                                {{ icons('user') }}
                                <span class="user-name">{{ 'lang.storefront.layout.greetings'|t }} <strong>{{ user.name|first_word }}</strong></span>
                            </a>
                        {% else %}
                            <a href="{{ site_url('signin') }}" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} btn-block">
                                {{ 'lang.storefront.login.signin.title'|t }}
                            </a>
                        {% endif %}
                    </div> <!-- end menu social -->
                {% endif %}

                <div class="menu-social">
                    {% if store.facebook %}
                        <a href="{{ store.facebook }}" class="link-social-facebook menu-link" target="_blank" title="{{ 'lang.storefront.layout.social.facebook'|t }}">
                            {{ icons('facebook') }}
                        </a>
                    {% endif %}
                    {% if store.twitter %}
                        <a href="{{ store.twitter }}" class="link-social-twitter menu-link" target="_blank" title="{{ 'lang.storefront.layout.social.twitter'|t }}">
                            {{ icons('twitter') }}
                        </a>
                    {% endif %}
                    {% if store.instagram %}
                        <a href="{{ store.instagram }}" class="link-social-instagram menu-link" target="_blank" title="{{ 'lang.storefront.layout.social.instagram'|t }}">
                            {{ icons('instagram') }}
                        </a>
                    {% endif %}
                    {% if store.pinterest %}
                        <a href="{{ store.pinterest }}" class="link-social-pinterest menu-link" target="_blank" title="{{ 'lang.storefront.layout.social.pinterest'|t }}">
                            {{ icons('pinterest-p') }}
                        </a>
                    {% endif %}
                    {% if store.youtube %}
                        <a href="{{ store.youtube }}" class="link-social-youtube menu-link" target="_blank" title="{{ 'lang.storefront.layout.social.youtube'|t }}">
                            {{ icons('youtube') }}
                        </a>
                    {% endif %}
                    {% if store.linkedin %}
                        <a href="{{ store.linkedin }}" class="link-social-linkedin menu-link" target="_blank" title="{{ 'lang.storefront.layout.social.linkedin'|t }}">
                            {{ icons('linkedin') }}
                        </a>
                    {% endif %}
                    {% if store.tiktok %}
                        <a href="{{ store.tiktok }}" class="link-social-tiktok menu-link" target="_blank" title="{{ 'lang.storefront.layout.social.tiktok'|t }}">
                            {{ icons('tiktok') }}
                        </a>
                    {% endif %}
                    <a href="{{ site_url('rss') }}" class="link-social-rss menu-link" target="_blank" title="{{ 'lang.storefront.layout.social.rss'|t }}">
                        {{ icons('rss') }}
                    </a>
                </div>

            </div>
        </div>

    </header>

    {# This is where content of each page will appear #}
    <div class="main">
        {{ generic_macros.gallery() }}

        {% block content %}{% endblock %}

        {% set reviews = reviews("order:random product:#{product.id} limit:6") %}

        {% if current_page != 'home' and apps.product_reviews and apps.product_reviews.product_reviews_block and reviews.reviews %}
            {{ generic_macros.reviews_block(reviews) }}
        {% endif %}
    </div>

    <footer class="footer">
        <div class="{{ layout_container }}">
            <div class="row">
                <div class="col-lg-3 col-md-6 col-xs-12">
                    {% if store.logo %}
                        <a href="{{ site_url() }}" class="footer-logo"><img src="{{ store.logo }}" alt="{{ store.name|e_attr }}" title="{{ store.name|e_attr }}"></a>
                        {% else %}
                        <h1 class="footer-logo"><a href="{{ site_url() }}">{{ store.name }}</a></h1>
                    {% endif %}

                    <div class="copyright">&copy; {{ store_name }} {{ "now"|date("Y") }}. {{ 'lang.storefront.layout.footer.copyright'|t }}.
                        <p class="margin-top-md">{{ store.footer_info|nl2br }}</p>
                    </div>

                    <div class="footer-social social">
                        {% if store.facebook %}
                            <a href="{{ store.facebook }}" class="social-link link-social-facebook" target="_blank" title="{{ 'lang.storefront.layout.social.facebook'|t }}">
                                {{ icons('facebook') }}
                            </a>
                        {% endif %}
                        {% if store.twitter %}
                            <a href="{{ store.twitter }}" class="social-link link-social-twitter" target="_blank" title="{{ 'lang.storefront.layout.social.twitter'|t }}">
                                {{ icons('twitter') }}
                            </a>
                        {% endif %}
                        {% if store.instagram %}
                            <a href="{{ store.instagram }}" class="social-link link-social-instagram" target="_blank" title="{{ 'lang.storefront.layout.social.instagram'|t }}">
                                {{ icons('instagram') }}
                            </a>
                        {% endif %}
                        {% if store.pinterest %}
                            <a href="{{ store.pinterest }}" class="social-link link-social-pinterest" target="_blank" title="{{ 'lang.storefront.layout.social.pinterest'|t }}">
                                {{ icons('pinterest-p') }}
                            </a>
                        {% endif %}
                        {% if store.youtube %}
                            <a href="{{ store.youtube }}" class="social-link link-social-youtube" target="_blank" title="{{ 'lang.storefront.layout.social.youtube'|t }}">
                                {{ icons('youtube') }}
                            </a>
                        {% endif %}
                        {% if store.linkedin %}
                            <a href="{{ store.linkedin }}" class="social-link link-social-linkedin" target="_blank" title="{{ 'lang.storefront.layout.social.linkedin'|t }}">
                                {{ icons('linkedin') }}
                            </a>
                        {% endif %}
                        {% if store.tiktok %}
                            <a href="{{ store.tiktok }}" class="social-link link-social-tiktok" target="_blank" title="{{ 'lang.storefront.layout.social.tiktok'|t }}">
                                {{ icons('tiktok') }}
                            </a>
                        {% endif %}
                    </div>

                    {% if store.is_ssl %}
                        <div class="secure-site">
                            <img class="lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ assets_url('templates/assets/common/icons/secure-site-ssl.png') }}" alt="Site Seguro" title="Site Seguro">
                        </div>
                    {% endif %}
                </div>

                <div class="col-lg-3 col-md-6 col-xs-12">
                    <div class="footer-category">{{ 'lang.storefront.layout.menu.title'|t }}</div>
                    <div class="footer-menu">
                        {% for primary_navigation in store.navigation.primary %}
                            <a class="footer-link menu-{{ primary_navigation.menu_text|slug }}" href="{{ primary_navigation.menu_url }}" {{ primary_navigation.target_blank ? 'target="_blank"' }}>{{ primary_navigation.menu_text }}</a>
                        {% endfor %}
                    </div>
                </div>
                {% if store.navigation.secondary %}
                    <div class="col-lg-3 col-md-6 col-xs-12">
                        <div class="footer-category">{{ 'lang.storefront.layout.footer.pages.title'|t }}</div>
                        <div class="footer-menu">
                            {% for secondary_navigation in store.navigation.secondary %}
                                <a class="footer-link menu-{{ secondary_navigation.menu_text|slug }}" href="{{ secondary_navigation.menu_url }}" {{ secondary_navigation.target_blank ? 'target="_blank"' }}>{{ secondary_navigation.menu_text }}</a>
                            {% endfor %}
                        </div>
                    </div>
                {% endif %}
                <div class="col-lg-3 col-md-6 col-xs-12">
                    <div class="footer-category">{{ 'lang.storefront.contacts.title'|t }}</div>
                    <div class="footer-menu">
                        {% if store.show_email %}
                            <p class="margin-bottom-xs"><strong>{{ 'lang.storefront.form.email.label'|t }}</strong><br>{{ safe_mailto(store.email) }}</p>
                        {% endif %}

                        {% if store.phone %}
                            <p class="margin-bottom-xs"><strong>{{ 'lang.storefront.form.phone.label'|t }}</strong><br><a href="tel:{{ store.phone }}" class="footer-link">{{ store.phone }}</a></p>
                        {% endif %}

                        {% if store.cellphone %}
                            <p class="margin-bottom-xs"><strong>{{ 'lang.storefront.form.cellphone.label'|t }}</strong><br><a href="tel:{{ store.cellphone }}" class="footer-link">{{ store.cellphone }}</a></p>
                        {% endif %}

                        {% if store.address %}
                            <p class="margin-bottom-xs"><strong>{{ 'lang.storefront.form.address.label'|t }}</strong><br>{{ line_break(store.address) }}</p>
                        {% endif %}
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col">
                    <div class="payment-logos">
                        {% for payment in store.payments %}
                            {% if payment.active and payment.image %}
                                <img class="lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ payment.image }}" alt="{{ payment.title }}" title="{{ payment.title }}">
                            {% endif %}
                        {% endfor %}
                    </div>
                </div>
            </div>

            {% if store.theme_options.footer_images %}
                <div class="row">
                    <div class="col">
                        <div class="footer-images margin-top">
                            {% for footer_image in store.theme_options.footer_images %}
                                {{ footer_image.link ? '<a href="' ~ footer_image.link ~ '" target="_blank">' : '' }}
                                <img class="lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ footer_image.image.full }}" alt="{{ footer_image.title }}" title="{{ footer_image.title }}">
                                {{ footer_image.link ? '</a>' : '' }}
                            {% endfor %}
                        </div>
                    </div>
                </div>
            {% endif %}

            {% if store.show_branding %}
                <div class="row">
                    <div class="col">
                        <div class="powered-by">
                            {% set shopkit_logo = store.dark_mode ? 'white.png' : 'black.png' %}
                            {{ 'lang.storefront.layout.footer.poweredby'|t }}<br><a href="https://shopk.it/?utm_source={{ store.username }}&amp;utm_medium=referral&amp;utm_campaign=Shopkit-Stores-Branding" title="Powered by Shopkit e-commerce" target="_blank" rel="nofollow"><img src="{{ assets_url('assets/frontend/img/logo-shopkit-' ~ shopkit_logo) }}" alt="Powered by Shopkit e-commerce" title="Powered by Shopkit e-commerce" style="height:25px;" height="25" width="105"></a>
                        </div>
                    </div>
                </div>
            {% endif %}
        </div>
    </footer>

    {% if store.theme_options.popups|length > 0 %}
        {% for popup in store.theme_options.popups %}
            {% if get.preview or (('all' in popup.location) or (current_page in popup.location)) %}
                {% if popup.type == 'popup' %}
                    <div class="modal fade banner-theme-options" id="banner-{{ popup.type }}-{{ popup.unique_id }}" data-unique_id="{{ popup.unique_id }}" data-type="{{ popup.type }}" data-show_timing="{{ popup.show_timing }}" tabindex="-1" role="dialog" aria-labelledby="banner-popupLabel">
                        <div class="modal-dialog {{ popup.modal_size }}" role="document">
                            <div class="modal-content">
                                <div class="modal-body" style="background-color:{{ popup.background_color }};color:{{ popup.text_color }}">
                                    <button type="button" class="close" data-index="{{ popup.id }}" data-unique_id="{{ popup.unique_id }}" aria-label="Close" style="background-color:{{ popup.background_color }};color:{{ popup.text_color }}"><span aria-hidden="true">&times;</span></button>
                                    <div class="banner-content {{ popup.image.full ? 'image-' ~ popup.image_position : 'no-image' }} {{ popup.content ? 'has-content' : 'no-content' }}">
                                        {% if popup.image.full %}
                                            <div class="popup-image-wrapper">
                                                <div class="banner-image" data-size="{{ popup.image_background_size }}" style="background-image:url({{ popup.image.full }});background-size:{{ popup.image_background_size ? popup.image_background_size }};background-position:{{ popup.image_background_size == 'cover' ? (popup.image_background_position_x ~ ' ' ~ popup.image_background_position_y ~ ';') : '' }}"></div>
                                            </div>
                                        {% endif %}
                                        {% if popup.content %}
                                            <div class="popup-content-wrapper">
                                                <div class="banner-text">{{ popup.content }}</div>
                                                {{ generic_macros.popup_interactions(popup) }}
                                            </div>
                                        {% else %}
                                            {% if popup.interaction == 'button' or popup.interaction == 'newsletter' %}
                                                <div class="popup-content-wrapper">
                                                    {{ generic_macros.popup_interactions(popup) }}
                                                </div>
                                            {% endif %}
                                        {% endif %}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                {% elseif popup.type == 'slide' or popup.type == 'banner' %}
                    <div id="banner-{{ popup.type }}-{{ popup.unique_id }}" class="{{ popup.type == 'slide' ? popup.slide_position : popup.banner_position }} banner-theme-options hidden {{ popup.type == 'banner' and popup.style == 'full' ? 'banner-inline' : 'banner-floating' }} {{ popup.modal_size }}" data-unique_id="{{ popup.unique_id }}" data-type="{{ popup.type }}" data-show_timing="{{ popup.show_timing }}">
                        <div class="banner-wrapper {{ popup.type == 'banner' ? 'size-' ~ popup.style : '' }}"  style="background-color:{{ popup.background_color }};color:{{ popup.text_color }}">
                            <button type="button" class="close" data-index="{{ popup.id }}" data-unique_id="{{ popup.unique_id }}" aria-label="Close" style="background-color:{{ popup.background_color }};color:{{ popup.text_color }}"><span aria-hidden="true">&times;</span></button>
                            <div class="banner-content {{ popup.image.full ? 'image-' ~ popup.image_position : 'no-image' }} {{ popup.content ? 'has-content' : 'no-content' }}">
                                {% if popup.image.full and popup.type == 'slide' %}
                                    <div class="popup-image-wrapper">
                                        <div class="banner-image" data-size="{{ popup.image_background_size }}" style="background-image:url({{ popup.image.full }});background-size:{{ popup.image_background_size ? popup.image_background_size }};background-position:{{ popup.image_background_size == 'cover' ? (popup.image_background_position_x ~ ' ' ~ popup.image_background_position_y ~ ';') : '' }}"></div>
                                    </div>
                                {% endif %}
                                {% if popup.content %}
                                    <div class="popup-content-wrapper">
                                        <div class="banner-text">{{ popup.content }}</div>
                                        {{ generic_macros.popup_interactions(popup) }}
                                    </div>
                                {% else %}
                                    {% if popup.interaction == 'button' or popup.interaction == 'newsletter' %}
                                        <div class="popup-content-wrapper">
                                            {{ generic_macros.popup_interactions(popup) }}
                                        </div>
                                    {% endif %}
                                {% endif %}
                            </div>
                        </div>
                    </div>
                {% endif %}
            {% endif %}
        {% endfor %}
    {% endif %}

    {# Events #}
    {% if events.wishlist %}
        <div class="modal" id="wishlist-modal" tabindex="-1" role="dialog" aria-labelledby="wishlist-modalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-body padding">
                        <div class="text-center">
                            {% if events.wishlist.added %}
                                {{ icons('heart', 'feather-48') }}
                                <h2 class="margin-top">{{ 'lang.storefront.layout.events.wishlist.added'|t }}</h2>
                            {% elseif events.wishlist.removed %}
                                {{ icons('heart', 'feather-48') }}
                                <h2 class="margin-top">{{ 'lang.storefront.layout.events.wishlist.removed'|t }}</h2>
                            {% endif %}
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default {{ store.theme_options.button_default_shadow }} link-inherit" data-dismiss="modal">{{ 'lang.storefront.layout.button.keep_buying'|t }}</button>
                        <a href="{{ site_url('account/wishlist') }}" class="btn btn-primary {{ store.theme_options.button_primary_shadow }}">{{ 'lang.storefront.layout.button.wishlist.see'|t }}</a>
                    </div>
                </div>
            </div>
        </div>
        <script>
            $(document).ready(function(){
                $('#wishlist-modal').modal('show');
            });
        </script>
    {% endif %}

    {% if events.cart %}
        <div class="modal" id="cart-modal" tabindex="-1" role="dialog" aria-labelledby="cart-modalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">

                    <div class="modal-body padding">
                        <div class="text-center">

                            {% if events.cart.stock_qty or events.cart.stock_sold_single or events.cart.no_stock %}

                                {% if events.cart.stock_qty %}
                                    {{ icons('ban', 'feather-48') }}
                                    <h2 class="margin-top">{{ 'lang.storefront.layout.events.cart.not_enough_stock'|t }}</h2>
                                {% endif %}
                                {% if events.cart.stock_sold_single %}
                                    {{ icons('ban', 'feather-48') }}
                                    <h3 class="margin-top">{{ 'lang.storefront.layout.events.cart.stock_sold_single'|t }} <strong>{{ events.cart.stock_sold_single }}</strong></h3>
                                {% endif %}
                                {% if events.cart.no_stock %}
                                    {{ icons('ban', 'feather-48') }}
                                    <h2 class="margin-top">{{ 'lang.storefront.layout.events.cart.products_without_stock'|t }}</h2>
                                {% endif %}

                            {% else %}

                                {% if events.cart.added %}
                                    {{ icons('check', 'feather-48') }}
                                    <h2 class="margin-top">{{ 'lang.storefront.layout.events.cart.added'|t }}</h2>
                                {% elseif events.cart.error %}
                                    {{ icons('times', 'feather-48') }}
                                    <h2 class="margin-top">{{ 'lang.storefront.layout.events.cart.error'|t }}</h2>
                                {% elseif events.cart.updated %}
                                    {{ icons('sync', 'feather-48') }}
                                    <h2 class="margin-top">{{ 'lang.storefront.layout.events.cart.updated'|t }}</h2>
                                {% elseif events.cart.session_updated_items or events.cart.session_not_updated_items or events.cart.session_updated %}
                                    {{ icons('sync', 'feather-48') }}
                                    <h2 class="margin-top">{{ 'lang.storefront.layout.events.cart.updated'|t }}</h2>

                                    {% if events.cart.session_updated_items %}
                                        <h4 class="text-left margin-top">{{ 'lang.storefront.layout.events.cart.updated_items'|t }}</h4>
                                        <ul class="text-left">
                                            {% for product in events.cart.session_updated_items %}
                                                <li><strong>{{ product.qty }}x</strong> - {{ product.title }}</li>
                                            {% endfor %}
                                        </ul>
                                    {% endif %}
                                    {% if events.cart.session_not_updated_items %}
                                        <h4 class="text-left margin-top">{{ 'lang.storefront.layout.events.cart.not_updated_items'|t }}</h4>
                                        <ul class="text-left">
                                            {% for product in events.cart.session_not_updated_items %}
                                                <li><strong>{{ product.qty }}x</strong> - {{ product.title }}</li>
                                            {% endfor %}
                                        </ul>
                                    {% endif %}
                                {% elseif events.cart.deleted %}
                                    {{ icons('trash-alt', 'feather-48') }}
                                    <h2 class="margin-top">{{ 'lang.storefront.layout.events.cart.deleted'|t }}.</h2>
                                {% endif %}

                            {% endif %}

                        </div>
                    </div>

                    <div class="modal-footer">
                        {% if events.cart.added or events.cart.session_updated_items or events.cart.session_not_updated_items %}
                            <button type="button" class="btn btn-default {{ store.theme_options.button_default_shadow }} link-inherit" data-dismiss="modal">{{ 'lang.storefront.layout.button.keep_buying'|t }}</button>
                            <a href="{{ site_url('cart') }}" class="btn btn-primary {{ store.theme_options.button_primary_shadow }}">{{ 'lang.storefront.layout.button.see_cart'|t }}</a>
                        {% else %}
                            <button type="button" class="btn btn-default {{ store.theme_options.button_default_shadow }} link-inherit" data-dismiss="modal">{{ 'lang.storefront.layout.button.close'|t }}</button>
                        {% endif %}
                    </div>

                </div>
            </div>
        </div>

        <script>
            $(document).ready(function(){
                $('#cart-modal').modal('show');
            });
        </script>
    {% endif %}

    {% if events.newsletter_error or events.newsletter_status_success or events.newsletter_status_error or events.newsletter_status_confirmation or events.newsletter_removal %}
        <div class="modal" id="newsletter-modal" tabindex="-1" role="dialog" aria-labelledby="newsletter-modalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">

                    <div class="modal-body padding">
                        <div class="text-center">
                            {{ icons('envelope', 'feather-48') }}

                            {% if events.newsletter_error %}
                                <h2 class="margin-top">Não foi possível efectuar o registo na newsletter:</h2>
                                <p>{{ events.newsletter_error }}</p>
                            {% endif %}

                            {% if events.newsletter_status_success %}
                                <h2 class="margin-top">{{ 'lang.apps.newsletter.success.message'|t }}</h2>
                            {% endif %}

                            {% if events.newsletter_status_error %}
                                <h2 class="margin-top">{{ 'lang.apps.newsletter.email.exists.message'|t }}</h2>
                            {% endif %}

                            {% if events.newsletter_status_confirmation %}
                                <h2 class="margin-top">{{ 'lang.apps.newsletter.email.sent.message'|t }}</h2>
                            {% endif %}

                            {% if events.newsletter_removal %}
                                <h2 class="margin-top">{{ 'lang.storefront.form.newsletter.label'|t }}</h2>
                                <p>{{ events.newsletter_removal }}</p>
                            {% endif %}
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-default {{ store.theme_options.button_default_shadow }} link-inherit" data-dismiss="modal">{{ 'lang.storefront.layout.button.close'|t }}</button>
                    </div>

                </div>
            </div>
        </div>

        <script>
            $(document).ready(function(){
                $('#newsletter-modal').modal('show');
            });
        </script>
    {% endif %}

    {% if events.unsubscribe %}
        <div class="modal" id="unsubscribe-modal" tabindex="-1" role="dialog" aria-labelledby="unsubscribe-modalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-body padding">
                        <div class="text-center">
                            {{ icons('envelope', 'feather-48') }}

                            <h2 class="text-muted">{{ 'lang.storefront.layout.events.unsubscribe_title'|t }}</h2>
                            <p>{{ 'lang.storefront.layout.events.unsubscribe_text'|t }}</p>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default {{ store.theme_options.button_default_shadow }} link-inherit" data-dismiss="modal">{{ 'lang.storefront.layout.button.close'|t }}</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            $(document).ready(function(){
                $('#unsubscribe-modal').modal('show');
            });
        </script>
    {% endif %}

    {% if events.payment_status %}
        <div class="modal" id="payment-modal" tabindex="-1" role="dialog" aria-labelledby="payment-modalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">

                    <div class="modal-body padding">
                        <div class="text-center">
                            {% if events.payment_status.success is same as (true) %}
                                {{ icons('check', 'feather-48') }}
                            {% elseif events.payment_status.success is same as (false) %}
                                {{ icons('times', 'feather-48') }}
                            {% else %}
                                {{ icons('check', 'feather-48') }}
                            {% endif %}

                            <h2 class="margin-top">{{ events.payment_status.message }}</h2>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-default {{ store.theme_options.button_default_shadow }} link-inherit" data-dismiss="modal">{{ 'lang.storefront.layout.button.close'|t }}</button>
                    </div>

                </div>
            </div>
        </div>

        <script>
            $(document).ready(function(){
                $('#payment-modal').modal('show');
            });
        </script>
    {% endif %}

    {% if events.contact_form_success or events.contact_form_errors %}
        <div class="modal" id="contact-modal" tabindex="-1" role="dialog" aria-labelledby="contact-modalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">

                    <div class="modal-body padding">
                        <div class="text-center">
                            {% if events.contact_form_success %}
                                {{ icons('envelope', 'feather-48') }}
                                <h2 class="margin-top">{{ 'lang.storefront.layout.events.contact_form_success.title'|t }}</h2>
                                <p>{{ 'lang.storefront.layout.events.contact_form_success.text'|t }}</p>
                            {% endif %}

                            {% if events.contact_form_errors %}
                                {{ icons('envelope', 'feather-48') }}
                                <h2 class="margin-top">{{ 'lang.storefront.layout.events.contact_form_error'|t }}</h2>
                                <p>{{ events.contact_form_errors }}</p>
                            {% endif %}
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-default {{ store.theme_options.button_default_shadow }} link-inherit" data-dismiss="modal">{{ 'lang.storefront.layout.button.close'|t }}</button>
                    </div>

                </div>
            </div>
        </div>

        <script>
            $(document).ready(function(){
                $('#contact-modal').modal('show');
            });
        </script>
    {% endif %}

    <div class="modal fade" id="user-geolocation-modal" tabindex="-1" role="dialog" aria-labelledby="user-geolocation-modalLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                {{ form_open(site_url('user_location'), { 'method' : 'post' }) }}
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">{{ 'lang.storefront.layout.button.close'|t }}</span></button>
                        <h3 class="user-geolocation-modal-choose-country-region">{{ 'lang.storefront.layout.modals.geolocation.choose_country'|t }}</h3>
                    </div>
                    <div class="modal-body">
                        <p><span class="flag-icon user-geolocation-modal-flag"></span> <span class="user-geolocation-modal-flag-ask-country">{{ 'lang.storefront.layout.modals.geolocation.ask_country'|t }}</span></p>
                        <select name="user-geolocation-modal-select-country" id="user-geolocation-modal-select-country" class="form-control">
                            {% for key, country in countries %}
                                <option value="{{ key }}">{{ country }}</option>
                            {% endfor %}
                        </select>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default {{ store.theme_options.button_default_shadow }} user-geolocation-modal-cancel" data-dismiss="modal">{{ 'lang.storefront.layout.button.cancel'|t }}</button>
                        <button type="submit" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} user-geolocation-modal-change-country-region">{{ 'lang.storefront.layout.modals.geolocation.button.change_country'|t }}</button>
                    </div>
                {{ form_close() }}
            </div>
        </div>
    </div>

    {# End Events #}

    <div id="fb-root"></div>

    <script>
        {% if store.custom_js %}
            //Custom JS
            {{ store.custom_js }}
        {% endif %}
    </script>

    <script src="{{ store.assets.plugins }}"></script>
    <script src="{{ store.assets.scripts }}"></script>

    {{ footer_content }}

</body>

</html>
