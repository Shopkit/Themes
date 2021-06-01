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

	<h1 class="wide">Pesquisa</h1>

	{% if search.results %}

		{% if search.results %}
			<p class="wide">A mostrar {{ cur_page_from }}-{{ cur_page_to }} de {{ total_products }} produtos para a pesquisa: <strong><em>{{ search.query }}</em></strong></p>
		{% else %}
			<p class="wide">Foram encontrados <strong>{{ search.total_results }}</strong> produtos para a pesquisa: <strong><em>{{ search.query }}</em></strong></p>
		{% endif %}

		<ul class="unstyled products">

			{% for product in search.results %}
				{{ generic_macros.product_list(product) }}
			{% endfor %}

		</ul>

		{{ pagination("search limit:#{products_per_page_catalog}") }}

	{% else %}
		<p class="wide">Não existem produtos para a pesquisa: <strong><em>{{ search.query }}</em></strong></p>
	{% endif %}

{% endblock %}