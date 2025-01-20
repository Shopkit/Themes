{#
Description: Categories list page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set categories = categories("limit:#{categories_per_page}") %}

	<ul class="breadcrumb well-default">
		<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
		<li class="active">{{ 'lang.storefront.categories.title'|t }}</li>
	</ul>

	<h1>{{ 'lang.storefront.categories.title'|t }}</h1>
	<hr>

	<div class="row categories">

		{% for category in categories %}
			{{ generic_macros.category_list(category, false) }}
		{% else %}

			<div class="span9 category">
				<h5>{{ 'lang.storefront.categories.no_categories'|t }}.</h5>
			</div>

		{% endfor %}

		<div class="span9">
			<hr>

			{{ pagination("categories limit:#{categories_per_page}") }}
		</div>

	</div>

{% endblock %}