{#
Description: Search Page
#}

{% import 'base.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set search = products("search limit:#{products_per_page_catalog}") %}

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