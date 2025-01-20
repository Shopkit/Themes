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

	<div class="{{ layout_container }}">

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
				{% set order_options = { 'position' : 'lang.storefront.layout.order_options.position'|t, 'title' : 'lang.storefront.layout.order_options.title'|t, 'newest' : 'lang.storefront.layout.order_options.newest'|t, 'sales' : 'lang.storefront.layout.order_options.sales'|t, 'price_asc' : 'lang.storefront.layout.order_options.price_asc'|t, 'price_desc' : 'lang.storefront.layout.order_options.price_desc'|t, 'stock_desc' : 'lang.storefront.layout.order_options.stock_desc'|t, 'stock_asc' : 'lang.storefront.layout.order_options.stock_asc'|t, 'rating' : 'lang.storefront.layout.order_options.rating'|t } %}

				{% if not get.order_by in order_options|keys %}
					{% set get = {'order_by': store.category_default_order|default('position')} %}
				{% endif %}

				{% set products = products("order:#{get.order_by} category:#{category.id} limit:#{products_per_page_catalog}") %}

				{% if products %}
					{{ generic_macros.order_by(get, order_options, category.url ~ '?') }}
				{% endif %}

				{% if main_parent.children %}
					<div class="panel well-featured {{ store.theme_options.well_featured_shadow }} panel-default margin-bottom panel-categories">

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
						{{ pagination("category:#{category.id} limit:#{products_per_page_catalog}") }}
					</nav>

				{% elseif is_parent and parent_category.children %}
					<div class="categories margin-top-0">
						<div class="row">

							{% for category in parent_category.children %}
								<div class="col-xs-{{ 12 / mobile_categories_per_row }} col-sm-4 col-md-{{ 12 / categories_per_row }}">
									{{ generic_macros.category_list(category) }}
								</div>
								{% if loop.index0 % categories_per_row == (categories_per_row - 1) %}
									<div class="clearfix hidden-xs"></div>
								{% endif %}
								{% if mobile_categories_per_row == 2 and (loop.index % 2 == 0) %}
                        			<div class="clearfix visible-xs"></div>
                    			{% endif %}
							{% endfor %}

						</div>
					</div>

				{% else %}
					<div class="col-xs-12">
						<h3 class="margin-bottom-lg margin-top-0 text-muted-dark light">{{ 'lang.storefront.category.no_products'|t }}</h3>
					</div>
				{% endif %}

			</div>
		</div>

	</div>

{% endblock %}
