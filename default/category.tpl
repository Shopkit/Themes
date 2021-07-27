{#
Description: Product category page
#}

{% import 'base.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{#  Parent category #}
	{% if category.is_parent %}
		{% set parent_category = category %}
		{% set is_parent = true %}

		{% if category.parent %}
			{% set main_parent = category(category.parent) %}
		{% else %}
			{% set main_parent = category %}
		{% endif %}
	{% else %}
		{% set parent_category = category(category.parent) %}
		{% set main_parent = category(parent_category.parent) ?: parent_category %}
	{% endif %}

	{#  Setup order #}
	{% set order_options = { 'position' : 'Relevância', 'title' : 'Título', 'newest' : 'Mais recentes', 'sales' : 'Mais vendidos', 'price_asc' : 'Mais baratos', 'price_desc' : 'Mais caros', 'stock_desc' : 'Mais stock', 'stock_asc' : 'Menos stock' } %}

	{% if not get.order_by in order_options|keys %}
		{% set get = {'order_by': store.category_default_order|default('position')} %}
	{% endif %}

	{% set products = products("order:#{get.order_by} category:#{category.id} limit:#{products_per_page_catalog}") %}

	<ul class="breadcrumb">
		<li><a href="{{ site_url() }}">Home</a><span class="divider">›</span></li>
		{% if main_parent and main_parent.id != category.id %}
			<li>
				<a href="{{ main_parent.url }}">{{ main_parent.title }}</a><span class="divider">›</span>
			</li>
		{% endif %}
		{% if category.id != parent_category.id and parent_category.is_parent and parent_category.is_child %}
			<li>
				<a href="{{ parent_category.url }}">{{ parent_category.title }}</a><span class="divider">›</span>
			</li>
		{% endif %}
		<li class="active">{{ category.title }}</li>
	</ul>

	<h1>{{ category.title }}</h1>

	{% if products %}
		<div class="order-options">
			<small>Ordenar por</small> &nbsp;

			<div class="btn-group">
				<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">
					{% if get.order_by and order_options[get.order_by] %}
						{{ order_options[get.order_by] }}
					{% else %}
						{{ order_options['position'] }}
					{% endif %}
					<span class="caret"></span>
				</button>

				<ul class="dropdown-menu pull-right" role="menu">
					{% for order_option, order_title in order_options %}
						{% if order_option != get.order_by %}
							<li><a href="{{ category.url }}?order_by={{ order_option }}">{{ order_title }}</a></li>
						{% endif %}
					{% endfor %}
				</ul>
			</div>
		</div>
	{% endif %}

	<p>{{ category.description }}</p>
	<hr>

	{% if products %}

		<div class="row products">

			{% for product in products %}
				{{ generic_macros.product_list(product) }}
			{% else %}

				<div class="span9 product">
					<h5>Não existem produtos.</h5>
				</div>

			{% endfor %}

			<div class="span9 product">
				<hr>
				{{ pagination("category:#{category.id} limit:#{products_per_page_catalog}") }}
			</div>

		</div>

	{% elseif is_parent and parent_category.children %}

		<div class="row categories">
			{% for category in parent_category.children %}
				{{ generic_macros.category_list(category) }}
			{% endfor %}
		</div>

	{% else %}
		<div class="row products">
			<div class="span9 product">
				<h5>Não existem produtos.</h5>
			</div>
		</div>
	{% endif %}

{% endblock %}