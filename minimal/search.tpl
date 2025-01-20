{#
Description: Search Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{#  Setup order #}
	{% set order_options = { 'relevance' : 'lang.storefront.layout.order_options.position'|t, 'title' : 'lang.storefront.layout.order_options.title'|t, 'newest' : 'lang.storefront.layout.order_options.newest'|t, 'sales' : 'lang.storefront.layout.order_options.sales'|t, 'price_asc' : 'lang.storefront.layout.order_options.price_asc'|t, 'price_desc' : 'lang.storefront.layout.order_options.price_desc'|t, 'stock_desc' : 'lang.storefront.layout.order_options.stock_desc'|t, 'stock_asc' : 'lang.storefront.layout.order_options.stock_asc'|t, 'rating' : 'lang.storefront.layout.order_options.rating'|t } %}

	{% if not get.order_by in order_options|keys %}
		{% set get = {'order_by': store.theme_options.search_default_order} %}
	{% endif %}

	{% set search = products("search order:#{get.order_by} limit:#{products_per_page_catalog}") %}

	{% set total_products = search.total_results %}
	{% set cur_page = (pagination_segment / products_per_page_catalog) + 1 %}
	{% set cur_page_from = pagination_segment + 1 %}
	{% set cur_page_to = (cur_page * products_per_page_catalog) < search.total_results ? cur_page * products_per_page_catalog : search.total_results %}

	<div class="{{ layout_container }}">

		<div class="row">

			<div class="col-sm-12 col-md-3">
				<h1 class="margin-top-0">{{ 'lang.storefront.search.title'|t }}</h1>
				{% if search.results %}
					<p>{{ 'lang.storefront.search.results'|t([cur_page_from, cur_page_to, total_products, search.query]) }}</p>
				{% else %}
					<p>{{ 'lang.storefront.search.results.variant'|t([search.total_results, search.query]) }}</p>
				{% endif %}

				{% if search.results %}
					{{ generic_macros.order_by(get, order_options, site_url("search?q=#{search.query}&")) }}
				{% endif %}
			</div>

			<div class="col-sm-12 col-md-9">

				<div class="products">
					<div class="row">

						{% for product in search.results %}
							<div class="col-xs-{{ mobile_products_per_row }} col-sm-4 col-md-{{ 12 / products_per_row }}">
								{{ generic_macros.product_list(product) }}
							</div>

							{% if loop.index0 % products_per_row == (products_per_row - 1) %}
								<div class="clearfix hidden-xs hidden-sm"></div>
							{% endif %}
							{% if loop.index0 % 3 == 2 %}
								<div class="clearfix visible-sm"></div>
							{% endif %}
							{% if mobile_products_per_row == '6' and (loop.index % 2 == 0) %}
								<div class="clearfix visible-xs"></div>
							{% endif %}
						{% else %}
							<div class="col-xs-12">
								<h3 class="margin-bottom-lg margin-top-0 text-muted-dark light">{{ 'lang.storefront.product_list.no_products'|t }}</h3>
							</div>
						{% endfor %}

					</div>
				</div>

			</div>

		</div>

		<nav class="text-center">
			{{ pagination("search limit:#{products_per_page_catalog}") }}
		</nav>

	</div>

{% endblock %}
