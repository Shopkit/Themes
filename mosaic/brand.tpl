{#
Description: Product brand page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set category_default_order = store.category_default_order|default('position') %}

	{% set products = products("order:#{category_default_order} brand:#{brand.id} limit:#{products_per_page_catalog}") %}

	<h1 class="wide">{{ brand.title }}</h1>

	<p class="breadcrumbs wide">
		<a href="{{ site_url() }}"><i class="fa fa-home"></i></a> ›
		<a href="{{ site_url('brands') }}">{{ 'lang.storefront.brand.title'|t }}</a> ›
		{{ brand.title }}
	</p>

	{% if brand.description %}
		<p class="wide">{{ brand.description }}</p>
	{% endif %}

	{% if products %}

		<ul class="unstyled products">

			{% for product in products %}
				{{ generic_macros.product_list(product) }}
			{% endfor %}

		</ul>

		{{ pagination("brand:#{brand.id} limit:#{products_per_page_catalog}") }}

	{% else %}
		<p class="wide">{{ 'lang.storefront.brand.no_products'|t }}</p>
	{% endif %}

{% endblock %}