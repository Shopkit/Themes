{#
Description: Product catalog page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{#  Setup order #}
	{% set order_options = { 'position' : 'Relevância', 'title' : 'Título', 'newest' : 'Mais recentes', 'sales' : 'Mais vendidos', 'price_asc' : 'Mais baratos', 'price_desc' : 'Mais caros', 'stock_desc' : 'Mais stock', 'stock_asc' : 'Menos stock' } %}

	{% if not get.order_by in order_options|keys %}
		{% set get = {'order_by': store.category_default_order|default('position')} %}
	{% endif %}

	{% set products = products("order:#{get.order_by} limit:#{products_per_page_catalog}") %}

	<div class="wide">

		<h1 class="wide">Todos os produtos</h1>

		{% if products %}

			<div class="order-options-container">

				<div class="order-options">
					Ordenar por &nbsp;

					<div class="btn-group">

						<button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown">
							{% if get.order_by and order_options[get.order_by] %}
								{{ order_options[get.order_by] }}
							{% else %}
								{{ order_options['position'] }}
							{% endif %}
							<span class="caret"></span>
						</button>

						<ul class="dropdown-menu pull-right" role="menu">
							{% for order_option, order_title in order_options %}
								{% if order_option != get.order_by %}
									<li><a href="{{ site_url("catalog?order_by=#{order_option}") }}">{{ order_title }}</a></li>
								{% endif %}
							{% endfor %}
						</ul>
					</div>
				</div>

			</div>

		{% endif %}

	</div>

	{% if products %}

		<ul class="unstyled products">

			{% for product in products %}
				{{ generic_macros.product_list(product) }}
			{% endfor %}

		</ul>

		{{ pagination("products limit:#{products_per_page_catalog}") }}

	{% else %}
		<p class="wide">Não existem produtos.</p>
	{% endif %}

{% endblock %}