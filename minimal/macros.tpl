{# Macros #}
{% macro product_list(product) %}
    {% import _self as generic_macros %}

    {% set product_title = product.title|e_attr %}
    {% set product_url = product.url %}
    {% set card_thumbnail_type = store.theme_options.catalog_thumbail_type == 'square' ? 'square' : 'thumb' %}
    {% set second_image = product.images[0][card_thumbnail_type] %}
    {% set show_product_second_image = store.theme_options.show_product_second_image == 'show' and second_image ? 'has-second-image' : '' %}
    {% set card_hover_effect = store.theme_options.card_hover_effect != 'none' ? store.theme_options.card_hover_effect : '' %}

    <article class="product product-id-{{ product.id }} {{ product.status_alias }} {{ card_hover_effect }} {{ show_product_second_image }}" data-id="{{ product.id }}">

        <div class="product-wrapper {{ store.theme_options.card_shadow }}">
            <a href="{{ product_url }}">
                <span class="product-badges" data-position="{{ store.theme_options.badges_position }}">
                    {% if product.status_alias == 'out_of_stock' %}
                        <span class="badge out_of_stock">{{ 'lang.storefront.macros.product.badge.out_of_stock'|t }}</span>
                    {% elseif product.status_alias == 'soon' %}
                        <span class="badge soon">{{ 'lang.storefront.macros.product.badge.soon'|t }}</span>
                    {% elseif product.promo == true %}
                        <span class="badge promo">{{ 'lang.storefront.macros.product.badge.promo'|t }}</span>
                        {% if product.price_promo_percentage == true %}
                            <span class="badge product-promo-percent promo-percentage">-<span>{{ product.price_promo_percentage }}</span>%</span>
                        {% endif %}
                    {% elseif product.new == true %}
                        <span class="badge new">{{ 'lang.storefront.macros.product.badge.new'|t }}</span>
                    {% endif %}
                </span>
                <img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image[card_thumbnail_type] }}" class="img-responsive lazy primary-img" alt="{{ product_title }}" title="{{ product_title }}" width="400" height="400">
                {% if show_product_second_image %}
                    <span class="secondary-img">
                        <img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ second_image }}" alt="{{ product_title }}" title="{{ product_title }}" class="lazy">
                    </span>
                {% endif %}
            </a>

            <div class="product-info">
                <a class="product-details" href="{{ product_url }}">
                    <div>
                        <h2>{{ product_title }}</h2>

                        <span class="price">
                            {% if product.price_range %}
                                {{ product.price_min|money_with_sign }} — {{ product.price_max|money_with_sign }}
                            {% elseif product.price_on_request == true %}
                                {{ 'lang.storefront.macros.product.price_on_request'|t }}
                            {% else %}
                                {% if product.promo == true %}
                                    {{ product.price_promo | money_with_sign }} <del>{{ product.price | money_with_sign }}</del>
                                {% else %}
                                    {{ product.price | money_with_sign }}
                                {% endif %}
                            {% endif %}
                        </span>
                    </div>
                </a>
            </div>
        </div>

    </article>

{% endmacro %}

{% macro category_list(category, show_number_products = true) %}
    {% import _self as generic_macros %}

    {% set category_title = category.title|e_attr %}
    {% set category_url = category.url %}
    {% set card_hover_effect = store.theme_options.card_hover_effect != 'none' ? store.theme_options.card_hover_effect : '' %}
    {% set card_thumbnail_type = store.theme_options.catalog_thumbail_type == 'square' ? 'square' : 'thumb' %}

    <article class="category category-id-{{ category.id }} {{ card_hover_effect }}">

        <div class="{{ store.theme_options.card_shadow }}">
            <a href="{{ category_url }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ category.image[card_thumbnail_type] }}" class="img-responsive lazy" alt="{{ category_title }}" title="{{ category_title }}" width="400" height="400"></a>

            <div class="category-info">
                <a class="category-details" href="{{ category_url }}">
                    <div>
                        <h2>{{ category_title }}</h2>
                        {% if not category.parent == 0 and category.children and show_number_products %}
                            <p>{{ category.children|length }} {{ 'lang.storefront.layout.categories.title'|t }}</p>
                        {% elseif show_number_products %}
                            <p class="total-products">{{ category.total_products }} {{ 'lang.storefront.macros.products.title'|t }}</p>
                        {% endif %}
                    </div>
                </a>
            </div>
        </div>

    </article>
{% endmacro %}

