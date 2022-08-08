{#
Description: Search Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{#  Setup order #}
	{% set order_options = { 'relevance' : 'Relevância', 'title' : 'Título', 'newest' : 'Mais recentes', 'sales' : 'Mais vendidos', 'price_asc' : 'Mais baratos', 'price_desc' : 'Mais caros', 'stock_desc' : 'Mais stock', 'stock_asc' : 'Menos stock' } %}

	{% if not get.order_by in order_options|keys %}
		{% set get = {'order_by': 'relevance'} %}
	{% endif %}

	{% set search = products("search order:#{get.order_by} limit:#{products_per_page_catalog}") %}

	{% set total_products = search.total_results %}
	{% set cur_page = (pagination_segment / products_per_page_catalog) + 1 %}
	{% set cur_page_from = pagination_segment + 1 %}
	{% set cur_page_to = (cur_page * products_per_page_catalog) < search.total_results ? cur_page * products_per_page_catalog : search.total_results %}

	<div class="container">

		<div class="row">

			<div class="col-sm-12 col-md-3">
				<h1 class="margin-top-0">Pesquisa</h1>
				{% if search.results %}
					<p>A mostrar {{ cur_page_from }}-{{ cur_page_to }} de {{ total_products }} produtos para a pesquisa: <strong><em>{{ search.query }}</em></strong></p>
				{% else %}
					<p>Foram encontrados <strong>{{ search.total_results }}</strong> produtos para a pesquisa: <strong><em>{{ search.query }}</em></strong></p>
				{% endif %}

				{% if search.results %}
					<div class="order-options">
						<small>Ordenar por</small> &nbsp;
						<div class="btn-group">

							<button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown">
								{% if get.order_by and order_options[get.order_by] %}
									{{ order_options[get.order_by] }}
								{% else %}
									{{ order_options['relevance'] }}
								{% endif %}
								<span class="caret"></span>
							</button>

							<ul class="dropdown-menu" role="menu">
								{% for order_option, order_title in order_options %}
									{% if order_option != get.order_by %}
										<li><a href="{{ site_url("search?q=#{search.query}&order_by=#{order_option}") }}">{{ order_title }}</a></li>
									{% endif %}
								{% endfor %}
							</ul>
						</div>
					</div>
				{% endif %}
			</div>

			<div class="col-sm-12 col-md-9">

				<div class="products">
					<div class="row">

						{% for product in search.results %}
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

			</div>

		</div>

		<nav class="text-center">
			{{ pagination("search limit:#{products_per_page_catalog}") }}
		</nav>

	</div>

{% endblock %}
