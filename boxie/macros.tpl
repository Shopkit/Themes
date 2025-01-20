{# Macros #}
{% macro product_list(product, category_badges) %}
    {% import _self as generic_macros %}

    {% set product_title = product.title|e_attr %}
    {% set product_url = product.url %}
    {% set product_category = product.categories[0] %}
    {% set card_thumbnail_type = store.theme_options.catalog_thumbail_type == 'square' ? 'square' : 'thumb' %}
    {% set second_image = product.images[0][card_thumbnail_type] %}
    {% set show_product_second_image = store.theme_options.show_product_second_image == 'show' and second_image ? 'has-second-image' : '' %}
    {% set card_text_align = store.theme_options.card_text_align == 'left' ? 'start' : (store.theme_options.card_text_align == 'right' ? 'end' : 'center' ) %}
    {% set card_hover_effect = store.theme_options.card_hover_effect != 'none' ? store.theme_options.card_hover_effect : '' %}
    {% set products_per_row = current_page == 'home' ? (store.theme_options.home_products_per_row is not null ? store.theme_options.home_products_per_row : '4') : (store.theme_options.products_per_row is not null ? store.theme_options.products_per_row : '4') %}

    <div class="product product-id-{{ product.id }} {{ product.status_alias }} {{ card_hover_effect }} {{ show_product_second_image }}" data-id="{{ product.id }}">
        <div class="{{ store.theme_options.card_shadow }}">
            <div class="product-view">
                <span class="product-badges" data-position="{{ store.theme_options.badges_position }}">
                    {% if product.status_alias == 'out_of_stock' %}
                        <div class="badge out_of_stock">{{ 'lang.storefront.macros.product.badge.out_of_stock'|t }}</div>
                    {% elseif product.status_alias == 'soon' %}
                        <div class="badge soon">{{ 'lang.storefront.macros.product.badge.soon'|t }}</div>
                    {% elseif product.promo == true %}
                        <div class="badge promo">
                            <div>
                                <span>{{ 'lang.storefront.macros.product.badge.promo'|t }}</span>
                                {% if product.price_promo_percentage == true %}
                                    <div class="product-promo-percent promo-percentage">-<span>{{ product.price_promo_percentage }}</span>%</div>
                                {% endif %}
                            </div>
                        </div>
                    {% elseif product.new == true %}
                        <span class="badge new">{{ 'lang.storefront.macros.product.badge.new'|t }}</span>
                    {% endif %}
                </span>

                <a class="product-preview" href="{{ product_url }}" data-thumbnail-type="{{ card_thumbnail_type }}">
                    <img class="product-pic lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image[card_thumbnail_type] }}" alt="" />
                    {% if show_product_second_image %}
                        <span class="secondary-img">
                            <img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ second_image }}" alt="{{ product_title }}" title="{{ product_title }}" class="lazy">
                        </span>
                    {% endif %}
                </a>
                {% if product.status == 1 and product.price_on_request == false and not (product.option_groups or product.extra_options) %}
                    <a class="product-btn btn btn-primary {{ store.theme_options.button_primary_shadow }}" href="{{ product.add_cart_url }}"><i data-feather="shopping-cart" class="feather-16"></i>&nbsp;{{ 'lang.storefront.layout.button.buy'|t }}</a>
                {% elseif product.option_groups or product.extra_options %}
                    <a class="product-btn btn btn-primary {{ store.theme_options.button_primary_shadow }}" href="{{ product_url }}"><i data-feather="plus-square" class="feather-16"></i>&nbsp;{{ 'lang.storefront.macros.product.options'|t }}</a>
                {% else %}
                    <a class="product-btn btn btn-primary {{ store.theme_options.button_primary_shadow }}" href="{{ product_url }}"><i data-feather="plus-square" class="feather-16"></i>&nbsp;{{ 'lang.storefront.macros.product.info'|t }}</a>
                {% endif %}
            </div>
            {% if product_category.active %}
                <div class="product-category text-truncate {{ category_badges[product_category.id|last] }}" data-toggle="tooltip" data-placement="top" title="">{{ product_category.title }}</div>
            {% endif %}
            <a class="product-name" href="{{ product_url }}">{{ product_title }}</a>
            <div class="product-details {{ product.price_on_request == true ? 'flex-wrap' }} justify-content-{{ card_text_align }}">
                {% if product_category.active and products_per_row < 4 %}
                    <div class="product-category text-truncate {{ category_badges[product_category.id|last] }}" data-toggle="tooltip" data-placement="top" title="">{{ product_category.title }}</div>
                {% endif %}
                <div class="product-price">
                    {% if product.price_range %}
                        <span class="product-actual">{{ product.price_min|money_with_sign }} — {{ product.price_max|money_with_sign }}</span>
                    {% elseif product.price_on_request == true %}
                        <span class="product-actual">{{ 'lang.storefront.macros.product.price_on_request'|t }}</span>
                    {% else %}
                        {% if product.promo == true %}
                            <span class="product-old">{{ product.price | money_with_sign }}</span>
                            <span class="product-actual">{{ product.price_promo | money_with_sign }}</span>
                        {% else %}
                            <span class="product-actual">{{ product.price | money_with_sign }}</span>
                        {% endif %}
                    {% endif %}
                </div>
            </div>
            {% if product_category.active and products_per_row >= 4 %}
                <div class="product-category text-truncate {{ category_badges[product_category.id|last] }} d-none d-md-block margin-top-xs" data-toggle="tooltip" data-placement="top" title="">{{ product_category.title }}</div>
            {% endif %}
        </div>
    </div>
{% endmacro %}

