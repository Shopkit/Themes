{#
Description: Last products page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="{{ layout_container }}">

		<h1 class="margin-top-0 margin-bottom">{{ store.page.new.title }}</h1>

		<div class="products">
			{% if store.page.new.content %}
				<div class="row">
					<div class="col-sm-12">
						<div class="page-content margin-bottom">
							{{ store.page.new.content }}
						</div>
					</div>
				</div>
			{% endif %}

			<div class="row">
				{% for product in products("new limit:#{products_per_page_catalog}") %}
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
						{{ 'lang.storefront.product_list.no_products'|t }}
					</div>
				{% endfor %}

			</div>
		</div>

		<nav class="text-center">
			{{ pagination("new limit:#{products_per_page_catalog}") }}
		</nav>

	</div>

{% endblock %}
