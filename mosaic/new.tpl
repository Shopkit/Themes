{#
Description: Last products page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set products = products("new limit:#{products_per_page_catalog}") %}

	<h1 class="wide">{{ store.page.new.title }}</h1>

	{% if store.page.new.content %}
		<div class="wide">{{ store.page.new.content }}</div>
	{% endif %}

	{% if products %}

		<ul class="unstyled products">

			{% for product in products %}
				{{ generic_macros.product_list(product) }}
			{% endfor %}

		</ul>

		{{ pagination("new limit:#{products_per_page_catalog}") }}

	{% else %}
		<p class="wide">Não existem produtos.</p>
	{% endif %}

{% endblock %}