{% macro order_by(get, order_options, url) %}
    <div class="order-options">
        <small>{{ 'lang.storefront.layout.order_options.label'|t }}</small> &nbsp;
        <div class="btn-group">

            <button type="button" class="btn btn-default {{ store.theme_options.button_default_shadow }} btn-sm dropdown-toggle" data-toggle="dropdown">
                {% if get.order_by and order_options[get.order_by] %}
                    {{ order_options[get.order_by] }}
                {% else %}
                    {{ order_options['position'] }}
                {% endif %}
                <span class="caret"></span>
            </button>

            <ul class="dropdown-menu well-featured {{ store.theme_options.well_featured_shadow }}" role="menu">
                {% for order_option, order_title in order_options %}
                    {% if order_option != get.order_by and (order_option != 'rating' or (order_option == 'rating' and apps.product_reviews)) %}
                        <li><a href="{{ url ~ 'order_by=' ~ order_option }}">{{ order_title }}</a></li>
                    {% endif %}
                {% endfor %}
            </ul>
        </div>
    </div>
{% endmacro %}

{% macro google_translate(apps_google_translate) %}
    {% set default_lang = apps_google_translate.default_language %}

	<div class="languages-dropdown btn-group pull-right hidden">
		<button type="button" class="btn btn-sm btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			<span class="current-language"><span class="flag-icon"></span></span> &nbsp;
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
    {% if (store.gallery or store.theme_options.mobile_gallery) and (current_page in store.theme_options.gallery_location or 'all' in store.theme_options.gallery_location) %}
        <section class="slideshow {{ current_page != 'home' ? 'margin-bottom' : '' }} {{ store.theme_options.slideshow_full_height }} {{ store.theme_options.slideshow_mobile_full_height }}">
            <div class="loader">{{ icons('sync', 'fa-spin') }}</div>
            <div class="flexslider">
                <ul class="slides"></ul>
            </div>
        </section>
    {% endif %}
{% endmacro %}

{% macro cart_notice() %}
    {% if store.theme_options.cart_notice and current_page in store.theme_options.cart_notice_location %}
        <div class="callout callout-info {{ store.theme_options.well_info_shadow }}">
            {{ store.theme_options.cart_notice }}
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

{% macro reviews_block(reviews) %}
    {% set layout_container = store.theme_options.layout_container == 'fluid' ? 'container-fluid' : 'container' %}
    {% if current_page in apps.product_reviews.product_reviews_block or 'all' in apps.product_reviews.product_reviews_block %}
        <section class="reviews-block block margin-bottom">
            <div class="{{ layout_container }}">
                <h3 class="text-center margin-bottom-xxs">{{ 'lang.storefront.about.reviews.title'|t }}</h3>

                <div class="row">
                    <div class="testimonial-carousel">
                        {% for review in reviews.reviews %}
                            <div class="col">
                                <a class="testimonial" href="{{ site_url('product') ~ '/' ~ review.product_handle }}">
                                    <div class="well well-default {{ store.theme_options.well_default_shadow }} margin-bottom-0">
                                        <h5 class="name">{{ review.name }}</h5>
                                        <div class="flex margin-bottom-xs">
                                            <span class="review-rating review-rating-stars" data-initial-rating="{{ review.rating }}" data-active-color="orange" data-star-size="15"></span>
                                            <small class="review-date margin-left-xxs">• {{ review.created_at|date("d/m/Y") }}</small>
                                        </div>
                                        <span class="text-muted small">{{ review.product_title }}</span>
                                        <p class="small">{{ review.body }}</p>
                                    </div>
                                </a>
                            </div>
                        {% endfor %}
                    </div>
                </div>
            </div>
        </section>
    {% endif %}
{% endmacro %}