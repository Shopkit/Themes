{#
Description: Categories list page
#}

{% import 'base.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set categories_per_page = 18 %}

	{% set categories = categories("limit:#{categories_per_page}") %}

	<ul class="breadcrumb">
		<li><a href="{{ site_url() }}">Home</a><span class="divider">›</span></li>
		<li class="active">Todas as categorias</li>
	</ul>

	<h1>Todas as categorias</h1>
	<hr>

	<div class="row categories">

		{% for category in categories %}
			{{ generic_macros.category_list(category, false) }}
		{% else %}

			<div class="span9 category">
				<h5>Não existem categorias.</h5>
			</div>

		{% endfor %}

		<div class="span9">
			<hr>

			{{ pagination("categories limit:#{categories_per_page}") }}
		</div>

	</div>

{% endblock %}