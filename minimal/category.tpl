{#
Description: Product category page
#}

{% import 'macros.tpl' as generic_macros %}

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

	<div class="container">

		<div class="row">
			<div class="col-lg-3">

				<h1 class="margin-top-0 margin-bottom"><a href="{{ category.url }}" class="link-inherit">{{ category.title }}</a></h1>

				{% if category.parent %}
					<ol class="breadcrumb">

						{% if main_parent and main_parent.id != category.id %}
							<li>
								<a href="{{ main_parent.url }}"><span>{{ main_parent.title }}</span></a>
							</li>
						{% endif %}
						{% if category.id != parent_category.id and parent_category.is_parent and parent_category.is_child %}
							<li>
								<a href="{{ parent_category.url }}"><span>{{ parent_category.title }}</span></a>
							</li>
						{% endif %}
						<li class="active">
							<a href="{{ category.url }}"><span>{{ category.title }}</span></a>
						</li>

					</ol>
				{% endif %}

				{% if category.description %}
					<div class="description">{{ category.description }}</div>
				{% endif %}

				{#  Setup order #}
				{% set order_options = { 'position' : 'Relevância', 'title' : 'Título', 'newest' : 'Mais recentes', 'sales' : 'Mais vendidos', 'price_asc' : 'Mais baratos', 'price_desc' : 'Mais caros', 'stock_desc' : 'Mais stock', 'stock_asc' : 'Menos stock' } %}

				{% if not get.order_by in order_options|keys %}
					{% set get = {'order_by': store.category_default_order|default('position')} %}
				{% endif %}

				{% set products = products("order:#{get.order_by} category:#{category.id} limit:#{products_per_page_catalog}") %}

				{% if products %}
					<div class="order-options">
						<small>Ordenar por</small> &nbsp;

						<div class="btn-group">
							<button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown">
								{% if get.order_by and order_options[get.order_by] %}
									{{ order_options[get.order_by] }}
								{% else %}
									{{ order_options['position'] }}
								{% endif %}
								<span class="caret"></span>
							</button>

							<ul class="dropdown-menu" role="menu">
								{% for order_option, order_title in order_options %}
									{% if order_option != get.order_by %}
										<li><a href="{{ category.url }}?order_by={{ order_option }}">{{ order_title }}</a></li>
									{% endif %}
								{% endfor %}
							</ul>
						</div>
					</div>
				{% endif %}

				{% if main_parent.children %}
					<div class="panel panel-default margin-bottom panel-categories">

						<div class="panel-heading">
							<a href="{{ main_parent.url }}" class="link-inherit">{{ main_parent.title }}</a>
						</div>

						<div class="list-group">

							{% for sub_category in main_parent.children %}
								{% if sub_category.children %}
									<a data-toggle="collapse" href="{{ '#category_' ~ sub_category.id }}" data-href="{{ sub_category.url }}" aria-expanded="{{ (sub_category.id == category.id or sub_category.id == category.parent) ? 'true' :'false' }}" aria-controls="{{ 'category_' ~ sub_category.id }}" target="{{ '#category_' ~ sub_category.id }}" class="list-group-item {{ sub_category.id == category.id ? 'active' }}">
										{{ sub_category.title }} <span class="caret"></span>
									</a>

									<div class="nav-subcategories collapse {{ (sub_category.id == category.id or sub_category.id == category.parent) ? 'in' }}" role="menu" id="category_{{ sub_category.id }}">
										<ul >
											{% for children in sub_category.children %}
												<li  class="{{ (category.id == children.id) ? 'active' }} menu-{{ children.handle }}">
													<a href="{{ children.url }}">{{ children.title }} <span class="total-products text-muted">({{ children.total_products }})</span></a>
												</li>
											{% endfor %}
										</ul>
									</div>
								{% else %}
									<a href="{{ sub_category.url }}" class="list-group-item {{ sub_category.id == category.id ? 'active' }}">
										{{ sub_category.title }} <span class="total-products text-muted">({{ sub_category.total_products }})</span>
									</a>
								{% endif %}
							{% endfor %}

						</div>
					</div>
				{% endif %}
			</div>

			<div class="col-lg-9">
				{% if products %}
					<div class="products margin-top-0">
						<div class="row">

							{% for product in products %}
								<div class="col-sm-4">
									{{ generic_macros.product_list(product) }}
								</div>
							{% endfor %}

						</div>
					</div>

					<nav class="text-center">
						{{ pagination("category:#{category.id} limit:#{products_per_page_catalog}") }}
					</nav>

				{% elseif is_parent and parent_category.children %}
					<div class="categories margin-top-0">
						<div class="row">

							{% for category in parent_category.children %}
								<div class="col-sm-4">
									{{ generic_macros.category_list(category) }}
								</div>
								{% if loop.index0%3 == 2 %}
									<div class="clearfix hidden-xs"></div>
								{% endif %}
							{% endfor %}

						</div>
					</div>

				{% else %}
					<div class="col-xs-12">
						<h3 class="margin-bottom-lg margin-top-0 text-gray light">Não existem produtos</h3>
					</div>
				{% endif %}

			</div>
		</div>

	</div>

{% endblock %}
