{#
Description: Promotions Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set products = products("on_sale limit:#{products_per_page_catalog}") %}

	<h1 class="wide">{{ store.page.sales.title }}</h1>

	{% if store.page.sales.content %}
		<div class="wide">{{ store.page.sales.content }}</div>
	{% endif %}

	{% if products %}

		<ul class="unstyled products">

			{% for product in products %}
				{{ generic_macros.product_list(product) }}
			{% endfor %}

		</ul>

		{{ pagination("on_sale limit:#{products_per_page_catalog}") }}

	{% else %}
		<p class="wide">Não existem produtos.</p>
	{% endif %}

{% endblock %}