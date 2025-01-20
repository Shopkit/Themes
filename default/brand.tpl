{#
Description: Product brand page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb well-default">
		<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
		<li>
			<a href="{{ site_url('brands') }}">{{ 'lang.storefront.brand.title'|t }}</a><span class="divider">›</span>
		</li>
		<li class="active">{{ brand.title }}</li>
	</ul>

	<h1>{{ brand.title }}</h1>
	<p>{{ brand.description }}</p>
	<hr>

	{% set category_default_order = store.category_default_order|default('position') %}

	{% set products = products("order:#{category_default_order} brand:#{brand.id} limit:#{products_per_page_catalog}") %}

	{% if products %}

		<div class="row products">

			{% for product in products %}

				<div class="span3">
					{{ generic_macros.product_list(product) }}
				</div>

			{% else %}

				<div class="span9 product">
					<h5>{{ 'lang.storefront.brand.no_products'|t }}</h5>
				</div>

			{% endfor %}

			<div class="span9 product">
				<hr>
				{{ pagination("brand:#{brand.id} limit:#{products_per_page_catalog}") }}
			</div>

		</div>

	{% else %}
		<div class="row products">
			<div class="span9 product">
				<h5>{{ 'lang.storefront.brand.no_products'|t }}</h5>
			</div>
		</div>
	{% endif %}

{% endblock %}