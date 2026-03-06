{#
Description: Home Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set products_per_page_home = store.products_per_page_home %}
	{% set products = products("order:featured limit:#{products_per_page_home}") %}

	{% if products_per_page_home and products %}

		<h1 class="sr-only">{{ store_name }}</h1>

		<ul class="unstyled products">

			{% for product in products %}
				{{ generic_macros.product_list(product) }}
			{% endfor %}

		</ul>

	{% endif %}

{% endblock %}