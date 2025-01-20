{#
Description: Search Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{#  Setup order #}
	{% set order_options = { 'relevance' : 'lang.storefront.layout.order_options.position'|t, 'title' : 'lang.storefront.layout.order_options.title'|t, 'newest' : 'lang.storefront.layout.order_options.newest'|t, 'sales' : 'lang.storefront.layout.order_options.sales'|t, 'price_asc' : 'lang.storefront.layout.order_options.price_asc'|t, 'price_desc' : 'lang.storefront.layout.order_options.price_desc'|t, 'stock_desc' : 'lang.storefront.layout.order_options.stock_desc'|t, 'stock_asc' : 'lang.storefront.layout.order_options.stock_asc'|t, 'rating' : 'lang.storefront.layout.order_options.rating'|t } %}

	{% if not get.order_by in order_options|keys %}
		{% set get = {'order_by': store.theme_options.search_default_order} %}
	{% endif %}

	{% set search = products("search order:#{get.order_by} limit:#{products_per_page_catalog}") %}

	{% set total_products = search.total_results %}
	{% set cur_page = (pagination_segment / products_per_page_catalog) + 1 %}
	{% set cur_page_from = pagination_segment + 1 %}
	{% set cur_page_to = (cur_page * products_per_page_catalog) < search.total_results ? cur_page * products_per_page_catalog : search.total_results %}

	<div class="wide">
		<h1 class="wide">{{ 'lang.storefront.search.title'|t }}</h1>

		{% if search.results %}

			<div class="order-options-container">
				{{ generic_macros.order_by(get, order_options, site_url("search?q=#{search.query}&")) }}
			</div>

		{% endif %}
	</div>

	{% if search.results %}

		{% if search.results %}
			<p class="wide">{{ 'lang.storefront.search.results'|t([cur_page_from, cur_page_to, total_products, search.query]) }}</p>
		{% else %}
			<p class="wide">{{ 'lang.storefront.search.results.variant'|t([search.total_results, search.query]) }}</p>
		{% endif %}

		<ul class="unstyled products">

			{% for product in search.results %}
				{{ generic_macros.product_list(product) }}
			{% endfor %}

		</ul>

		{{ pagination("search limit:#{products_per_page_catalog}") }}

	{% else %}
		<p class="wide">{{ 'lang.storefront.product_list.no_products'|t }}</p>
	{% endif %}

{% endblock %}