{% macro product_list_media(product) %}
    {% set product_title = product.title %}
    {% set card_thumbnail_type = store.theme_options.catalog_thumbail_type == 'square' ? 'square' : 'thumb' %}

    <div class="media">
        <a class="media-left media-top" href="{{ product.permalink }}"><img class="lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image[card_thumbnail_type] }}" alt="{{ product_title }}" title="{{ product_title }}" width="50"></a>
        <div class="media-body">
            <h5 class="media-heading bold text-dark"><a href="{{ product.permalink }}" class="link-inherit">{{ product_title }}</a></h5>
            {% if product.price_on_request == true %}
                <span class="price">{{ 'lang.storefront.macros.product.price_on_request'|t }}</span>
            {% else %}
                {% if product.promo == true %}
                     <span class="price">{{ product.price_promo | money_with_sign }}</span> &nbsp; <del class="small text-muted">{{ product.price | money_with_sign }}</del>
                {% else %}
                    <span class="price">{{ product.price | money_with_sign }}</span>
                {% endif %}
            {% endif %}
        </div>
    </div>
{% endmacro %}

{% macro category_list(category, show_number_products = true) %}
    {% import _self as generic_macros %}

    {% set category_title = category.title|e_attr %}
    {% set category_url = category.url %}
    {% set card_text_align = store.theme_options.card_text_align == 'left' ? 'start' : (store.theme_options.card_text_align == 'right' ? 'end' : 'center' ) %}
    {% set card_hover_effect = store.theme_options.card_hover_effect != 'none' ? store.theme_options.card_hover_effect : '' %}
    {% set card_thumbnail_type = store.theme_options.catalog_thumbail_type == 'square' ? 'square' : 'thumb' %}


    <div class="category category-id-{{ category.id }} {{ card_hover_effect }}">
        <div class="{{ store.theme_options.card_shadow }}">
            <div class="category-view">
                <a class="category-preview" href="{{ category_url }}">
                    <img class="category-pic lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ category.image[card_thumbnail_type] }}" alt="{{ category_title }}" title="{{ category_title }}" />
                </a>
                <a class="category-btn btn btn-primary {{ store.theme_options.button_primary_shadow }}" href="{{ category_url }}">{{ 'lang.storefront.macros.button.explore'|t }}</a>
            </div>
            <a class="category-name" href="{{ category_url }}">{{ category_title }}</a>
            <div class="category-details justify-content-{{ card_text_align }}">
                {% if not category.parent == 0 and category.children and show_number_products %}
                    <span>{{ category.children|length }} {{ 'lang.storefront.layout.categories.title'|t }}</span>
                {% elseif show_number_products %}
                    <span class="total-products">{{ category.total_products }} {{ 'lang.storefront.macros.products.title'|t }}</span>
                {% endif %}
            </div>
        </div>
    </div>
{% endmacro %}

{% macro order_by(get, order_options) %}
    <select class="form-control js-order-by">
        {% for order_option, order_title in order_options %}
            {% if order_option != get.order_by and (order_option != 'rating' or (order_option == 'rating' and apps.product_reviews|length)) %}
                <option {% if not query_order %}data-display="{{ 'lang.storefront.layout.order_options.label'|t }}"{% endif %} value="{{ order_option }}" {{ order_option == get.order_by ? 'selected' }}>{{ order_title }}</option>
            {% endif %}
        {% endfor %}
    </select>
{% endmacro %}

