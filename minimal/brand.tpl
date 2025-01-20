{#
Description: Product brand page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{#  Setup order #}
	{% set order_options = { 'position' : 'lang.storefront.layout.order_options.position'|t, 'title' : 'lang.storefront.layout.order_options.title'|t, 'newest' : 'lang.storefront.layout.order_options.newest'|t, 'sales' : 'lang.storefront.layout.order_options.sales'|t, 'price_asc' : 'lang.storefront.layout.order_options.price_asc'|t, 'price_desc' : 'lang.storefront.layout.order_options.price_desc'|t, 'stock_desc' : 'lang.storefront.layout.order_options.stock_desc'|t, 'stock_asc' : 'lang.storefront.layout.order_options.stock_asc'|t, 'rating' : 'lang.storefront.layout.order_options.rating'|t } %}

	{% if not get.order_by in order_options|keys %}
		{% set get = {'order_by': store.category_default_order|default('position')} %}
	{% endif %}

	{% set products = products("order:#{get.order_by} brand:#{brand.id} limit:#{products_per_page_catalog}") %}

	<div class="{{ layout_container }}">
		<div class="row">
			<div class="col-lg-3">

				<h1 class="margin-top-0 margin-bottom"><a href="{{ brand.url }}" class="link-inherit">{{ brand.title }}</a></h1>

				<ol class="breadcrumb">
					<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a></li>
					<li><a href="{{ site_url('brands') }}">{{ 'lang.storefront.brand.title'|t }}</a></li>
					<li class="active">
						<a href="{{ brand.url }}"><span>{{ brand.title }}</span></a>
					</li>
				</ol>

				{% if brand.description %}
					<div class="description">{{ brand.description }}</div>
				{% endif %}

				{% if products %}
					{{ generic_macros.order_by(get, order_options, brand.url ~ '?') }}
				{% endif %}

			</div>

			<div class="col-lg-9">
				{% if products %}
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
							{% endfor %}

						</div>
					</div>

					<nav class="text-center">
						{{ pagination("brand:#{brand.id} limit:#{products_per_page_catalog}") }}
					</nav>

				{% else %}
					<div class="col-xs-12">
						<h3 class="margin-bottom-lg margin-top-0 text-muted-dark light">{{ 'lang.storefront.brand.no_products'|t }}</h3>
					</div>
				{% endif %}

			</div>
		</div>
	</div>

{% endblock %}
