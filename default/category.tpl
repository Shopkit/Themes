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

	<ul class="breadcrumb well-default">
		<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
		{% if main_parent and main_parent.id != category.id %}
			<li>
				<a href="{{ main_parent.url }}">{{ main_parent.title }}</a><span class="divider">›</span>
			</li>
		{% endif %}
		{% if category.id != parent_category.id and parent_category.is_parent and parent_category.is_child %}
			<li>
				<a href="{{ parent_category.url }}">{{ parent_category.title }}</a><span class="divider">›</span>
			</li>
		{% endif %}
		<li class="active">{{ category.title }}</li>
	</ul>

	<h1>{{ category.title }}</h1>

	{% if products %}
		{{ generic_macros.order_by(get, order_options, category.url ~ '?') }}
	{% endif %}

	<p>{{ category.description }}</p>
	<hr>

	{% if products %}

		<div class="row products">

			{% for product in products %}

				<div class="span3">
					{{ generic_macros.product_list(product) }}
				</div>

			{% else %}

				<div class="span9 product">
					<h5>{{ 'lang.storefront.category.no_products'|t }}.</h5>
				</div>

			{% endfor %}

			<div class="span9 product">
				<hr>
				{{ pagination("category:#{category.id} limit:#{products_per_page_catalog}") }}
			</div>

		</div>

	{% elseif is_parent and parent_category.children %}

		<div class="row categories">
			{% for category in parent_category.children %}
				{{ generic_macros.category_list(category) }}
			{% endfor %}
		</div>

	{% else %}
		<div class="row products">
			<div class="span9 product">
				<h5>{{ 'lang.storefront.category.no_products'|t }}.</h5>
			</div>
		</div>
	{% endif %}

{% endblock %}