{#
Description: Product catalog page
#}

{% import 'base.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{#  Setup order #}
	{% set order_options = { 'position' : 'Relevância', 'title' : 'Título', 'newest' : 'Mais recentes', 'sales' : 'Mais vendidos', 'price_asc' : 'Mais baratos', 'price_desc' : 'Mais caros', 'stock_desc' : 'Mais stock', 'stock_asc' : 'Menos stock' } %}

	{% if not get.order_by in order_options|keys %}
		{% set get = {'order_by': store.category_default_order|default('position')} %}
	{% endif %}

	{% set products = products("order:#{get.order_by} limit:#{products_per_page_catalog}") %}

	<div class="container">

		<div class="row">
			<div class="col-lg-3">

				<h1 class="margin-top-0 margin-bottom">Todos os produtos</h1>

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
										<li><a href="{{ site_url("catalog?order_by=#{order_option}") }}">{{ order_title }}</a></li>
									{% endif %}
								{% endfor %}
							</ul>
						</div>
					</div>
				{% endif %}
			</div>

			<div class="col-lg-9">
				<div class="products margin-top-0">
					<div class="row">

						{% for product in products %}
							<div class="col-sm-4">
								{{ generic_macros.product_list(product) }}
							</div>
						{% else %}
							<div class="col-xs-12">
								<h3 class="margin-bottom-lg margin-top-0 text-gray light">Não existem produtos</h3>
							</div>
						{% endfor %}

					</div>
				</div>

				<nav class="text-center">
					{{ pagination("products limit:#{products_per_page_catalog}") }}
				</nav>

			</div>
		</div>

	</div>

{% endblock %}