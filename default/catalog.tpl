{#
Description: Product catalog page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set order_options = { 'position' : 'lang.storefront.layout.order_options.position'|t, 'title' : 'lang.storefront.layout.order_options.title'|t, 'newest' : 'lang.storefront.layout.order_options.newest'|t, 'sales' : 'lang.storefront.layout.order_options.sales'|t, 'price_asc' : 'lang.storefront.layout.order_options.price_asc'|t, 'price_desc' : 'lang.storefront.layout.order_options.price_desc'|t, 'stock_desc' : 'lang.storefront.layout.order_options.stock_desc'|t, 'stock_asc' : 'lang.storefront.layout.order_options.stock_asc'|t, 'rating' : 'lang.storefront.layout.order_options.rating'|t } %}

	{% if not get.order_by in order_options|keys %}
		{% set get = {'order_by': store.category_default_order|default('position')} %}
	{% endif %}

	{% set products = products("order:#{get.order_by} limit:#{products_per_page_catalog}") %}

	<ul class="breadcrumb well-default">
		<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
		<li class="active">{{ 'lang.storefront.catalog.title'|t }}</li>
	</ul>

	<h1>{{ 'lang.storefront.catalog.title'|t }}</h1>

	{% if products %}
		{{ generic_macros.order_by(get, order_options, site_url("catalog?")) }}
	{% endif %}

	<hr>

	<div class="row products">

		{% for product in products %}

			<div class="span3">
				{{ generic_macros.product_list(product) }}
			</div>

		{% else %}

			<div class="span9 product">
				<h5>{{ 'lang.storefront.product_list.no_products'|t }}.</h5>
			</div>

		{% endfor %}

		<div class="span9">
			<hr>

			{{ pagination("products limit:#{products_per_page_catalog}") }}
		</div>

	</div>

{% endblock %}