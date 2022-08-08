{#
Description: Product tag page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb">
		<li><a href="{{ site_url() }}">Home</a><span class="divider">›</span></li>
		<li class="active">{{ tag.title }}</li>
	</ul>

	<h1>{{ tag.title }}</h1>
	<p>{{ tag.description }}</p>
	<hr>

	{% set category_default_order = store.category_default_order|default('position') %}

	{% set products = products("order:#{category_default_order} tag:#{tag.handle} limit:#{products_per_page_catalog}") %}

	{% if products %}

		<div class="row products">

			{% for product in products %}

				<div class="span3">
					{{ generic_macros.product_list(product) }}
				</div>

			{% else %}

				<div class="span9 product">
					<h5>Não existem produtos.</h5>
				</div>

			{% endfor %}

			<div class="span9 product">
				<hr>
				{{ pagination("tag:#{tag.handle} limit:#{products_per_page_catalog}") }}
			</div>

		</div>

	{% else %}
		<div class="row products">
			<div class="span9 product">
				<h5>Não existem produtos.</h5>
			</div>
		</div>
	{% endif %}

{% endblock %}