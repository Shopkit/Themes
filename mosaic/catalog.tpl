{#
Description: Product catalog page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{#  Setup order #}
	{% set order_options = { 'position' : 'lang.storefront.layout.order_options.position'|t, 'title' : 'lang.storefront.layout.order_options.title'|t, 'newest' : 'lang.storefront.layout.order_options.newest'|t, 'sales' : 'lang.storefront.layout.order_options.sales'|t, 'price_asc' : 'lang.storefront.layout.order_options.price_asc'|t, 'price_desc' : 'lang.storefront.layout.order_options.price_desc'|t, 'stock_desc' : 'lang.storefront.layout.order_options.stock_desc'|t, 'stock_asc' : 'lang.storefront.layout.order_options.stock_asc'|t, 'rating' : 'lang.storefront.layout.order_options.rating'|t } %}

	{% if not get.order_by in order_options|keys %}
		{% set get = {'order_by': store.category_default_order|default('position')} %}
	{% endif %}

	{% set products = products("order:#{get.order_by} limit:#{products_per_page_catalog}") %}

	<div class="wide">

		<h1 class="wide">{{ 'lang.storefront.catalog.title'|t }}</h1>

		{% if products %}

			<div class="order-options-container">
				{{ generic_macros.order_by(get, order_options, site_url("catalog?")) }}
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
		<p class="wide">{{ 'lang.storefront.product_list.no_products'|t }}.</p>
	{% endif %}

{% endblock %}