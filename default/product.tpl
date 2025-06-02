{#
Description: Product Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set product_is_vendible = product.status == 1 or (product.status == 3 and product.stock.stock_backorder) %}
	{% set product_title = product.title|e_attr %}

	<article>

		<ul class="breadcrumb well-default">
			<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
			<li class="active">{{ product.title }}</li>
		</ul>

		<div class="row">

			<div class="span4">

				<a href="{{ product.image.full }}" class="box-medium well-default {{ store.theme_options.well_default_shadow }} fancy" rel="{{ product.id }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image.full }}" alt="{{ product.title|e_attr }}" class="product-image lazy"></a>

				{% if product.images %}

					<div class="row thumbs hidden-phone">
						<div class="span1"><a href="{{ product.image.full }}" class="fancy well-default {{ store.theme_options.well_default_shadow }}" rel="{{ product.id }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image.square }}" alt="{{ product.title|e_attr }}" class="lazy"></a></div>
						{% for thumb in product.images %}
							<div class="span1"><a href="{{ thumb.full }}" class="fancy well-default {{ store.theme_options.well_default_shadow }}" rel="{{ product.id }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ thumb.square }}" alt="{{ product.title|e_attr }}" class="lazy"></a></div>
						{% endfor %}
					</div>

				{% endif %}

			</div>

			<div class="span5">

				<h1 class="product-title">{{ product.title }}</h1>

				<div>
					<h4 class="price margin-bottom-0">

						{% if product.price_on_request == true %}
							<span class="data-product-price margin-right-sm">{{ 'lang.storefront.macros.product.price_on_request'|t }}</span>
							<del></del>
						{% else %}
							{% if product.promo == true %}
								<span class="data-product-price margin-right-sm">{{ product.price_promo | money_with_sign }}</span>
								<del class="margin-right-sm">{{ product.price | money_with_sign }}</del>
							{% else %}
								<span class="data-product-price margin-right-sm">{{ product.price | money_with_sign }}</span>
								<del></del>
							{% endif %}
						{% endif %}

					</h4>

					{% if user.wholesale is same as(true) and product.wholesale == true and store.settings.wholesale.show_regular_price %}
						<div class="small muted">
							{{ 'lang.storefront.product.wholesale.regular_price'|t }} <span class="data-price-non-wholesale">{{ product.price_non_wholesale | money_with_sign }}</span>
						</div>
					{% endif %}

					{% if product.wholesale != true or (product.wholesale == true and not user.wholesale) %}
						<div class="small muted promo-percentage {% if product.price_promo_percentage == false %}hidden{% endif %}">
							{{ 'lang.storefront.product.discount_info'|t([ product.price_promo_percentage == true ? product.price_promo_percentage]) }}
						</div>
					{% endif %}

					{% if product.tax > 0 %}
						{% if store.taxes_included == false %}
							<div class="small muted">{{ 'lang.storefront.product.tax.percentage_info'|t([user.l10n.tax_name, product.tax]) }}</div>
						{% else %}
							<div class="small muted">{{ 'lang.storefront.product.tax_included_info'|t([user.l10n.tax_name]) }}</div>
						{% endif %}
					{% endif %}
				</div>

				<br>

				{{ form_open_cart(product.id, { 'class' : 'well well-featured form-inline form-cart add-cart ' ~ store.theme_options.well_featured_shadow }) }}

					<h4>{{ 'lang.storefront.layout.button.add_to_cart'|t }}</h4>

					{% set product_reference = product.reference and store.theme_options.show_product_sku == 'show' %}
					{% set product_barcode = product.barcode and store.theme_options.show_product_barcode == 'show' %}
					{% if product_reference or product_barcode %}
						<h6>
							<small>
								{% if product_reference %}
									<span class="product-sku">{{ 'lang.storefront.product.sku.label'|t }} <span class="sku">{{ product.reference }}</span></span> {{ product_barcode  ? ' | ' }}
								{% endif %}
								{% if product_barcode %}
									<span class="product-ean">{{ 'lang.storefront.product.ean.label'|t }} <span class="ean">{{ product.barcode }}</span></span>
								{% endif %}
							</small>
						</h6>
					{% endif %}

					<br>

					{% if product.status == 1 or (product.status == 3 and product.stock.stock_backorder) %}

						{% if product.option_groups %}
							{% for option_groups in product.option_groups %}

								<h6>{{ option_groups.title }}</h6>

								<select class="span3 select-product-options" name="option[]">
									{% for option in option_groups.options %}

										<option value="{{ option.id }}" data-title="{{ option.title }}">
											{{ option.title }}
										</option>

									{% endfor %}
								</select>

							{% endfor %}

							<hr>

						{% endif %}

						{% if product.extra_options %}
                            <div class="extra-options margin-bottom {{ product.option_groups or not product_is_vendible  ? 'hidden' : '' }}">
                                {% for extra_option in product.extra_options %}
                                    {% set field_disabled = extra_option.required ? '' : 'disabled' %}
                                    {% set field_required = extra_option.required ? 'required' : '' %}
                                    {% set field_checked = extra_option.required ? 'checked' : '' %}
                                    {% set field_hidden = extra_option.required ? '' : 'hidden' %}
                                    {% set field_size = extra_option.size ? 'maxlength="'~ extra_option.size ~'"' : 'maxlength="255"' %}
                                    {% set field_tip = extra_option.description ? '<span data-toggle="tooltip" data-placement="top" title="'~ extra_option.description ~'">'~ icons('question-circle') ~'</span>' : ''  %}
                                    {% set field_description = extra_option.description ? extra_option.description : 'lang.storefront.product.extra_options.type_value'|t %}

                                    <div class="extra-option margin-top-sm well well-default {{ store.theme_options.well_default_shadow }} well-sm" data-id="{{ extra_option.alias }}">
                                        {% if extra_option.type == 'input' %}
                                            <div class="checkbox">
                                                <label class="margin-bottom-0">
                                                    <input type="checkbox" data-target="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" {{ field_required }} {{ field_checked }}>
                                                    {{ extra_option.title }}{{ extra_option.price ? ' - ' ~ extra_option.price_formatted : '' }}
                                                </label> {{ field_tip }}
                                            </div>
                                            <input type="text" class="margin-top-xs form-control {{ field_hidden }}" name="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" id="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" placeholder="{{ field_description }}" {{ field_required }} {{ field_disabled }} {{ field_size }}>

                                        {% elseif extra_option.type == 'textarea' %}
                                            <div class="checkbox">
                                                <label class="margin-bottom-0">
                                                    <input type="checkbox" data-target="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" {{ field_required }} {{ field_checked }}>
                                                    {{ extra_option.title }}{{ extra_option.price ? ' - ' ~ extra_option.price_formatted : '' }}
                                                </label> {{ field_tip }}
                                            </div>
                                            <textarea class="form-control {{ field_hidden }} margin-top-xs" name="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" id="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" placeholder="{{ field_description }}" {{ field_required }} {{ field_disabled }} {{ field_size }}></textarea>

                                        {% elseif extra_option.type == 'select' %}
                                            <div class="checkbox">
                                                <label class="margin-bottom-0">
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
                                                <label class="margin-bottom-0">
                                                    <input type="checkbox" name="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" id="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" value="1" {{ field_required }}>
                                                    {{ extra_option.title }}{{ extra_option.price ? ' - ' ~ extra_option.price_formatted : '' }}
                                                </label> {{ field_tip }}
                                            </div>

                                        {% elseif extra_option.type == 'date' %}
                                            <div class="checkbox">
                                                <label class="margin-bottom-0">
                                                    <input type="checkbox" data-target="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" {{ field_required }} {{ field_checked }}>
                                                    {{ extra_option.title }}{{ extra_option.price ? ' - ' ~ extra_option.price_formatted : '' }}
                                                </label> {{ field_tip }}
                                            </div>
                                            <input type="text" data-datepicker class="form-control {{ field_hidden }} margin-top-xs" name="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" id="{{ 'extra_options[' ~ extra_option.alias ~ ']' }}" placeholder="{{ field_description }}" {{ field_required }} {{ field_disabled }} {{ field_size }}>

                                        {% elseif extra_option.type == 'color' %}
                                            <div class="checkbox">
                                                <label class="margin-bottom-0">
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

						<div class="data-product-info">
							{{ 'lang.storefront.layout.product.quantity'|t }} &nbsp;
							<input type="number" class="span1" name="qtd" value="1" min="1" {% if product.stock.stock_sold_single %} data-toggle="tooltip" data-placement="bottom" title="{{ 'lang.storefront.cart.product_limit.tooltip'|t }}" readonly {% endif %}>
							<button class="btn btn-primary {{ store.theme_options.button_primary_shadow }}" type="submit">
								{{ icons('shopping-cart', 'fa-lg') }} {{ 'lang.storefront.layout.button.buy'|t }}
							</button>

							{% if product.stock.stock_show %}
								<hr>
								<h6>{{ 'lang.storefront.filters.stock.label'|t }}</h6>
								<em class="muted"><span class="product-stock-qty">{{ 'lang.storefront.account.wishlist.stock_units'|t([product.stock.stock_qty]) }}</span></em>
							{% endif %}
						</div>

						<div class="data-product-on-request">
							<a class="btn btn-primary {{ store.theme_options.button_primary_shadow }} price-on-request" href="{{ site_url("contact?p=") ~ 'lang.storefront.product.label'|t([product_title])|url_encode }}">
								{{ icons('envelope', 'fa-lg') }} {{ 'lang.storefront.product.contact.button'|t }}
							</a>
						</div>

					{% elseif product.status == 3 %}
						<div class="alert alert-info {{ store.theme_options.well_info_shadow }}">{{ 'lang.storefront.product.status.out_of_stock'|t }}</div>

					{% elseif product.status == 4 %}
						<div class="alert alert-info {{ store.theme_options.well_info_shadow }}">{{ 'lang.storefront.product.status.soon'|t }}</div>

					{% endif %}

					{% if user.is_logged_in %}
						<div class="wishlist margin-top-sm">
							{% if not product.wishlist.status %}
								<a href="{{ product.wishlist.add_url }}" class="text-muted">{{ icons('heart') }} {{ 'lang.storefront.product.wishlist.add'|t }}</a>
							{% else %}
								<a href="{{ product.wishlist.remove_url }}" class="text-muted added">{{ icons('heart') }} {{ 'lang.storefront.product.wishlist.remove'|t }}</a>
							{% endif %}
						</div>
					{% endif %}

				{{ form_close() }}

				<div id="payment-method-messaging-element"></div>

			</div>

			<div class="span9">
				{% if product.description or product.tabs or product.video_embed_url or apps.facebook_comments.comments_products %}
					<div class="product-tabs tabbable margin-top"> <!-- Only required for left/right tabs -->
						<ul class="nav nav-tabs">
							{% if product.description %}
								<li class="active">
									<a href="#tab-description" data-toggle="tab">{{ 'lang.storefront.product.description.label'|t }}</a>
								</li>
							{% endif %}
							{% if product.tabs %}
								{% for tab in product.tabs %}
									<li>
										<a href="#tab-{{ tab.slug }}" data-toggle="tab">{{ tab.title }}</a>
									</li>
								{% endfor %}
							{% endif %}
							{% if product.video_embed_url %}
								<li>
									<a href="#tab-video" data-toggle="tab">{{ 'lang.storefront.product.video.label'|t }}</a>
								</li>
							{% endif %}
							{% if apps.facebook_comments.comments_products %}
								<li>
									<a href="#tab-comments" data-toggle="tab">{{ 'lang.storefront.product.comments.label'|t }}</a>
								</li>
							{% endif %}
						</ul>

						<div class="tab-content">
							{% if product.description %}
								<div class="tab-pane active" id="tab-description">
									{{ product.description }}


								</div>
							{% endif %}
							{% if product.tabs %}
								{% for tab in product.tabs %}
									<div class="tab-pane" id="tab-{{ tab.slug }}">
										{{ tab.content }}
									</div>
								{% endfor %}
							{% endif %}
							{% if product.video_embed_url %}
								<div class="tab-pane" id="tab-video">
									<div class="row">
										<div class="span9 video-wrapper">
											<div class="video-iframe" data-src="{{ product.video_embed_url }}">Video</div>
										</div>
									</div>
								</div>
							{% endif %}
							{% if apps.facebook_comments.comments_products %}
								<div class="tab-pane" id="tab-comments">
									<div class="fb-comments" data-href="{{ product.permalink }}" data-num-posts="5" data-colorscheme="light" data-width="100%"></div>
								</div>
							{% endif %}

						</div>
					</div>
				{% endif %}

				<hr>

				{% if product.custom_fields or product.brand or product.tags %}
					<div class="table-product-attributes margin-top">
						<div class="table-responsive">
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
											<ul class="inline unstyled">
												{% for tag in product.tags %}<li><a href="{{ tag.url }}" class="product-tag label label-outline">{{ tag.title }}</a></li>{% endfor %}
											</u>
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

				<div class="well well-default {{ store.theme_options.well_default_shadow }} well-small margin-top">
					{% if product.file %}
						<div class="file inline-block">
							<h6 style="margin-top:0">{{ 'lang.storefront.product.download_file.label'|t }}</h6>
							<a class="btn file-download" href="{{ product.file }}" target="_blank">{{ icons('download') }} <strong>{{ 'lang.storefront.product.download_file.button'|t }}</strong></a>
						</div>
					{% endif %}

					<div class="share {{ product.file ? 'pull-right' }}">
						<h6 style="margin-top:0">{{ 'lang.storefront.product.share.label'|t }}</h6>
						<a target="_blank" href="http://www.facebook.com/sharer.php?u={{ product.url }}" class="text-muted">{{ icons('facebook-f', 'fa-lg') }}</a> &nbsp;
						<a target="_blank" href="https://wa.me/?text={{ "#{product.title}: #{product.url}"|url_encode }}" class="text-muted">{{ icons('whatsapp', 'fa-lg') }}</a> &nbsp;
						<a target="_blank" href="https://twitter.com/share?url={{ product.url }}&text={{ character_limiter(description, 100)|url_encode }}" class="text-muted">{{ icons('twitter', 'fa-lg') }}</a> &nbsp;
						<a target="_blank" href="https://pinterest.com/pin/create/bookmarklet/?media={{ product.image.full }}&url={{ product.url }}&description={{ product.title|url_encode }}" class="text-muted">{{ icons('pinterest', 'fa-lg') }}</a>
					</div>
				</div>

				<div class="related-products margin-top hidden" data-load="related-products" data-products="{{ product.id }}" data-num-products="3" data-products-per-row="3" data-css-class-wrapper="product-related-products">
					<div class="text-center">
						<h3 class="products-title margin-bottom">{{ product.related_products.title }}</h3>
						<div class="related-products-placement"></div>
					</div>
				</div>
			</div>

		</div>

	</article>

{% endblock %}
