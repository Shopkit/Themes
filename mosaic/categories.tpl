{#
Description: Categories list page
#}

{% import 'base.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set categories = categories("limit:#{categories_per_page}") %}

	<h1 class="wide">Todas as categorias</h1>

	{% if categories %}

		<ul class="unstyled categories-list">

			{% for category in categories %}
				{{ generic_macros.category_list(category, false) }}
			{% endfor %}

		</ul>

		{{ pagination("categories limit:#{categories_per_page}") }}

	{% else %}
		<p class="wide">Não existem categorias.</p>
	{% endif %}

{% endblock %}