{% macro filters_list(products, main_parent, category, tag) %}

    {% set products_price_limits = price_range("category:#{category.id} tag:#{tag.handle}")[0] %}
    {% set tags = tags("category:#{category.id} limit:50") %}

    {% set lowest_price = get.price_min ? get.price_min : products_price_limits.price_min|round %}
    {% set highest_price = get.price_max ? get.price_max : products_price_limits.price_max|round %}

    {% set interval = lowest_price == highest_price ? 1 : 6 %}
    {% set ranges = [] %}
    {% set price_range = (highest_price / interval)|round %}

    <div class="filters-open js-filters-open">{{ 'lang.storefront.macros.filters.title'|t }}</div>
    <div class="filters-wrap js-filters-wrap">
        <div class="dropdown filter" data-type="price">
            <a href="#" class="dropdown-toggle" role="button" data-toggle="dropdown" data-flip="false" aria-haspopup="true" aria-expanded="false">{{ 'lang.storefront.cart.product.price.label'|t }}</a>
            <div class="dropdown-menu">
                {% for i in 0..interval - 1 %}
                    {% set start = loop.first ? lowest_price : (start + price_range) %}
                    {% set ranges = ranges|merge([[start, (start + price_range)]]) %}

                    <a class="dropdown-item" href="#" data-min="{{ start }}" data-max="{{ (start + price_range) }}" data-type="price">{{ start|money_without_trailing_zeros }} - {{ (start + price_range)|money_without_trailing_zeros }}</a>
                {% endfor %}
            </div>
        </div>

        {% if tags and current_page != 'tag' %}
            <div class="dropdown filter" data-type="tag">
                <a href="#" class="dropdown-toggle" role="button" data-toggle="dropdown" data-flip="false" aria-haspopup="true" aria-expanded="false">{{ 'lang.storefront.macros.filters.title'|t }}</a>
                <div class="dropdown-menu">
                    {% for tag in tags %}
                        <a class="dropdown-item" href="#" data-tag="{{ tag.handle }}" data-type="tag">{{ tag.title }}</a>
                    {% endfor %}
                </div>
            </div>
        {% endif %}

        {% if main_parent.children %}
            <div class="dropdown filter" data-type="category">
                <a href="#" class="dropdown-toggle" role="button" data-toggle="dropdown" data-flip="false" aria-haspopup="true" aria-expanded="false">{{ main_parent.title }}</a>
                <div class="dropdown-menu">
                    {% for children in main_parent.children %}
                        <a class="dropdown-item" href="{{ children.url }}" data-type="category">{{ children.title }}</a>
                    {% endfor %}
                </div>
            </div>
        {% endif %}
    </div>
{% endmacro %}

{% macro google_translate(apps_google_translate, media_queries_class) %}
    {% set default_lang = apps_google_translate.default_language %}

    <div class="languages-dropdown btn-group {{ media_queries_class }} hidden">
        <button type="button" class="btn btn-sm dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <span class="current-language"><span class="flag-icon"></span></span>&nbsp;
            <span class="caret"></span>
        </button>
        <ul class="dropdown-menu well-featured {{ store.theme_options.well_featured_shadow }}">
            <li class="googtrans-{{ default_lang }}"><a href="{{ current_url() }}" lang="{{ default_lang }}"><span class="flag-icon flag-icon-{{ apps_google_translate.flags[default_lang] }}"></span></a></li>
            {% for lang in apps_google_translate.languages|split(',') %}
                {% if lang != default_lang %}
                    <li class="googtrans-{{ lang }}"><a href="#googtrans({{ lang }})" lang="{{ lang }}"><span class="flag-icon flag-icon-{{ apps_google_translate.flags[lang] }}"></span></a></li>
                {% endif %}
            {% endfor %}
        </ul>
    </div>
{% endmacro %}

{% macro gallery() %}
    {% if store.gallery and (current_page in store.theme_options.gallery_location or 'all' in store.theme_options.gallery_location) %}
        {% set layout_container = store.theme_options.layout_container == 'fluid' ? 'container-fluid' : 'container' %}

        <div class="home-slideshow section">
            <div class="{{ layout_container }}">
                <div class="slideshow-container">

                    <div class="slideshow-gallery">
                        {% for gallery in store.gallery %}

                            {% set has_slide_content = gallery.title or gallery.button or gallery.description ? 'has-slide-content' %}

                            <div class="slide {{ has_slide_content }}" style="background-image:url({{ gallery.image.full }});background-size: cover;background-position: center center;background-repeat: no-repeat;">
                                {% if has_slide_content %}
                                    <div class="slideshow-overlay"></div>
                                    <div class="slideshow-details">
                                        {% if gallery.title %}
                                            {% if gallery.link %}
                                                <h1 class="slideshow-title title"><a href="{{ gallery.link }}" class="link-inherit">{{ gallery.title }}</a></h1>
                                            {% else %}
                                                <h1 class="slideshow-title title">{{ gallery.title }}</h1>
                                            {% endif %}
                                        {% endif %}
                                        {% if gallery.description %}
                                            <div class="slideshow-description">{{ gallery.description }}</div>
                                        {% endif %}
                                        {% if gallery.button %}
                                            <a class="slideshow-btn btn btn-primary {{ store.theme_options.button_primary_shadow }}" href="{{ gallery.button_link }}" {{ gallery.target_blank == '1' ? 'target="_blank"' }} role="button">{{ gallery.button }}</a>
                                        {% endif %}
                                    </div>
                                {% endif %}
                            </div>
                        {% endfor %}
                    </div>
                </div>
            </div>
        </div>
    {% endif %}
{% endmacro %}

