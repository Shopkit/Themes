{#
Description: Product Page
#}

{% macro wishlist_block(product, store) %}
    {% if store.settings.cart.users_registration != 'disabled' %}
        {% if not product.wishlist.status %}
            <a href="{{ product.wishlist.add_url }}" class="card-favorite">
                {{ icons('heart') }}
            </a>
        {% else %}
            <a href="{{ product.wishlist.remove_url }}" class="card-favorite added">
                {{ icons('heart') }}
            </a>
        {% endif %}
    {% endif %}
{% endmacro %}

{% import _self as product_macros %}
{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    {% set product_is_vendible = product.status == 1 or (product.status == 3 and product.stock.stock_backorder) %}
    {% set product_title = product.title|e_attr %}
    {% set product_url = product.url %}

    <div class="breadcrumbs hidden-xs">
        <div class="{{ layout_container }}">
            <ul class="breadcrumbs-list">
                <li class="breadcrumbs-item">
                    <a class="breadcrumbs-link" href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a>
                </li>
                {% if product.categories|first.active %}
                    <li class="breadcrumbs-item">
                        <a class="breadcrumbs-link" href="{{ product.categories|first.url }}">{{ product.categories|first.title }}</a>
                    </li>
                {% endif %}
                <li class="breadcrumbs-item">{{ product_title }}</li>
            </ul>
        </div>
    </div>

    <div class="product-detail section">
        <div class="{{ layout_container }}">
            <div class="row">
                <div class="col-xl-7">
                    <div class="card-gallery">

                        <div class="card-container" id="gallery">
                            <div class="card-slider">
                                <div class="card-slide">
                                    <a class="card-preview" data-image="{{ product.image.full }}" data-zoom-image="{{ product.image.full }}" href="#">
                                        <img class="card-pic lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image.square }}" alt="{{ product_title|e_attr }}">
                                    </a>
                                </div>
                                {% for image in product.images %}
                                    <div class="card-slide">
                                        <a class="card-preview" data-image="{{ image.full }}" data-zoom-image="{{ image.full }}" href="#">
                                            <img class="card-pic lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ image.square }}" alt="{{ product_title|e_attr }}">
                                        </a>
                                    </div>
                                {% endfor %}

                            </div>
                        </div>

                        <div class="card-wrap">
                            {% if product.price_promo_percentage == true %}
                                <div class="card-status card-status_sale promo-percentage">-<span class="data-promo-percentage">{{ product.price_promo_percentage }}</span>%</div>
                            {% endif %}
                            <div class="card-preview">
                                <img class="card-pic js-zoom lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image.full }}" data-zoom-image="{{ product.image.full }}" alt="{{ product_title|e_attr }}">
                            </div>
                            <div class="card-icon">
                                <svg role="img" viewBox="0 0 22 22" width="20" height="20" xmlns="http://www.w3.org/2000/svg">
                                    <path fill-rule="evenodd" clip-rule="evenodd" d="M2 10a8 8 0 1 1 16 0 8 8 0 0 1-16 0zm8-10C4.477 0 0 4.477 0 10s4.477 10 10 10a9.959 9.959 0 0 0 6.329-2.257l3.964 3.964a1 1 0 0 0 1.414-1.414l-3.964-3.964A9.958 9.958 0 0 0 20 9.999C20 4.478 15.523 0 10 0zm0 6a1 1 0 0 1 1 1v2h2a1 1 0 1 1 0 2h-2v2a1 1 0 1 1-2 0v-2H7a1 1 0 1 1 0-2h2V7a1 1 0 0 1 1-1z"></path>
                                </svg>
                            </div>
                        </div>

                    </div>
                </div>

                <div class="col-xl-5">
                    <div class="card-inner">
                        <h1 class="card-title title product-title">{{ product_title }}</h1>
                        <div class="card-details">
                            <div class="card-prices">
                                {% if product.price_on_request == true %}
                                    <span class="card-old hidden"></span>
                                    <span class="card-actual">{{ 'lang.storefront.macros.product.price_on_request'|t }}</span>
                                {% else %}
                                    {% if product.promo == true %}
                                        <span class="card-old">{{ product.price | money_with_sign }}</span>
                                        <span class="card-actual">{{ product.price_promo | money_with_sign }}</span>
                                    {% else %}
                                        <span class="card-old hidden"></span>
                                        <span class="card-actual">{{ product.price | money_with_sign }}</span>
                                    {% endif %}
                                {% endif %}
                            </div>
                            <div class="data-product-info">
                                <div>
                                    {% if user.wholesale is same as(true) and product.wholesale == true and store.settings.wholesale.show_regular_price %}
                                        <div class="small text-light-gray">{{ 'lang.storefront.product.wholesale.regular_price'|t }} <span class="data-price-non-wholesale">{{ product.price_non_wholesale | money_with_sign }}</span></div>
                                    {% endif %}

                                    {% if product.wholesale != true or (product.wholesale == true and not user.wholesale) %}
                                        <div class="small text-light-gray promo-percentage {% if product.price_promo_percentage == false %}hidden{% endif %}">
                                            {{ 'lang.storefront.product.discount_info'|t([ product.price_promo_percentage == true ? product.price_promo_percentage]) }}
                                        </div>
                                    {% endif %}

                                    {% if product.tax > 0 %}
                                        {% if store.taxes_included == false %}
                                            <div class="small text-light-gray">{{ 'lang.storefront.product.tax.percentage_info'|t([user.l10n.tax_name, product.tax]) }}</div>
                                        {% else %}
                                            <div class="small text-light-gray">{{ 'lang.storefront.product.tax_included_info'|t([user.l10n.tax_name]) }}</div>
                                        {% endif %}
                                    {% endif %}
                                </div>
                            </div>
                        </div>

                        {% set product_reference = product.reference and store.theme_options.show_product_sku == 'show' %}
                        {% set product_barcode = product.barcode and store.theme_options.show_product_barcode == 'show' %}
                        {% if product.stock.stock_show or product_reference or product_barcode %}
                            {% if product.stock.stock_show %}
                                <div class="card-stock">Stock:<span class="stock"><span class="data-product-stock_qty stock-number">{{ product.stock.stock_qty }}</span> unidades<span></div>
                            {% endif %}
                            {% if product_reference %}
                                <div class="card-code">{{ 'lang.storefront.product.sku.label'|t }}<span class="card-number sku">{{ product.reference }}</span></div>
                            {% endif %}
                            {% if product_barcode %}
                                <div class="card-code">{{ 'lang.storefront.product.ean.label'|t }}<span class="card-number ean">{{ product.barcode }}</span></div>
                            {% endif %}
                        {% endif %}

                        {% if store.settings.rewards.active and store.settings.rewards.message_product %}
                            <div class="callout callout-info {{ product.rewards == 0 ? 'hidden' }}">
                                <i class="icon margin-right-xxs">{{ icons('trophy') }}</i>
                                {{ store.settings.rewards.message_product|rewards_message(product.rewards) }}
                            </div>
                        {% endif %}

                        {{ form_open_cart(product.id, { 'class' : 'add-cart' }) }}

                            {% if product.option_groups and product_is_vendible %}
                                <div class="product-options margin-bottom">
                                    {% for option_groups in product.option_groups %}

                                        <label for="{{ option_groups.title|slug }}">{{ option_groups.title }}</label>

                                        <select class="form-control select-product-options" name="option[]" id="{{ option_groups.title|slug }}">
                                            {% for option in option_groups.options %}
                                                <option value="{{ option.id }}" data-title="{{ option.title }}">
                                                    {{ option.title }}
                                                </option>
                                            {% endfor %}
                                        </select>
                                    {% endfor %}
                                </div>
                            {% endif %}

                            {% if product.extra_options %}
                                <div class="extra-options margin-bottom {{ product.option_groups or not product_is_vendible  ? 'hidden' : '' }}">
                                    {% for extra_option in product.extra_options %}
                                        {% set field_disabled = extra_option.required ? '' : 'disabled' %}
                                        {% set field_required = extra_option.required ? 'required' : '' %}
                                        {% set field_checked = extra_option.required ? 'checked' : '' %}
                                        {% set field_hidden = extra_option.required ? '' : 'hidden' %}
                                        {% set field_size = extra_option.size ? 'maxlength="'~ extra_option.size ~'"' : 'maxlength="'~ (extra_option.type == 'textarea' ? '512' : '255') ~'"' %}
                                        {% set field_tip = extra_option.description ? '<span data-toggle="tooltip" data-placement="top" title="'~ extra_option.description ~'">' ~ icons('question-circle') ~ '</span>' : ''  %}
                                        {% set field_description = extra_option.description ? extra_option.description : 'lang.storefront.product.extra_options.type_value'|t %}

                                        <div class="extra-option margin-top-xs  well-default {{ store.theme_options.well_default_shadow }} well-sm" data-id="{{ extra_option.alias }}">
                                            {% if extra_option.type == 'input' %}
                                                <div class="checkbox">
                                                    <label class="margin-0">
                                                        <input type="checkbox" data-target="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" {{ field_required }} {{ field_checked }}>
                                                        {{ extra_option.title }}{{ extra_option.price ? ' - ' ~ extra_option.price_formatted : '' }}
                                                    </label> {{ field_tip }}
                                                </div>
                                                <input type="text" class="margin-top-xs form-control {{ field_hidden }}" name="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" id="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" placeholder="{{ field_description }}" {{ field_required }} {{ field_disabled }} {{ field_size }}>

                                            {% elseif extra_option.type == 'textarea' %}
                                                <div class="checkbox">
                                                    <label class="margin-0">
                                                        <input type="checkbox" data-target="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" {{ field_required }} {{ field_checked }}>
                                                        {{ extra_option.title }}{{ extra_option.price ? ' - ' ~ extra_option.price_formatted : '' }}
                                                    </label> {{ field_tip }}
                                                </div>
                                                <textarea class="form-control {{ field_hidden }} margin-top-xs" name="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" id="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" placeholder="{{ field_description }}" {{ field_required }} {{ field_disabled }} {{ field_size }}></textarea>

                                            {% elseif extra_option.type == 'select' %}
                                                <div class="checkbox">
                                                    <label class="margin-0">
                                                        <input type="checkbox" data-target="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" {{ field_required }} {{ field_checked }}>
                                                        {{ extra_option.title }}{{ extra_option.price ? ' - ' ~ extra_option.price_formatted : '' }}
                                                    </label> {{ field_tip }}
                                                </div>
                                                <select class="form-control {{ field_hidden }} margin-top-xs" name="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" id="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" {{ field_required }} {{ field_disabled }}>
                                                    <option value="" selected disabled>{{ 'lang.storefront.product.extra_options.select_option'|t }}</option>
                                                    {% for option in extra_option.options %}
                                                        <option value="{{ option|e }}">{{ option }}</option>
                                                    {% endfor %}
                                                </select>

                                            {% elseif extra_option.type == 'checkbox' %}
                                                <div class="checkbox">
                                                    <label class="margin-0">
                                                        <input type="checkbox" name="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" id="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" value="1" {{ field_required }}>
                                                        {{ extra_option.title }}{{ extra_option.price ? ' - ' ~ extra_option.price_formatted : '' }}
                                                    </label> {{ field_tip }}
                                                </div>

                                            {% elseif extra_option.type == 'date' %}
                                                <div class="checkbox">
                                                    <label class="margin-0">
                                                        <input type="checkbox" data-target="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" {{ field_required }} {{ field_checked }}>
                                                        {{ extra_option.title }}{{ extra_option.price ? ' - ' ~ extra_option.price_formatted : '' }}
                                                    </label> {{ field_tip }}
                                                </div>
                                                <input type="text" data-datepicker class="form-control {{ field_hidden }} margin-top-xs" name="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" id="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" placeholder="{{ field_description }}" {{ field_required }} {{ field_disabled }} {{ field_size }}>

                                            {% elseif extra_option.type == 'color' %}
                                                <div class="checkbox">
                                                    <label class="margin-0">
                                                        <input type="checkbox" data-target="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" {{ field_required }} {{ field_checked }}>
                                                        {{ extra_option.title }}{{ extra_option.price ? ' - ' ~ extra_option.price_formatted : '' }} <span class="extra-option-option-label hidden">- <span></span></span>
                                                    </label> {{ field_tip }}
                                                </div>
                                                <div class="list-colors {{ field_hidden }} margin-top-xs" name="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}">
                                                    {% for option in extra_option.options %}
                                                        {% set option_background = option.type == 'color' ? 'background:'~ option.color ~';' : 'background:url('~ option.file.images.square ~') center / contain no-repeat;' %}
                                                        <label for="{{ extra_option.alias ~ '_' ~ loop.index0 }}" class="relative badge badge-md extra-option-badge margin-bottom-xs margin-right-xxs" data-toggle="tooltip" title="{{ option.title }}">
                                                            <div class="badge-color" style="{{ option_background }}"></div>
                                                            <input type="radio" name="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" id="{{ extra_option.alias ~ '_' ~ loop.index0 }}" value="{{ option.title }}" {{ field_required }} {{ field_disabled }} {{ field_size }}>
                                                        </label>
                                                    {% endfor %}
                                                </div>
                                            {% endif %}
                                        </div>
                                    {% endfor %}
                                </div>
                            {% endif %}

                            {% if product_is_vendible %}
                                <div class="card-control data-product-info">
                                    <div class="card-counter counter">
                                        <button class="counter-btn counter-btn_minus" type="button">
                                            {{ icons('angle-left') }}
                                        </button>
                                        <input class="counter-input" type="text" name="qtd" value="1" size="3" {% if product.stock.stock_sold_single %} data-toggle="tooltip" data-placement="top" title="{{ 'lang.storefront.cart.product_limit.tooltip'|t }}" readonly {% endif %}>
                                        <button class="counter-btn counter-btn_plus" type="button">
                                            {{ icons('angle-right') }}
                                        </button>
                                    </div>

                                    <button type="submit" class="card-btn btn btn-primary {{ store.theme_options.button_primary_shadow }}">{{ 'lang.storefront.layout.button.buy'|t }}</button>

                                    {{ product_macros.wishlist_block(product, store) }}

                                </div>

                                <div class="card-control data-product-on-request">
                                    <a href="{{ site_url("contact?p=") ~ 'lang.storefront.product.label'|t([product_title])|url_encode }}" class="card-btn btn btn-primary {{ store.theme_options.button_primary_shadow }} price-on-request">{{ icons('envelope') }}&nbsp;{{ 'lang.storefront.product.contact.button'|t }}</a>
                                    {{ product_macros.wishlist_block(product, store) }}
                                </div>
                            {% elseif product.status == 3 %}
                                <div class="well well-default {{ store.theme_options.well_default_shadow }}">
                                    {{ 'lang.storefront.product.status.out_of_stock'|t }}
                                </div>
                            {% elseif product.status == 4 %}
                                <div class="well well-default {{ store.theme_options.well_default_shadow }}">
                                    {{ 'lang.storefront.product.status.soon'|t }}
                                </div>
                            {% endif %}

                        {{ form_close() }}

                        <div id="payment-method-messaging-element"></div>

                        <div class="table-product-attributes text-left margin-top">
                            <div class="table-responsive no-margin">
                                <table class="table">
                                    {% if product.brand %}
                                        <tr class="product-brand">
                                            <th>{{ 'lang.storefront.product.brand.label'|t }}</th>
                                            <td><a href="{{ product.brand.url }}" class="text-underline text-link">{{ product.brand.title }}</a></td>
                                        </tr>
                                    {% endif %}

                                    {% if product.tags %}
                                        <tr class="product-tags">
                                            <th>{{ 'lang.storefront.product.tags.label'|t }}</th>
                                            <td>
                                                <ul class="list-inline list-unstyled">
                                                {% for tag in product.tags %}<li><a href="{{ tag.url }}" class="product-tag badge badge-pill badge-light badge-outline">{{ tag.title }}</a></li>{% endfor %}
                                                </ul>
                                            </td>
                                        </tr>
                                    {% endif %}

                                    {% for custom_field in product.custom_fields %}
                                        <tr class="product-custom-fields" id="custom_field_{{ custom_field.alias }}">
                                            <th>{{ custom_field.title }}</th>
                                            <td>{% for custom_field_value in custom_field.values %}{{ custom_field_value.value }}{{ not loop.last ? ', ' }}{% endfor %}</td>
                                        </tr>
                                    {% endfor %}

                                    {% if product.file %}
                                        <tr class="download">
                                            <th>{{ 'lang.storefront.product.download_file.label'|t }}</th>
                                            <td>
                                                <a target="_blank" href="{{ product.file }}">{{ icons('download', 'feather-16') }} {{ 'lang.storefront.product.download_file.button'|t }}</a>
                                            </td>
                                        </tr>
                                    {% endif %}

                                    <tr>
                                        <th>{{ 'lang.storefront.product.share.label'|t }}</th>
                                        <td>
                                            <div class="share">
                                                <a target="_blank" href="http://www.facebook.com/sharer.php?u={{ product_url }}" class="text-muted">{{ icons('facebook', 'feather-20') }}</a> &nbsp;
                                                <a target="_blank" href="http://www.facebook.com/dialog/send?app_id=229578494202981&link={{ product_url }}&redirect_uri={{ product_url }}" class="text-muted">{{ icons('facebook-messenger') }}</a> &nbsp;
                                                <a target="_blank" href="https://wa.me/?text={{ "#{product.title}: #{product_url}"|url_encode }}" class="text-muted">{{ icons('whatsapp') }}</a> &nbsp;
                                                <a target="_blank" href="https://twitter.com/share?url={{ product_url }}&text={{ character_limiter(description, 100)|url_encode }}" class="text-muted">{{ icons('twitter', 'feather-20') }}</a> &nbsp;
                                                <a target="_blank" href="https://pinterest.com/pin/create/bookmarklet/?media={{ product.image.full }}&url={{ product_url }}&description={{ product.title|url_encode }}" class="text-muted">{{ icons('pinterest-p') }}</a>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    {% if product.description or product.tabs or product.video_embed_url or apps.facebook_comments.comments_products %}
        <div class="details section">
            <div class="{{ layout_container }}">
                <div class="row">
                    <div class="col-xl-6">
                        <ul class="nav" role="tablist">
                            {% if product.description %}
                                <li class="nav-item" role="presentation"><a class="nav-link active" href="#tab-details" role="tab" data-toggle="tab"><h1 class="details-title title">{{ 'lang.storefront.product.description.label'|t }}</h1></a></li>
                            {% endif %}
                            {% if product.tabs %}
                                {% for tab in product.tabs %}
                                    <li class="nav-item" role="presentation"><a class="nav-link" href="#tab-{{ tab.slug }}" role="tab" data-toggle="tab"><h1 class="details-title title">{{ tab.title }}</h1></a></li>
                                {% endfor %}
                            {% endif %}
                            {% if product.video_embed_url %}
                                <li class="nav-item" role="presentation"><a class="nav-link" href="#tab-video" role="tab" data-toggle="tab"><h1 class="details-title title">{{ 'lang.storefront.product.video.label'|t }}</h1></a></li>
                            {% endif %}
                            {% if apps.facebook_comments.comments_products %}
                                <li class="nav-item" role="presentation"><a class="nav-link" href="#tab-comments" role="tab" data-toggle="tab"><h1 class="details-title title">{{ 'lang.storefront.product.comments.label'|t }}</h1></a></li>
                            {% endif %}
                        </ul>
                    </div>
                    <div class="col-xl-6">
                        <div class="details-list">
                            <div class="tab-content details-item">
                                {% if product.description %}
                                    <div role="tabpanel" class="tab-pane active details-text" id="tab-details">
                                        {{ product.description  }}
                                    </div>
                                {% endif %}

                                {% if product.tabs %}
                                    {% for tab in product.tabs %}
                                        <div role="tabpanel" class="tab-pane details-text" id="tab-{{ tab.slug }}">
                                            {{ tab.content }}
                                        </div>
                                    {% endfor %}
                                {% endif %}

                                <div role="tabpanel" class="tab-pane details-text" id="tab-video">
                                    {% if product.video_embed_url %}
                                        <div class="product-video embed-responsive embed-responsive-16by9" data-service="{{ product.video_embed_url matches '/youtube/' ? 'youtube' : 'vimeo' }}" data-id="{{ product.video_embed_url|split('/')|last }}" data-ratio="16:9" data-autoscale>
                                            {% if not apps.cookies or (apps.cookies and not apps.cookies.consent_mode) %}
                                                <iframe width="560" height="315" src="{{ product.video_embed_url }}" allow="autoplay; encrypted-media" allowfullscreen></iframe>
                                            {% endif %}
                                        </div>
                                    {% endif %}
                                </div>

                                <div role="tabpanel" class="tab-pane details-text" id="tab-comments">
                                    {% if apps.facebook_comments.comments_products %}
                                        <div class="facebook-comments">
                                            <div class="fb-comments" data-href="{{ product.permalink }}" data-numposts="5" data-width="100%"></div>
                                        </div>
                                    {% endif %}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    {% endif %}

    <div class="related-products section hidden" data-load="related-products" data-products="{{ product.id }}" data-num-products="9" data-products-per-row="{{ products_per_row }}" data-css-class-wrapper="product-related-products products-list">
        <div class="{{ layout_container }}">
            <h2 class="products-title title title_mb-lg">{{ product.related_products.title }}</h2>
            <div class="slider-container">
                <div class="related-products-placement"></div>
            </div>
        </div>
    </div>

{% endblock %}
