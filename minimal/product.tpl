{#
Description: Product Page
#}

{% macro wishlist_block(product, user) %}
	{% if user.is_logged_in %}
		{% if not product.wishlist.status %}
			<p class="wishlist margin-top-sm margin-bottom-0"><a href="{{ product.wishlist.add_url }}" class="text-muted"><i class="fa fa-heart fa-fw"></i> Adicionar à wishlist</a></p>
		{% else %}
			<p class="wishlist margin-top-sm margin-bottom-0"><a href="{{ product.wishlist.remove_url }}" class="text-muted"><i class="fa fa-heart-o fa-fw"></i> Remover da wishlist</a></p>
		{% endif %}
	{% endif %}
{% endmacro %}

{% import _self as product_macros %}
{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="container">

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
									<a href="{{ product.image.full }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image.full }}" alt="{{ product.title|e_attr }}" title="{{ product.title|e_attr }}" width="600" class="lazy"></a>
								</li>

								{% if product.images %}
									{% for image in product.images %}
										<li class="slide">
											<a href="{{ image.full }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ image.full }}" alt="{{ product.title|e_attr }}" title="{{ product.title|e_attr }}" width="600" class="lazy"></a>
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
								<a target="_blank" href="{{ product.file }}" class="text-light-gray file-download"><i class="fa fa-fw fa-download"></i></a>
							</div>
						</div>
					{% else %}
						<h1 class="product-title">{{ product.title }}</h1>
					{% endif %}

					<div class="row block-price">
						<div class="col-xs-6 col-md-7 col-lg-6">

							<div>

								{% if product.price_on_request == true %}
									<span class="data-product-price price">Preço sob consulta</span> &nbsp;
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
										<small class="text-light-gray block">Preço normal: <span class="data-price-non-wholesale">{{ product.price_non_wholesale | money_with_sign }}</span></small>
									{% endif %}

									{% if not (user.wholesale is same as(true) and product.wholesale == true and store.settings.wholesale.show_regular_price) %}
										<small class="text-light-gray block data-promo-percentage {% if product.price_promo_percentage == false %}hidden{% endif %}">
											Desconto de {% if product.price_promo_percentage == true %}{{ product.price_promo_percentage }}{% endif %}%
										</small>
									{% endif %}

									{% if product.tax > 0 %}
										{% if store.taxes_included == false %}
											<small class="text-light-gray block"><em>Ao preço do produto acresce {{ user.l10n.tax_name }} de <strong>{{ product.tax }}%</strong></em></small>
										{% else %}
											<small class="text-light-gray block"><em>{{ user.l10n.tax_name }} incluído</em></small>
										{% endif %}
									{% endif %}
								</div>
							</div>

						</div>

						<div class="col-xs-6 col-md-5 col-lg-6">
							<div class="text-center share pull-right">
								<h6 class="text-muted text-uppercase">Partilhar</h6>
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

								<div class="well">
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

							<div class="data-product-info">
								<div class="row">
									<div class="col-sm-7 col-md-12 col-lg-7">
										<input type="number" class="form-control" value="1" min="1" name="qtd" {% if product.stock.stock_sold_single %} data-toggle="tooltip" data-placement="bottom" data-original-title="Só é possível comprar 1 unidade deste produto." title="Só é possível comprar 1 unidade deste produto." readonly {% endif %}>
										<button type="submit" class="btn btn-gray text-uppercase"><i class="fa fa-cart-plus fa-fw"></i> Adicionar</button>
									</div>
									<div class="col-sm-5 col-md-12 col-lg-5">
										{{ product_macros.wishlist_block(product, user) }}
									</div>
								</div>
							</div>

							<div class="data-product-on-request">
								<div class="row">
									<div class="col-sm-7 col-md-12 col-lg-7">
										<a href="{{ site_url("contact?p=") ~ "Produto #{product.title}"|url_encode }}" class="btn btn-gray text-uppercase price-on-request"><i class="fa fa-envelope fa-fw"></i> Contactar</a>
									</div>
									<div class="col-sm-5 col-md-12 col-lg-5">
										{{ product_macros.wishlist_block(product, user) }}
									</div>
								</div>
							</div>

							{% if product.stock.stock_show or product.reference %}
								<p class="text-light-gray small margin-top-xs margin-bottom-0">
									{% if product.stock.stock_show %}
										<strong class="data-product-stock_qty">{{ product.stock.stock_qty }}</strong> unidades em stock {{ product.reference ? ' | ' }}
									{% endif %}
									{% if product.reference %}
										SKU: <span class="sku">{{ product.reference }}</span>
									{% endif %}
								</p>
							{% endif %}

						{{ form_close() }}

					{% elseif product.status == 3 %}
						<div class="well">
							O produto encontra-se sem stock.
						</div>
						{{ product_macros.wishlist_block(product, user) }}

					{% elseif product.status == 4 %}
						<div class="well">
							O produto estará disponível para compra brevemente.
						</div>
						{{ product_macros.wishlist_block(product, user) }}

					{% endif %}

					{% if product.tabs %}
						<div class="panel-group product-tabs margin-top" id="product-tabs" role="tablist" aria-multiselectable="true">
							{% if product.description %}
								<div class="panel panel-default">
									<div class="panel-heading" role="tab" id="tab_description">
										<h4 class="panel-title"><a role="button" data-toggle="collapse" data-parent="#product-tabs" href="#panel_description" aria-expanded="true" aria-controls="panel_description">Descrição</a></h4>
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
											<th>Marca</th>
											<td><a href="{{ product.brand.url }}" class="text-underline">{{ product.brand.title }}</a></td>
										</tr>
									{% endif %}

									{% if product.tags %}
										<tr class="product-tags">
											<th>Tags</th>
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
											<td>{{ custom_field.value }}</td>
										</tr>
									{% endfor %}
								</table>
							</div>
						</div>
					{% endif %}

					{% if product.video_embed_url %}
						<div class="product-video">
							<div class="embed-responsive embed-responsive-16by9">
								<iframe class="embed-responsive-item" src="{{ product.video_embed_url }}"></iframe>
							</div>
						</div>
					{% endif %}

				</div>
			</div>

		</article>

		<div class="related-products hidden" data-load="related-products" data-products="{{ product.id }}" data-num-products="4" data-products-per-row="4" data-css-class-wrapper="product-related-products">
			<h3>{{ product.related_products.title }}</h3>
			<div class="related-products-placement margin-top"></div>
		</div>

	</div>

{% endblock %}
