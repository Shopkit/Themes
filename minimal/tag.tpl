{#
Description: Product tag page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{#  Setup order #}
	{% set order_options = { 'position' : 'Relevância', 'title' : 'Título', 'newest' : 'Mais recentes', 'sales' : 'Mais vendidos', 'price_asc' : 'Mais baratos', 'price_desc' : 'Mais caros', 'stock_desc' : 'Mais stock', 'stock_asc' : 'Menos stock' } %}

	{% if not get.order_by in order_options|keys %}
		{% set get = {'order_by': store.category_default_order|default('position')} %}
	{% endif %}

	{% set products = products("order:#{get.order_by} tag:#{tag.handle} limit:#{products_per_page_catalog}") %}

	<div class="container">
		<div class="row">
			<div class="col-lg-3">

				<h1 class="margin-top-0 margin-bottom"><a href="{{ tag.url }}" class="link-inherit">{{ tag.title }}</a></h1>

				<ol class="breadcrumb">
					<li><a href="{{ site_url() }}">Home</a></li>
					<li class="active">
						<a href="{{ tag.url }}"><span>{{ tag.title }}</span></a>
					</li>
				</ol>

				{% if tag.description %}
					<div class="description">{{ tag.description }}</div>
				{% endif %}

				{% if products %}
					<div class="order-options">
						<small>Ordenar por</small> &nbsp;

						<div class="btn-group">
							<button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown">
								{% if get.order_by and order_options[get.order_by] %}
									{{ order_options[get.order_by] }}
								{% else %}
									{{ order_options['position'] }}
								{% endif %}
								<span class="caret"></span>
							</button>

							<ul class="dropdown-menu" role="menu">
								{% for order_option, order_title in order_options %}
									{% if order_option != get.order_by %}
										<li><a href="{{ tag.url }}?order_by={{ order_option }}">{{ order_title }}</a></li>
									{% endif %}
								{% endfor %}
							</ul>
						</div>
					</div>
				{% endif %}

			</div>

			<div class="col-lg-9">
				{% if products %}
					<div class="products margin-top-0">
						<div class="row">

							{% for product in products %}
								<div class="col-sm-4">
									<article class="product product-id-{{ product.id }}" data-id="{{ product.id }}">

										{% if product.status_alias == 'out_of_stock' %}
											<span class="badge out_of_stock">Sem stock</span>
										{% elseif product.promo == true %}
											<span class="badge promo">Promoção</span>
										{% endif %}

										<a href="{{ product.url }}"><img src="{{ product.image.square }}" class="img-responsive" alt="{{ product.title|e_attr }}" title="{{ product.title|e_attr }}" width="400" height="400"></a>

										<div class="product-info">
											<a class="product-details" href="{{ product.url }}">
												<div>
													<h2>{{ product.title }}</h2>

													<span class="price">
														{% if product.price_on_request == true %}
															Preço sob consulta
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

									</article>
								</div>
							{% endfor %}

						</div>
					</div>

					<nav class="text-center">
						{{ pagination("tag:#{tag.handle} limit:#{products_per_page_catalog}") }}
					</nav>

				{% else %}
					<div class="col-xs-12">
						<h3 class="margin-bottom-lg margin-top-0 text-gray light">Não existem produtos</h3>
					</div>
				{% endif %}

			</div>
		</div>
	</div>

{% endblock %}