{% macro cart_notice() %}
    {% if store.theme_options.cart_notice and current_page in store.theme_options.cart_notice_location %}
        <div class="callout callout-info {{ store.theme_options.well_info_shadow }}">
            {{ store.theme_options.cart_notice }}
        </div>
    {% endif %}
{% endmacro %}

{% macro newsletter_block() %}
    {% set layout_container = store.theme_options.layout_container == 'fluid' ? 'container-fluid' : 'container' %}
    <div class="newsletter section hidden-xs">
        <div class="{{ layout_container }}">
            <div class="newsletter-container well-default {{ store.theme_options.well_default_shadow }}">
                <h2 class="newsletter-title title title_mb-md">{{ 'lang.storefront.home.block.newsletter.title'|t }}</h2>
                <div class="newsletter-form needs-validation" novalidate="novalidate">
                    <div class="form-group">
                        <input class="form-control" type="email" id="email_newsletter" name="email_newsletter" placeholder="{{ 'lang.storefront.form.email.placeholder'|t }}" />
                    </div>
                    <div class="newsletter-btns">
                        <button class="newsletter-btn btn btn-primary {{ store.theme_options.button_primary_shadow }} btn-block submit-newsletter">{{ 'lang.storefront.home.block.newsletter.subscribe'|t }}</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
{% endmacro %}

{% macro reviews_block(reviews) %}
    {% set layout_container = store.theme_options.layout_container == 'fluid' ? 'container-fluid' : 'container' %}
    {% if current_page in apps.product_reviews.product_reviews_block or 'all' in apps.product_reviews.product_reviews_block %}
        <div class="review section">
            <div class="{{ layout_container }}">
                <div class="review-container well-default {{ store.theme_options.well_default_shadow }}">
                    <div class="row align-items-center">
                        <div class="col-lg-6">
                            <div class="review-box">
                                <h2 class="review-title title">{{ 'lang.storefront.about.reviews.title'|t }}</h2>
                                {% if current_page == 'product' %}
                                    <button type="button" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} margin-top" data-toggle="modal" data-target="#app_shopkit_product_reviews_modal">{{ 'lang.storefront.product.reviews.see_more'|t }}</button>
                                {% endif %}
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <div class="review-wrap">
                                <div class="review-slider js-slider-review">
                                    {% for review in reviews.reviews %}
                                        <div class="review-item">
                                            <div class="review-ava"><img class="review-pic" src="https://www.gravatar.com/avatar/{{ md5(review.email) }}?d=mp" alt="{{ review.name }}" /></div>
                                            <div class="review-author">{{ review.name }}</div>
                                            <div class="review-rating"><div style="height:24px;" class="product-star-rating review-rating-stars margin-bottom-xxs" data-initial-rating="{{ review.rating }}" data-active-color="orange" data-star-size="15"></div></div>
                                            <div class="review-text">
                                                <a href="{{ site_url('product') ~ '/' ~ review.product_handle }}">{{ review.product_title }}</a>
                                                {{ review.body }}
                                            </div>
                                        </div>
                                    {% endfor %}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    {% endif %}
{% endmacro %}

{% macro popup_interactions(popup) %}
    {% if popup.interaction == 'newsletter' and apps.newsletter %}
        <div class="popup-newsletter newsletter form-inline text-center">
            <input type="email" id="email_newsletter" name="email_newsletter" class="form-control input-lg" placeholder="{{ popup.interaction_newsletter_input_placeholder|e('html_attr') }}" required style="background-color:{{ popup.background_color }};color:{{ popup.text_color }};border-color:{{ popup.text_color }}">
            <button type="button" class="btn btn-no-shadow btn-lg submit-newsletter" data-dismiss="modal" data-unique_id="{{ popup.unique_id }}" style="background-color:{{ popup.text_color }};color:{{ popup.background_color }};border-color:{{ popup.text_color }}">{{ popup.interaction_newsletter_button_text }}</button>
        </div>
    {% endif %}
    {% if popup.interaction == 'button' %}
        <div class="popup-button text-center">
            <a href="{{ popup.interaction_button_button_link }}" class="btn btn-lg" data-unique_id="{{ popup.unique_id }}" {{ popup.interaction_button_button_target_blank ? 'target="_blank"' }} style="background-color:{{ popup.text_color }};color:{{ popup.background_color }};">{{ popup.interaction_button_button_text }}</a>
        </div>
    {% endif %}
{% endmacro %}
