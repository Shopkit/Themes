{#
Description: Product Page
#}

{% macro wishlist_block(product, user) %}
	{% if user.is_logged_in %}
		{% if not product.wishlist.status %}
			<p class="wishlist margin-top-sm margin-bottom-0"><a href="{{ product.wishlist.add_url }}" class="text-muted"><i class="fa fa-heart fa-fw"></i> {{ 'lang.storefront.product.wishlist.add'|t }}</a></p>
		{% else %}
			<p class="wishlist margin-top-sm margin-bottom-0"><a href="{{ product.wishlist.remove_url }}" class="text-muted"><i class="fa fa-heart-o fa-fw"></i> {{ 'lang.storefront.product.wishlist.remove'|t }}</a></p>
		{% endif %}
	{% endif %}
{% endmacro %}

{% import _self as product_macros %}
{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set product_is_vendible = product.status == 1 or (product.status == 3 and product.stock.stock_backorder) %}

	<div class="{{ layout_container }}">

		<article class="product-detail">

			<div class="big-image-holder">
				<img />
				<a class="btn-close" href="#"><i class="fa fa-times"></i></a>
			</div>

			<div class="row">
				<div class="col-md-7 col-lg-6">

					<div class="slideshow slideshow-product">

						<div class="loader"><i class="fa fa-circle-o-notch fa-spin"></i></div>

						<a href="#" class="btn-zoom"><i class="fa fa-search-plus"></i></a>

						<div class="flexslider">
							<ul class="slides">

								<li class="slide">
									<a href="{{ product.image.full }}" data-image="{{ product.image.full }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image.full }}" alt="{{ product.title|e_attr }}" title="{{ product.title|e_attr }}" width="600" class="lazy"></a>
								</li>

								{% if product.images %}
									{% for image in product.images %}
										<li class="slide">
											<a href="{{ image.full }}" data-image="{{ image.full }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ image.full }}" alt="{{ product.title|e_attr }}" title="{{ product.title|e_attr }}" width="600" class="lazy"></a>
										</li>
									{% endfor %}
								{% endif %}

							</ul>
						</div>
					</div>

					{% if apps.facebook_comments.comments_products %}
						<div class="facebook-comments">
							<div class="fb-comments" data-href="{{ product.permalink }}" data-numposts="5" data-width="100%"></div>
						</div>
					{% endif %}

				</div>

				<div class="col-md-5 col-md-offset-0 col-lg-5 col-lg-offset-1">

					{% if product.file %}
						<div class="row">
							<div class="col-xs-10">
								<h1 class="product-title">{{ product.title }}</h1>
							</div>
							<div class="col-xs-2 text-right">
								<a target="_blank" href="{{ product.file }}" class="text-muted file-download"><i class="fa fa-fw fa-download"></i></a>
							</div>
						</div>
					{% else %}
						<h1 class="product-title">{{ product.title }}</h1>
					{% endif %}

					<div class="row block-price">
						<div class="col-xs-6 col-md-7 col-lg-6">

							<div>

								{% if product.price_on_request == true %}
									<span class="data-product-price price">{{ 'lang.storefront.macros.product.price_on_request'|t }}</span> &nbsp;
									<del class="promo-price"></del>
								{% else %}
									{% if product.promo == true %}
										<span class="data-product-price price">{{ product.price_promo | money_with_sign }}</span> &nbsp;
										<del class="promo-price">{{ product.price | money_with_sign }}</del>
									{% else %}
										<span class="data-product-price price">{{ product.price | money_with_sign }}</span>  &nbsp;
										<del class="promo-price"></del>
									{% endif %}
								{% endif %}

								<div class="data-product-info">
									{% if user.wholesale is same as(true) and product.wholesale == true and store.settings.wholesale.show_regular_price %}
										<small class="text-muted block">{{ 'lang.storefront.product.wholesale.regular_price'|t }} <span class="data-price-non-wholesale">{{ product.price_non_wholesale | money_with_sign }}</span></small>
									{% endif %}

									{% if product.wholesale != true or (product.wholesale == true and not user.wholesale) %}
										<small class="text-muted block promo-percentage {% if product.price_promo_percentage == false %}hidden{% endif %}">
											{{ 'lang.storefront.product.discount_info'|t([ product.price_promo_percentage == true ? product.price_promo_percentage]) }}
										</small>
									{% endif %}

									{% if product.tax > 0 %}
										{% if store.taxes_included == false %}
											<small class="text-muted block"><em>{{ 'lang.storefront.product.tax.percentage_info'|t([user.l10n.tax_name, product.tax]) }}</em></small>
										{% else %}
											<small class="text-muted block"><em>{{ 'lang.storefront.product.tax_included_info'|t([user.l10n.tax_name]) }}</em></small>
										{% endif %}
									{% endif %}
								</div>
							</div>

						</div>

						<div class="col-xs-6 col-md-5 col-lg-6">
							<div class="text-center share pull-right">
								<h6 class="text-muted text-uppercase">{{ 'lang.storefront.product.share.label'|t }}</h6>
								<a target="_blank" href="http://www.facebook.com/sharer.php?u={{ product.url }}" class="text-muted"><i class="fa fa-facebook fa-fw"></i></a> &nbsp;
								<a target="_blank" href="https://wa.me/?text={{ "#{product.title}: #{product.url}"|url_encode }}" class="text-muted"><i class="fa fa-whatsapp fa-fw"></i></a> &nbsp;
								<a target="_blank" href="https://twitter.com/share?url={{ product.url }}&text={{ character_limiter(description, 100)|url_encode }}" class="text-muted"><i class="fa fa-twitter fa-fw"></i></a> &nbsp;
								<a target="_blank" href="https://pinterest.com/pin/create/bookmarklet/?media={{ product.image.full }}&url={{ product.url }}&description={{ product.title|url_encode }}" class="text-muted"><i class="fa fa-pinterest fa-fw"></i></a>
							</div>
						</div>
					</div>

					{% if product.status == 1 or (product.status == 3 and product.stock.stock_backorder) %}

						{{ form_open_cart(product.id, { 'class' : 'add-cart' }) }}

							{% if product.option_groups %}

								<div class="well well-default {{ store.theme_options.well_default_shadow }}">
									<div class="row">

										{% for option_groups in product.option_groups %}
											<div class="col-sm-{{ 12 / product.option_groups|length }}">

												<label for="{{ option_groups.title|slug }}">{{ option_groups.title }}</label>

												<select class="form-control select-product-options" name="option[]" id="{{ option_groups.title|slug }}">
													{% for option in option_groups.options %}
														<option value="{{ option.id }}" data-title="{{ option.title }}">
															{{ option.title }}
														</option>
													{% endfor %}
												</select>
											</div>
										{% endfor %}

									</div>
								</div>
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

										<div class="extra-option margin-bottom-0 margin-top-xs well well-default {{ store.theme_options.well_default_shadow }} well-sm" data-id="{{ extra_option.alias }}">
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

							<div class="data-product-info margin-bottom">
								<div class="row">
									<div class="col-sm-7 col-md-12 col-lg-7">
										<input type="number" class="form-control" value="1" min="1" name="qtd" {% if product.stock.stock_sold_single %} data-toggle="tooltip" data-placement="bottom" title="{{ 'lang.storefront.cart.product_limit.tooltip'|t }}" readonly {% endif %}>
										<button type="submit" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} text-uppercase"><i class="fa fa-cart-plus fa-fw"></i> {{ 'lang.storefront.layout.button.buy'|t }}</button>
									</div>
									<div class="col-sm-5 col-md-12 col-lg-5">
										{{ product_macros.wishlist_block(product, user) }}
									</div>
								</div>
							</div>

							<div class="data-product-on-request">
								<div class="row">
									<div class="col-sm-7 col-md-12 col-lg-7">
										<a href="{{ site_url("contact?p=") ~ 'lang.storefront.product.label'|t([product_title])|url_encode }}" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} text-uppercase price-on-request"><i class="fa fa-envelope fa-fw"></i> {{ 'lang.storefront.product.contact.button'|t }}</a>
									</div>
									<div class="col-sm-5 col-md-12 col-lg-5">
										{{ product_macros.wishlist_block(product, user) }}
									</div>
								</div>
							</div>

							{% set product_reference = product.reference and store.theme_options.show_product_sku == 'show' %}
							{% set product_barcode = product.barcode and store.theme_options.show_product_barcode == 'show' %}
							{% if product.stock.stock_show or product_reference or product_barcode %}
								<p class="text-muted small margin-top-xs margin-bottom-0">
									{% if product.stock.stock_show %}
										<span class="product-stock-qty">{{ 'lang.storefront.account.wishlist.stock_units'|t([product.stock.stock_qty]) }} {{ product_reference or product_barcode  ? ' | ' }}</span>
									{% endif %}
									{% if product_reference %}
										<span class="product-sku">{{ 'lang.storefront.product.sku.label'|t }} <span class="sku">{{ product.reference }}</span></span> {{ product_barcode  ? ' | ' }}
									{% endif %}
									{% if product_barcode %}
										<span class="product-ean">{{ 'lang.storefront.product.ean.label'|t }} <span class="ean">{{ product.barcode }}</span></span>
									{% endif %}
								</p>
							{% endif %}

						{{ form_close() }}

						<div id="payment-method-messaging-element"></div>

					{% elseif product.status == 3 %}
						<div class="well well-default {{ store.theme_options.well_default_shadow }}">
							{{ 'lang.storefront.product.status.out_of_stock'|t }}
						</div>
						{{ product_macros.wishlist_block(product, user) }}

					{% elseif product.status == 4 %}
						<div class="well well-default {{ store.theme_options.well_default_shadow }}">
							{{ 'lang.storefront.product.status.soon'|t }}
						</div>
						{{ product_macros.wishlist_block(product, user) }}

					{% endif %}

					{% if product.tabs %}
						<div class="panel-group product-tabs margin-top" id="product-tabs" role="tablist" aria-multiselectable="true">
							{% if product.description %}
								<div class="panel panel-default well-featured {{ store.theme_options.well_featured_shadow }}">
									<div class="panel-heading" role="tab" id="tab_description">
										<h4 class="panel-title"><a role="button" data-toggle="collapse" data-parent="#product-tabs" href="#panel_description" aria-expanded="true" aria-controls="panel_description">{{ 'lang.storefront.product.description.label'|t }}</a></h4>
									</div>
									<div id="panel_description" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="tab_description">
										<div class="panel-body">{{ product.description }}</div>
									</div>
								</div>
							{% endif %}

							{% for tab in product.tabs %}
								<div class="panel panel-default well-featured {{ store.theme_options.well_featured_shadow }}">
									<div class="panel-heading" role="tab" id="tab_{{ tab.slug }}">
										<h4 class="panel-title"><a role="button" data-toggle="collapse" data-parent="#product-tabs" href="#panel_{{ tab.slug }}" aria-expanded="true" aria-controls="panel_{{ tab.slug }}">{{ tab.title }}</a></h4>
									</div>
									<div id="panel_{{ tab.slug }}" class="panel-collapse collapse" role="tabpanel" aria-labelledby="tab_{{ tab.slug }}">
										<div class="panel-body">{{ tab.content }}</div>
									</div>
								</div>
							{% endfor %}
						</div>
					{% else %}
						<div class="description">
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
											<td><a href="{{ product.brand.url }}" class="text-link">{{ product.brand.title }}</a></td>
										</tr>
									{% endif %}

									{% if product.tags %}
										<tr class="product-tags">
											<th>{{ 'lang.storefront.product.tags.label'|t }}</th>
											<td>
												<ul class="list-inline list-unstyled">
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

					{% if product.video_embed_url %}
						<div class="product-video">
							<div class="embed-responsive embed-responsive-16by9" data-service="{{ product.video_embed_url matches '/youtube/' ? 'youtube' : 'vimeo' }}" data-id="{{ product.video_embed_url|split('/')|last }}" data-ratio="16:9" data-autoscale>
								{% if not apps.cookies or (apps.cookies and not apps.cookies.consent_mode) %}
                                	<iframe width="560" height="315" src="{{ product.video_embed_url }}" allow="autoplay; encrypted-media" allowfullscreen></iframe>
                            	{% endif %}
							</div>
						</div>
					{% endif %}

				</div>
			</div>

		</article>

		<div class="related-products hidden" data-load="related-products" data-products="{{ product.id }}" data-num-products="4" data-css-class-wrapper="product-related-products">
			<h3>{{ product.related_products.title }}</h3>
			<div class="related-products-placement margin-top"></div>
		</div>

	</div>

{% endblock %}
