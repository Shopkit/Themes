{#
Description: Promotions Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb well-default">
		<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
		<li class="active">{{ store.page.sales.title }}</li>
	</ul>

	<h1>{{ store.page.sales.title }}</h1>
	<p>{{ store.page.sales.content }}</p>
	<hr>

	<div class="row products">

		{% for product in products("on_sale limit:#{products_per_page_catalog}") %}

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

			{{ pagination("on_sale limit:#{products_per_page_catalog}") }}

		</div>

	</div>

{% endblock %}