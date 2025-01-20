{#
Description: Search Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set order_options = { 'relevance' : 'lang.storefront.layout.order_options.position'|t, 'title' : 'lang.storefront.layout.order_options.title'|t, 'newest' : 'lang.storefront.layout.order_options.newest'|t, 'sales' : 'lang.storefront.layout.order_options.sales'|t, 'price_asc' : 'lang.storefront.layout.order_options.price_asc'|t, 'price_desc' : 'lang.storefront.layout.order_options.price_desc'|t, 'stock_desc' : 'lang.storefront.layout.order_options.stock_desc'|t, 'stock_asc' : 'lang.storefront.layout.order_options.stock_asc'|t, 'rating' : 'lang.storefront.layout.order_options.rating'|t } %}

	{% if not get.order_by in order_options|keys %}
		{% set get = {'order_by': store.theme_options.search_default_order} %}
	{% endif %}

	{% set search = products("search order:#{get.order_by} limit:#{products_per_page_catalog}") %}

	{% set total_products = search.total_results %}
	{% set cur_page = (pagination_segment / products_per_page_catalog) + 1 %}
	{% set cur_page_from = pagination_segment + 1 %}
	{% set cur_page_to = (cur_page * products_per_page_catalog) < search.total_results ? cur_page * products_per_page_catalog : search.total_results %}

	<ul class="breadcrumb well-default">
		<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
		<li>{{ 'lang.storefront.search.title'|t }}<span class="divider">›</span></li>
		<li class="active">{{ search.query }}</li>
	</ul>

	<h1>{{ 'lang.storefront.search.title'|t }}</h1>

	{% if search.results %}
		{{ generic_macros.order_by(get, order_options, site_url("search?q=#{search.query}&")) }}
	{% endif %}

	{% if search.results %}
		<p>{{ 'lang.storefront.search.results'|t([cur_page_from, cur_page_to, total_products, search.query]) }}</p>
	{% else %}
		<p>{{ 'lang.storefront.search.results.variant'|t([search.total_results, search.query]) }}</p>
	{% endif %}
	<br>

	<div class="row products">

		{% for product in search.results %}

			<div class="span3">
				{{ generic_macros.product_list(product) }}
			</div>

		{% else %}

			<div class="span9 product">
				<h5>{{ 'lang.storefront.product_list.no_products'|t }}</h5>
			</div>

		{% endfor %}

		<div class="span9 product">

			<hr>

			{{ pagination("search limit:#{products_per_page_catalog}") }}

		</div>

	</div>

{% endblock %}