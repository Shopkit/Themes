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
		{% set main_parent = category(parent_category.parent) %}
	{% endif %}

	{#  Setup order #}
	{% set order_options = { 'position' : 'Relevância', 'title' : 'Título', 'newest' : 'Mais recentes', 'sales' : 'Mais vendidos', 'price_asc' : 'Mais baratos', 'price_desc' : 'Mais caros', 'stock_desc' : 'Mais stock', 'stock_asc' : 'Menos stock' } %}

	{% if not get.order_by in order_options|keys %}
		{% set get = {'order_by': store.category_default_order|default('position')} %}
	{% endif %}

	{% set products = products("order:#{get.order_by} category:#{category.id} limit:#{products_per_page_catalog}") %}

	<div class="wide">

		<h1 class="wide">{{ category.title }}</h1>

		{% if products %}
			<div class="order-options-container">
				<div class="order-options">
					Ordenar por &nbsp;

					<div class="btn-group">
						<button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown">
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
			</div>
		{% endif %}

	</div>

	<p class="breadcrumbs wide">
		<a href="{{ site_url() }}"><i class="fa fa-home"></i></a> ›
		{% if main_parent and main_parent.id != category.id %}
			<a href="{{ main_parent.url }}">{{ main_parent.title }}</a> ›
		{% endif %}
		{% if category.id != parent_category.id and parent_category.is_parent and parent_category.is_child %}
			<a href="{{ parent_category.url }}">{{ parent_category.title }}</a> ›
		{% endif %}
		{{ category.title }}
	</p>

	{% if category.description %}
		<p class="wide">{{ category.description }}</p>
	{% endif %}

	{% if products %}

		<ul class="unstyled products">

			{% for product in products %}
				{{ generic_macros.product_list(product) }}
			{% endfor %}

		</ul>

		{{ pagination("category:#{category.id} limit:#{products_per_page_catalog}") }}

	{% elseif is_parent and parent_category.children %}

		<ul class="unstyled categories-list">
			{% for category in parent_category.children %}
				{{ generic_macros.category_list(category) }}
			{% endfor %}
		</ul>

	{% else %}
		<p class="wide">Não existem produtos.</p>
	{% endif %}

{% endblock %}