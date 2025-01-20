{# Macros #}
{% macro product_list(product) %}
	{% import _self as generic_macros %}

	{% set product_title = product.title|e_attr %}
	{% set product_url = product.url %}

	<li class="product-id-{{ product.id }} {{ product.status_alias }}" data-id="{{ product.id }}">
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

		<img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image.square }}" alt="{{ product_title }}" title="{{ product_title }}" class="lazy">

		<div class="description">
			<h3><a href="{{ product_url }}">{{ product.title }}</a></h3>

			<span class="price">

			{% if product.price_range %}
                {{ product.price_min|money_with_sign }} — {{ product.price_max|money_with_sign }}
			{% elseif product.price_on_request == true %}
				{{ 'lang.storefront.macros.product.price_on_request'|t }}
			{% else %}
				{% if product.promo == true %}
					{{ product.price_promo | money_with_sign }} &nbsp; <del>{{ product.price | money_with_sign }}</del>
				{% else %}
					{{ product.price | money_with_sign }}
				{% endif %}
			{% endif %}

			</span>

			<div>
				{% if product.status == 1 and product.price_on_request == false and not product.option_groups %}
					<a href="{{ product_url }}" class="button btn-primary {{ store.theme_options.button_primary_shadow }}"><i class="fa fa-shopping-cart"></i><span>{{ 'lang.storefront.layout.button.buy'|t }}</span></a>
				{% elseif product.option_groups %}
					<a href="{{ product_url }}" class="button btn-primary {{ store.theme_options.button_primary_shadow }}"><i class="fa fa-plus-square"></i><span>{{ 'lang.storefront.macros.product.options'|t }}</span></a>
				{% else %}
					<a href="{{ product_url }}" class="button btn-primary {{ store.theme_options.button_primary_shadow }}"><i class="fa fa-plus-square"></i><span>{{ 'lang.storefront.macros.product.info'|t }}</span></a>
				{% endif %}
			</div>

			<p class="category">{{ product.categories[0].title }}</p>

		</div>

	</li>
{% endmacro %}

{% macro category_list(category, show_number_products = true) %}
	{% import _self as generic_macros %}

	{% set category_title = category.title|e_attr %}
	{% set category_url = category.url %}

	<li class="category-id-{{ category.id }}">
		<img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ category.image.square }}" alt="{{ category_title }}" title="{{ category_title }}" class="lazy">
		<div class="description">
			<h3><a href="{{ category_url }}">{{ category_title }}</a></h3>
			{% if not category.parent == 0 and category.children and show_number_products %}
				<p>{{ category.children|length }} {{ 'lang.storefront.layout.categories.title'|t }}</p>
			{% elseif show_number_products %}
				<p class="total-products">{{ category.total_products }} {{ 'lang.storefront.macros.products.title'|t }}</p>
			{% endif %}
			<a href="{{ category_url }}" class="button btn-primary {{ store.theme_options.button_primary_shadow }}"><span>{{ 'lang.storefront.macros.button.explore'|t }}</span></a>
		</div>
	</li>
{% endmacro %}

{% macro order_by(get, order_options, url) %}
	<div class="order-options">
		{{ 'lang.storefront.layout.order_options.label'|t }} &nbsp;

		<div class="btn-group">

			<button type="button" class="btn btn-default {{ store.theme_options.button_default_shadow }} btn-sm dropdown-toggle" data-toggle="dropdown">
				{% if get.order_by and order_options[get.order_by] %}
					{{ order_options[get.order_by] }}
				{% else %}
					{{ order_options['position'] }}
				{% endif %}
				<span class="caret"></span>
			</button>

			<ul class="dropdown-menu pull-right" role="menu">
				{% for order_option, order_title in order_options %}
					{% if order_option != get.order_by and (order_option != 'rating' or (order_option == 'rating' and apps.product_reviews|length)) %}
						<li><a href="{{ url ~ 'order_by=' ~ order_option }}">{{ order_title }}</a></li>
					{% endif %}
				{% endfor %}
			</ul>
		</div>
	</div>
{% endmacro %}

{% macro google_translate(apps_google_translate) %}
	{% set default_lang = apps_google_translate.default_language %}

	<li>
		<div class="languages-dropdown btn-group hidden">
			<button type="button" class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				<span class="current-language"><span class="flag-icon"></span></span>
			</button>
			<ul class="dropdown-menu">
				<li class="googtrans-{{ default_lang }}"><a href="{{ current_url() }}" lang="{{ default_lang }}"><span class="flag-icon flag-icon-{{ apps_google_translate.flags[default_lang] }}"></span></a></li>
				{% for lang in apps_google_translate.languages|split(',') %}
					{% if lang != default_lang %}
						<li class="googtrans-{{ lang }}"><a href="#googtrans({{ lang }})" lang="{{ lang }}"><span class="flag-icon flag-icon-{{ apps_google_translate.flags[lang] }}"></span></a></li>
					{% endif %}
				{% endfor %}
			</ul>
		</div>
	</li>
{% endmacro %}

{% macro cart_notice() %}
    {% if store.theme_options.cart_notice and current_page in store.theme_options.cart_notice_location %}
        <div class="alert alert-info {{ store.theme_options.well_info_shadow }}">
            {{ store.theme_options.cart_notice }}
        </div>
    {% endif %}
{% endmacro %}

{% macro popup_interactions(popup) %}
    {% if popup.interaction == 'newsletter' and apps.newsletter %}
        <div class="popup-newsletter newsletter form-inline text-center">
            <input type="email" id="email_newsletter" name="email_newsletter" class="form-control input-large" placeholder="{{ popup.interaction_newsletter_input_placeholder|e('html_attr') }}" required style="background-color:{{ popup.background_color }};color:{{ popup.text_color }};border-color:{{ popup.text_color }}">
            <button type="button" class="btn btn-no-shadow btn-large submit-newsletter" data-dismiss="modal" data-unique_id="{{ popup.unique_id }}" style="background-color:{{ popup.text_color }};color:{{ popup.background_color }};border-color:{{ popup.text_color }}">{{ popup.interaction_newsletter_button_text }}</button>
        </div>
    {% endif %}
    {% if popup.interaction == 'button' %}
        <div class="popup-button text-center">
            <a href="{{ popup.interaction_button_button_link }}" class="btn btn-large" data-unique_id="{{ popup.unique_id }}" {{ popup.interaction_button_button_target_blank ? 'target="_blank"' }} style="background-color:{{ popup.text_color }};color:{{ popup.background_color }};">{{ popup.interaction_button_button_text }}</a>
        </div>
    {% endif %}
{% endmacro %}

{% macro reviews_block(reviews) %}
    {% if current_page in apps.product_reviews.product_reviews_block or 'all' in apps.product_reviews.product_reviews_block %}
        <div class="reviews-block block">
            <div class="wide text-center">
				<h1 class="wide">{{ 'lang.storefront.about.reviews.title'|t }}</h1>
			</div>

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
    {% endif %}
{% endmacro %}