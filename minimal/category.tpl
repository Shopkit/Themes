{#
Description: Product category page
#}

{% import 'base.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set products_per_page = 9 %}

	{#  Parent category #}
	{% if category.parent %}
		{% set parent_category = category(category.parent) %}
	{% else %}
		{% set parent_category = category %}
		{% set is_parent = true %}
	{% endif %}

	<div class="container">

		<div class="row">
			<div class="col-lg-3">

				<h1 class="margin-top-0 margin-bottom"><a href="{{ category.url }}" class="link-inherit">{{ category.title }}</a></h1>

				{% if category.parent %}
					<ol class="breadcrumb">

						<li>
							<a href="{{ parent_category.url }}"><span>{{ parent_category.title }}</span></a>
						</li>

						<li class="active">
							<a href="{{ category.url }}"><span>{{ category.title }}</span></a>
						</li>

					</ol>
				{% endif %}

				{% if category.description %}
					<div class="description">{{ category.description }}</div>
				{% endif %}

				{#  Setup order #}
				{% set order_options = { 'position' : 'Relevância', 'title' : 'Título', 'newest' : 'Mais recentes', 'sales' : 'Mais vendidos', 'price_asc' : 'Mais baratos', 'price_desc' : 'Mais caros', 'stock_desc' : 'Mais stock', 'stock_asc' : 'Menos stock' } %}

				{% if not get.order_by in order_options|keys %}
					{% set get = {'order_by': store.category_default_order|default('position')} %}
				{% endif %}

				{% set products = products("order:#{get.order_by} category:#{category.id} limit:#{products_per_page}") %}

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
										<li><a href="{{ category.url }}?order_by={{ order_option }}">{{ order_title }}</a></li>
									{% endif %}
								{% endfor %}
							</ul>
						</div>
					</div>
				{% endif %}

				{% if parent_category.children %}
					<div class="panel panel-default margin-bottom">

						<div class="panel-heading">
							<a href="{{ parent_category.url }}" class="link-inherit">{{ parent_category.title }}</a>
						</div>

						<div class="list-group">

							{% for product_category in categories %}
								{% if product_category.id == parent_category.id and product_category.children %}
									{% for children in product_category.children %}
										<a href="{{ children.url }}" class="list-group-item {% if children.id == category.id %}active{% endif %}">
											{{ children.title }} <span class="text-muted">({{ children.total_products }})</span>
										</a>
									{% endfor %}
								{% endif %}
							{% endfor %}

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
									<article class="product product-id-{{ product.id }}">

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
						{{ pagination("category:#{category.id} limit:#{products_per_page}") }}
					</nav>

				{% elseif is_parent and parent_category.children %}
					<div class="categories margin-top-0">
						<div class="row">

							{% for category in parent_category.children %}
								<div class="col-sm-4">
									{{ generic_macros.category_list(category) }}
								</div>
								{% if loop.index0%3 == 2 %}
									<div class="clearfix hidden-xs"></div>
								{% endif %}
							{% endfor %}

						</div>
					</div>

				{% else %}
					<div class="col-xs-12">
						<h3 class="margin-bottom-lg margin-top-0 text-gray light">Não existem produtos</h3>
					</div>
				{% endif %}

			</div>
		</div>

	</div>

{% endblock %}