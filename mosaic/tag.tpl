{#
Description: Product tag page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set category_default_order = store.category_default_order|default('position') %}

	{% set products = products("order:#{category_default_order} tag:#{tag.handle} limit:#{products_per_page_catalog}") %}

	<h1 class="wide">{{ tag.title }}</h1>

	<p class="breadcrumbs wide">
		<a href="{{ site_url() }}">{{ icons('home') }}</a> ›
		{{ tag.title }}
	</p>

	{% if tag.description %}
		<p class="wide">{{ tag.description }}</p>
	{% endif %}

	{% if products %}

		<ul class="unstyled products">

			{% for product in products %}
				{{ generic_macros.product_list(product) }}
			{% endfor %}

		</ul>

		{{ pagination("tag:#{tag.handle} limit:#{products_per_page_catalog}") }}

	{% else %}
		<p class="wide">{{ 'lang.storefront.tag.no_products'|t }}.</p>
	{% endif %}

{% endblock %}