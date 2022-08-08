{#
Description: Last products page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb">
		<li><a href="{{ site_url() }}">Home</a><span class="divider">›</span></li>
		<li class="active">{{ store.page.new.title }}</li>
	</ul>

	<h1>{{ store.page.new.title }}</h1>
	<p>{{ store.page.new.content }}</p>
	<hr>

	<div class="row products">

		{% for product in products("new limit:#{products_per_page_catalog}") %}

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

			{{ pagination("new limit:#{products_per_page_catalog}") }}

		</div>

	</div>

{% endblock %}