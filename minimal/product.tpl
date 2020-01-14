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
									<a href="{{ product.image.full }}"><img src="{{ product.image.full }}" alt="{{ product.title|e_attr }}" title="{{ product.title|e_attr }}" width="600"></a>
								</li>

								{% if product.images %}
									{% for image in product.images %}
										<li class="slide">
											<a href="{{ image.full }}"><img src="{{ image.full }}" alt="{{ product.title|e_attr }}" title="{{ product.title|e_attr }}" width="600"></a>
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
								<h1>{{ product.title }}</h1>
							</div>
							<div class="col-xs-2 text-right">
								<a target="_blank" href="{{ product.file }}" class="text-light-gray file-download"><i class="fa fa-fw fa-download"></i></a>
							</div>
						</div>
					{% else %}
						<h1>{{ product.title }}</h1>
					{% endif %}

					{% if product.reference %}
						<small class="text-light-gray block">SKU: <span class="sku">{{ product.reference }}</span></small>
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
									<small class="text-light-gray block data-promo-percentage">
										{% if product.price_promo_percentage == true %}
											Desconto de {{ product.price_promo_percentage }}%
										{% endif %}
									</small>

									{% if product.tax > 0 %}
										{% if store.taxes_included == false %}
											<small class="text-light-gray block"><em>Ao preço do produto acresce IVA de <strong>{{ product.tax }}%</strong></em></small>
										{% else %}
											<small class="text-light-gray block"><em>IVA incluído</em></small>
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

															{% if option.price_on_request == true %}
																- Preço sob consulta
															{% else %}
																{% if option.price is not null %}
																	{% set option_display_price = option.promo ? option.price_promo : option.price %}
																	- {{ option_display_price | money_with_sign }}
																{% endif %}
															{% endif %}
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
										<input type="number" class="form-control" value="1" name="qtd" {% if product.stock.stock_sold_single %} data-toggle="tooltip" data-placement="bottom" data-original-title="Só é possível comprar 1 unidade deste produto." title="Só é possível comprar 1 unidade deste produto." readonly {% endif %}>
										<button type="submit" class="btn btn-gray text-uppercase"><i class="fa fa-cart-plus fa-fw"></i> Adicionar</button>

										{% if product.stock.stock_show %}
											<p class="text-light-gray small margin-top-xs margin-bottom-0">
												<strong class="data-product-stock_qty">{{ product.stock.stock_qty }}</strong> unidades em stock
											</p>
										{% endif %}
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

					<div class="description">
						{{ product.description }}
					</div>

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

		{% set related_products = products("order:featured category:#{product.categories[0].id} exclude:products[#{product.id}] limit:4") %}

		{% if related_products|length > 2 %}

			<div class="related-products margin-top-lg">
				<div class="text-center">
					<h3>Também poderá gostar de</h3>
				</div>

				<div class="products">
					<div class="row">

						{% for related_product in related_products %}
							<div class="col-xs-6 col-sm-4 col-md-3 {% if loop.index == 4 %}hidden-sm{% endif %} {% if loop.index > 2 %}hidden-xs{% endif %}">
								<article class="product product-id-{{ related_product.id }}">

									{% if related_product.status_alias == 'out_of_stock' %}
										<span class="badge out_of_stock">Sem stock</span>
									{% elseif related_product.promo == true %}
										<span class="badge promo">Promoção</span>
									{% endif %}

									<a href="{{ related_product.url }}"><img src="{{ related_product.image.square }}" class="img-responsive" alt="{{ related_product.title|e_attr }}" title="{{ related_product.title|e_attr }}" width="400" height="400"></a>

									<div class="product-info">
										<a class="product-details" href="{{ related_product.url }}">
											<div>
												<h2>{{ related_product.title }}</h2>

												<span class="price">
													{% if related_product.price_on_request == true %}
														Preço sob consulta
													{% else %}
														{% if related_product.promo == true %}
															 {{ related_product.price_promo | money_with_sign }} <del>{{ related_product.price | money_with_sign }}</del>
														{% else %}
															{{ related_product.price | money_with_sign }}
														{% endif %}
													{% endif %}
												</span>
											</div>
										</a>
									</div>

								</article>
							</div>
						{% else %}
							<div class="col-xs-12 padding-bottom-lg text-center">
								<h3 class="margin-top-0 text-gray light">Não existem produtos nesta categoria</h3>
							</div>
						{% endfor %}

					</div>
				</div>
			</div>

		{% endif %}

	</div>

{% endblock %}