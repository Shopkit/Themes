{#
Description: Home Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set products_per_page_home = store.products_per_page_home %}
	{% set featured_products = products("order:featured limit:#{products_per_page_home}") %}
	{% if products_per_page_home %}

		<div class="row products">

			{% for product in featured_products %}

				<div class="span3">
					{{ generic_macros.product_list(product) }}
				</div>

			{% endfor %}

		</div>
	{% else %}
		<div class="span9 product">
			<h5>{{ 'lang.storefront.product_list.no_products'|t }}.</h5>
		</div>
	{% endif %}

{% endblock %}