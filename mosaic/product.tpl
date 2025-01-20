{#
Description: Product Page
#}

{% macro wishlist_block(product, user) %}
	{% if user.is_logged_in %}
		<div class="wishlist">
			{% if not product.wishlist.status %}
				<a href="{{ product.wishlist.add_url }}"><i class="fa fa-heart fa-fw fa-lg"></i></a>
			{% else %}
				<a href="{{ product.wishlist.remove_url }}"><i class="fa fa-heart-o fa-fw fa-lg"></i></a>
			{% endif %}
		</div>
	{% endif %}
{% endmacro %}

{% import _self as product_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set product_is_vendible = product.status == 1 or (product.status == 3 and product.stock.stock_backorder) %}

	<div class="bg-img" style="background-image: url({{ product.image.full }});"></div>
	<div class="bg-mask"></div>

	<div class="content">

		<article class="product">

			<div class="row-fluid">

				<div class="span8">
					<h1 class="product-title">{{ product.title }}</h1>
				</div>

				<div class="span4">

					<div>
						<div class="price">
							{% if product.price_on_request == true %}
								<span class="data-product-price">{{ 'lang.storefront.macros.product.price_on_request'|t }}</span>
								<del></del>
							{% else %}
								{% if product.promo == true %}
									<span class="data-product-price">{{ product.price_promo | money_with_sign }}</span>
									<del>{{ product.price | money_with_sign }}</del>
								{% else %}
									<span class="data-product-price">{{ product.price | money_with_sign }}</span>
									<del></del>
								{% endif %}
							{% endif %}
						</div>

						{% if user.wholesale is same as(true) and product.wholesale == true and store.settings.wholesale.show_regular_price %}
							<p class="text-right"><small class="muted light">{{ 'lang.storefront.product.wholesale.regular_price'|t }} <span class="data-price-non-wholesale">{{ product.price_non_wholesale | money_with_sign }}</span></small></p>
						{% endif %}

						{% if product.wholesale != true or (product.wholesale == true and not user.wholesale) %}
							<p class="text-right"><small class="muted light promo-percentage {% if product.price_promo_percentage == false %}hidden{% endif %}">
								{{ 'lang.storefront.product.discount_info'|t([ product.price_promo_percentage == true ? product.price_promo_percentage]) }}
							</small></p>
						{% endif %}
					</div>

				</div>

			</div>

			<hr>

			<div class="row-fluid">

				<div class="span8">
					<p class="breadcrumbs">
						<a href="{{ site_url() }}"><i class="fa fa-home"></i></a> ›
						{{ product.title }}
					</p>
				</div>

				<div class="span4">
					{% set product_reference = product.reference and store.theme_options.show_product_sku == 'show' %}
					{% set product_barcode = product.barcode and store.theme_options.show_product_barcode == 'show' %}
					{% if product_reference or product_barcode %}
						<p class="text-right">
							<small class="muted light">
								{% if product_reference %}
									<span class="product-sku"><strong>{{ 'lang.storefront.product.sku.label'|t }}</strong> <span class="sku">{{ product.reference }}</span></span> {{ product_barcode  ? ' | ' }}
								{% endif %}
								{% if product_barcode %}
									<span class="product-ean"><strong>{{ 'lang.storefront.product.ean.label'|t }}</strong> <span class="ean">{{ product.barcode }}</span></span>
								{% endif %}
							</small>
						</p>
					{% endif %}
				</div>
			</div>

			{{ form_open_cart(product.id, { 'class' : 'add-cart clearfix' }) }}

				{% if product.status == 1 %}

					<div class="form-inline">

						<div class="data-product-info">
							<input type="number" class="span1" name="qtd" value="1" min="1" {% if product.stock.stock_sold_single %} data-toggle="tooltip" data-placement="bottom" title="{{ 'lang.storefront.cart.product_limit.tooltip'|t }}" readonly {% endif %}>

							&nbsp; &nbsp;
						</div>

						{% if product.options %}
							<select class="span2 select-product-options" name="option">
								{% for option in product.options %}

									{% if option.active %}
										{% set option_display_price = option.promo ? option.price_promo : option.price %}

										<option value="{{ option.id }}" data-title="{{ option.title }}" data-id_variant_1="{{ option.id_variant_1 }}" data-id_variant_2="{{ option.id_variant_2 }}" data-id_variant_3="{{ option.id_variant_3 }}" {% if product.stock.stock_enabled and not product.stock.stock_backorder and option.stock <= 0 and not option.price_on_request %}disabled{% endif %}>
											{{ option.title }} &ndash; {{ option.price_on_request == true ? 'lang.storefront.macros.product.price_on_request'|t : option_display_price | money_with_sign }}
										</option>
									{% endif %}

								{% endfor %}
							</select>
						{% endif %}

						{% if product.extra_options %}
                            <div class="extra-options margin-bottom {{ product.option_groups or not product_is_vendible  ? 'hidden' : '' }}">
                                {% for extra_option in product.extra_options %}
                                    {% set field_disabled = extra_option.required ? '' : 'disabled' %}
                                    {% set field_required = extra_option.required ? 'required' : '' %}
                                    {% set field_checked = extra_option.required ? 'checked' : '' %}
                                    {% set field_hidden = extra_option.required ? '' : 'hidden' %}
                                    {% set field_size = extra_option.size ? 'maxlength="'~ extra_option.size ~'"' : 'maxlength="255"' %}
                                    {% set field_tip = extra_option.description ? '<span data-toggle="tooltip" data-placement="top" title="'~ extra_option.description ~'"><i class="fa fa-question-circle"></i></span>' : ''  %}
                                    {% set field_description = extra_option.description ? extra_option.description : 'lang.storefront.product.extra_options.type_value'|t %}

                                    <div class="extra-option margin-top-sm well well-default {{ store.theme_options.well_default_shadow }} well-sm" data-id="{{ extra_option.alias }}">
                                        {% if extra_option.type == 'input' %}
                                            <div class="checkbox margin-0">
                                                <label>
                                                    <input type="checkbox" data-target="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" {{ field_required }} {{ field_checked }}>
                                                    {{ extra_option.title }}{{ extra_option.price ? ' - ' ~ extra_option.price_formatted : '' }}
                                                </label> {{ field_tip }}
                                            </div>
                                            <input type="text" class="margin-top-xs form-control {{ field_hidden }}" name="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" id="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" placeholder="{{ field_description }}" {{ field_required }} {{ field_disabled }} {{ field_size }}>

                                        {% elseif extra_option.type == 'textarea' %}
                                            <div class="checkbox margin-0">
                                                <label>
                                                    <input type="checkbox" data-target="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" {{ field_required }} {{ field_checked }}>
                                                    {{ extra_option.title }}{{ extra_option.price ? ' - ' ~ extra_option.price_formatted : '' }}
                                                </label> {{ field_tip }}
                                            </div>
                                            <textarea class="form-control {{ field_hidden }} margin-top-xs" name="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" id="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" placeholder="{{ field_description }}" {{ field_required }} {{ field_disabled }} {{ field_size }}></textarea>

                                        {% elseif extra_option.type == 'select' %}
                                            <div class="checkbox margin-0">
                                                <label>
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
                                            <div class="checkbox margin-0">
                                                <label>
                                                    <input type="checkbox" name="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" id="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" value="1" {{ field_required }}>
                                                    {{ extra_option.title }}{{ extra_option.price ? ' - ' ~ extra_option.price_formatted : '' }}
                                                </label> {{ field_tip }}
                                            </div>

                                        {% elseif extra_option.type == 'date' %}
                                            <div class="checkbox margin-0">
                                                <label>
                                                    <input type="checkbox" data-target="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" {{ field_required }} {{ field_checked }}>
                                                    {{ extra_option.title }}{{ extra_option.price ? ' - ' ~ extra_option.price_formatted : '' }}
                                                </label> {{ field_tip }}
                                            </div>
                                            <input type="text" data-datepicker class="form-control {{ field_hidden }} margin-top-xs" name="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" id="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" placeholder="{{ field_description }}" {{ field_required }} {{ field_disabled }} {{ field_size }}>

                                        {% elseif extra_option.type == 'color' %}
                                            <div class="checkbox margin-0">
                                                <label>
                                                    <input type="checkbox" data-target="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" {{ field_required }} {{ field_checked }}>
                                                    {{ extra_option.title }}{{ extra_option.price ? ' - ' ~ extra_option.price_formatted : '' }} <span class="extra-option-option-label hidden">- <span></span></span>
                                                </label> {{ field_tip }}
                                            </div>
                                            <div class="list-colors {{ field_hidden }}" name="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}">
                                                {% for option in extra_option.options %}
                                                    {% set option_background = option.type == 'color' ? 'background:'~ option.color ~';' : 'background:url('~ option.file.images.square ~') center / contain no-repeat;' %}
                                                    <label for="{{ extra_option.alias ~ '_' ~ loop.index0 }}" class="relative badge badge-md extra-option-badge margin-top-xs margin-right-xxs" data-toggle="tooltip" title="{{ option.title }}">
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

						{{ product_macros.wishlist_block(product, user) }}

						<div class="data-product-info">
							<button type="submit" class="btn btn-link pull-right">{{ 'lang.storefront.layout.button.add_to_cart'|t }}</button>
						</div>

						<div class="data-product-on-request">
							<a class="btn btn-link pull-right price-on-request" href="{{ site_url('contact') }}?p={{ product.title|url_encode }}">{{ 'lang.storefront.product.contact.button'|t }}</a>
						</div>

					</div>

				{% elseif product.status == 3 %}
					<div class="product-not-vendible">
						<h4>{{ 'lang.storefront.product.status.out_of_stock'|t }}</h4>

						{{ product_macros.wishlist_block(product, user) }}
					</div>
				{% elseif product.status == 4 %}
					<div class="product-not-vendible">
						<h4>{{ 'lang.storefront.product.status.soon'|t }}</h4>

						{{ product_macros.wishlist_block(product, user) }}
					</div>
				{% endif %}

			{{ form_close() }}

			<div id="payment-method-messaging-element"></div>

			<div class="row-fluid data-product-info">
				<div class="span6">
					{% if product.tax > 0 %}
						{% if store.taxes_included == false %}
							<p class=""><small class="muted light">{{ 'lang.storefront.product.tax.percentage_info'|t([user.l10n.tax_name, product.tax]) }}</small></p>
						{% else %}
							<p class=""><small class="muted light">{{ 'lang.storefront.product.tax_included_info'|t([user.l10n.tax_name]) }}</small></p>
						{% endif %}
					{% endif %}
				</div>

				<div class="span6">
					{% if product.stock.stock_show %}
						<p class="text-right"><small class="muted light"><strong>{{ 'lang.storefront.filters.stock.label'|t }}:</strong> <span class="product-stock-qty">{{ 'lang.storefront.account.wishlist.stock_units'|t([product.stock.stock_qty]) }}</span></small></p>
					{% endif %}
				</div>
			</div>

			<div class="flexslider">
				<ul class="slides">
					<li>
						<img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image.full }}" alt="{{ product.title|e_attr }}" class="lazy">
					</li>

					{% for image in product.images %}
						<li><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ image.full }}" alt="{{ product.title|e_attr }}" class="lazy"></li>
					{% endfor %}

				</ul>
			</div>

			<br>

			{% if product.tabs %}
				<div class="panel-group product-tabs margin-top" id="product-tabs" role="tablist" aria-multiselectable="true">
					{% if product.description %}
						<div class="panel panel-default">
							<div class="panel-heading" role="tab" id="tab_description">
								<h4 class="panel-title"><a role="button" data-toggle="collapse" data-parent="#product-tabs" href="#panel_description" aria-expanded="true" aria-controls="panel_description">{{ 'lang.storefront.product.description.label'|t }}</a></h4>
							</div>
							<div id="panel_description" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="tab_description">
								<div class="panel-body">{{ product.description }}</div>
							</div>
						</div>
					{% endif %}

					{% for tab in product.tabs %}
						<div class="panel panel-default">
							<div class="panel-heading" role="tab" id="tab_{{ tab.slug }}">
								<h4 class="panel-title"><a role="button" data-toggle="collapse" data-parent="#product-tabs" href="#panel_{{ tab.slug }}" aria-expanded="true" aria-controls="panel_{{ tab.slug }}">{{ tab.title }}</a></h4>
							</div>
							<div id="panel_{{ tab.slug }}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="tab_{{ tab.slug }}">
								<div class="panel-body">{{ tab.content }}</div>
							</div>
						</div>
					{% endfor %}
				</div>
			{% elseif product.description %}
				<hr>
				<div class="product-description break-word">
					{{ product.description }}
				</div>
			{% endif %}

			{% if product.custom_fields or product.brand or product.tags %}
				<div class="table-product-attributes margin-bottom margin-top">
					<div class="table-responsive">
						<table class="table">
							{% if product.brand %}
								<tr class="product-brand">
									<th>{{ 'lang.storefront.product.brand.label'|t }}</th>
									<td><a href="{{ product.brand.url }}" class="text-underline">{{ product.brand.title }}</a></td>
								</tr>
							{% endif %}

							{% if product.tags %}
								<tr class="product-tags">
									<th>{{ 'lang.storefront.product.tags.label'|t }}</th>
									<td>
										<ul class="inline unstyled">
											{% for tag in product.tags %}<li><a href="{{ tag.url }}" class="product-tag label label-outline">{{ tag.title }}</a></li>{% endfor %}
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
						</table>
					</div>
				</div>
			{% endif %}

			<div class="row-fluid">

				<div class="share">
					<a target="_blank" href="http://www.facebook.com/sharer.php?u={{ product.url }}" class="text-muted"><i class="fa fa-lg fa-facebook fa-fw"></i></a> &nbsp;
					<a target="_blank" href="https://wa.me/?text={{ "#{product.title}: #{product.url}"|url_encode }}" class="text-muted"><i class="fa fa-lg fa-whatsapp fa-fw"></i></a> &nbsp;
					<a target="_blank" href="https://twitter.com/share?url={{ product.url }}&text={{ character_limiter(description, 100)|url_encode }}" class="text-muted"><i class="fa fa-lg fa-twitter fa-fw"></i></a> &nbsp;
					<a target="_blank" href="https://pinterest.com/pin/create/bookmarklet/?media={{ product.image.full }}&url={{ product.url }}&description={{ product.title|url_encode }}" class="text-muted"><i class="fa fa-lg fa-pinterest fa-fw"></i></a>
				</div>

			</div>

			{% if product.file %}
				<hr>
				<a target="_blank" href="{{ product.file }}" class="colorless book"><i class="fa fa-download"></i> {{ 'lang.storefront.product.download_file.button'|t }}</a>
			{% endif %}

			{% if product.video_embed_url %}
				<div class="video-wrapper" data-service="{{ product.video_embed_url matches '/youtube/' ? 'youtube' : 'vimeo' }}" data-id="{{ product.video_embed_url|split('/')|last }}" data-ratio="16:9" data-autoscale>
					{% if not apps.cookies or (apps.cookies and not apps.cookies.consent_mode) %}
                        <iframe width="560" height="315" src="{{ product.video_embed_url }}" allow="autoplay; encrypted-media" allowfullscreen></iframe>
                    {% endif %}
				</div>
			{% endif %}

			{% if apps.facebook_comments.comments_products %}
				<hr>
				<div class="boxed hidden-phone">
					<div class="fb-comments" data-href="{{ product.permalink }}" data-num-posts="3" data-colorscheme="light" data-width="100%"></div>
				</div>
			{% endif %}

		</article>

	</div>

	<div class="related-products margin-top hidden" style="z-index:2;position:relative;" data-load="related-products" data-products="{{ product.id }}" data-num-products="6" data-products-per-row="3" data-css-class-wrapper="product-related-products unstyled">
		<div class="wide text-center">
			<h1 class="wide">{{ product.related_products.title }}</h1>
		</div>
		<div class="related-products-placement"></div>
	</div>

{% endblock %}
