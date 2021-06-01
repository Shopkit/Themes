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

	<ul class="breadcrumb">
		<li><a href="{{ site_url() }}">Home</a><span class="divider">›</span></li>
		<li>Pesquisa<span class="divider">›</span></li>
		<li class="active">{{ search.query }}</li>
	</ul>

	<h1>Pesquisa</h1>
	{% if search.results %}
		<p>A mostrar {{ cur_page_from }}-{{ cur_page_to }} de {{ total_products }} produtos para a pesquisa: <strong><em>{{ search.query }}</em></strong></p>
	{% else %}
		<p>Foram encontrados <strong>{{ search.total_results }}</strong> produtos para a pesquisa: <strong><em>{{ search.query }}</em></strong></p>
	{% endif %}
	<br>

	<div class="row products">

		{% for product in search.results %}
			{{ generic_macros.product_list(product) }}
		{% else %}

			<div class="span9 product">
				<h5>Não existem produtos.</h5>
			</div>

		{% endfor %}

		<div class="span9 product">

			<hr>

			{{ pagination("search limit:#{products_per_page_catalog}") }}

		</div>

	</div>

{% endblock %}