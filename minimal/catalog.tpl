{#
Description: Product catalog page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{#  Setup order #}
	{% set order_options = { 'position' : 'lang.storefront.layout.order_options.position'|t, 'title' : 'lang.storefront.layout.order_options.title'|t, 'newest' : 'lang.storefront.layout.order_options.newest'|t, 'sales' : 'lang.storefront.layout.order_options.sales'|t, 'price_asc' : 'lang.storefront.layout.order_options.price_asc'|t, 'price_desc' : 'lang.storefront.layout.order_options.price_desc'|t, 'stock_desc' : 'lang.storefront.layout.order_options.stock_desc'|t, 'stock_asc' : 'lang.storefront.layout.order_options.stock_asc'|t, 'rating' : 'lang.storefront.layout.order_options.rating'|t } %}

	{% if not get.order_by in order_options|keys %}
		{% set get = {'order_by': store.category_default_order|default('position')} %}
	{% endif %}

	{% set products = products("order:#{get.order_by} limit:#{products_per_page_catalog}") %}

	<div class="{{ layout_container }}">

		<div class="row">
			<div class="col-lg-3">

				<h1 class="margin-top-0 margin-bottom">{{ 'lang.storefront.catalog.title'|t }}</h1>

				{% if products %}
					{{ generic_macros.order_by(get, order_options, site_url("catalog?")) }}
				{% endif %}
			</div>

			<div class="col-lg-9">
				<div class="products margin-top-0">
					<div class="row">

						{% for product in products %}
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

				<nav class="text-center">
					{{ pagination("products limit:#{products_per_page_catalog}") }}
				</nav>

			</div>
		</div>

	</div>

{% endblock %}
