{#
Description: Last products page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb well-default">
		<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
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
				<h5>{{ 'lang.storefront.product_list.no_products'|t }}.</h5>
			</div>

		{% endfor %}

		<div class="span9 product">

			<hr>

			{{ pagination("new limit:#{products_per_page_catalog}") }}

		</div>

	</div>

{% endblock %}