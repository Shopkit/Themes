{#
Description: Home Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set products = products("order:featured limit:#{products_per_page_home}") %}

	{% if products %}

		<ul class="unstyled products">

			{% for product in products %}
				{{ generic_macros.product_list(product) }}
			{% endfor %}

		</ul>

	{% else %}
		<p class="wide">Não existem produtos em destaque.</p>
	{% endif %}

{% endblock %}