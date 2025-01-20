{#
Description: Categories list page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set categories = categories("limit:#{categories_per_page}") %}

	<h1 class="wide">{{ 'lang.storefront.categories.title'|t }}</h1>

	{% if categories %}

		<ul class="unstyled categories-list">

			{% for category in categories %}
				{{ generic_macros.category_list(category, false) }}
			{% endfor %}

		</ul>

		{{ pagination("categories limit:#{categories_per_page}") }}

	{% else %}
		<p class="wide">{{ 'lang.storefront.categories.no_categories'|t }}.</p>
	{% endif %}

{% endblock %}