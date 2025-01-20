{#
Description: Product category page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{#  Parent category #}
	{% if category.is_parent %}
		{% set parent_category = category %}
		{% set is_parent = true %}

		{% if category.parent %}
			{% set main_parent = category(category.parent) %}
		{% else %}
			{% set main_parent = category %}
		{% endif %}
	{% else %}
		{% set parent_category = category(category.parent) %}
		{% set main_parent = category(parent_category.parent) ?: parent_category %}
	{% endif %}

	{#  Setup order #}
	{% set order_options = { 'position' : 'lang.storefront.layout.order_options.position'|t, 'title' : 'lang.storefront.layout.order_options.title'|t, 'newest' : 'lang.storefront.layout.order_options.newest'|t, 'sales' : 'lang.storefront.layout.order_options.sales'|t, 'price_asc' : 'lang.storefront.layout.order_options.price_asc'|t, 'price_desc' : 'lang.storefront.layout.order_options.price_desc'|t, 'stock_desc' : 'lang.storefront.layout.order_options.stock_desc'|t, 'stock_asc' : 'lang.storefront.layout.order_options.stock_asc'|t, 'rating' : 'lang.storefront.layout.order_options.rating'|t } %}

	{% if not get.order_by in order_options|keys %}
		{% set get = {'order_by': store.category_default_order|default('position')} %}
	{% endif %}

	{% set products = products("order:#{get.order_by} category:#{category.id} limit:#{products_per_page_catalog}") %}

	<div class="wide">

		<h1 class="wide">{{ category.title }}</h1>

		{% if products %}
			<div class="order-options-container">
				{{ generic_macros.order_by(get, order_options, category.url ~ '?') }}
			</div>
		{% endif %}

	</div>

	<p class="breadcrumbs wide">
		<a href="{{ site_url() }}"><i class="fa fa-home"></i></a> ›
		{% if main_parent and main_parent.id != category.id %}
			<a href="{{ main_parent.url }}">{{ main_parent.title }}</a> ›
		{% endif %}
		{% if category.id != parent_category.id and parent_category.is_parent and parent_category.is_child %}
			<a href="{{ parent_category.url }}">{{ parent_category.title }}</a> ›
		{% endif %}
		{{ category.title }}
	</p>

	{% if category.description %}
		<p class="wide">{{ category.description }}</p>
	{% endif %}

	{% if products %}

		<ul class="unstyled products">

			{% for product in products %}
				{{ generic_macros.product_list(product) }}
			{% endfor %}

		</ul>

		{{ pagination("category:#{category.id} limit:#{products_per_page_catalog}") }}

	{% elseif is_parent and parent_category.children %}

		<ul class="unstyled categories-list">
			{% for category in parent_category.children %}
				{{ generic_macros.category_list(category) }}
			{% endfor %}
		</ul>

	{% else %}
		<p class="wide">{{ 'lang.storefront.category.no_products'|t }}.</p>
	{% endif %}

{% endblock %}