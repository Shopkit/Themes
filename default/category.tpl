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
	<p>{{ category.description }}</p>
	<hr>

	{% set category_default_order = store.category_default_order|default('position') %}

	{% set products = products("order:#{category_default_order} category:#{category.id} limit:9") %}

	{% if products %}

		<div class="row products">

			{% for product in products %}

				<div class="span3 product product-id-{{ product.id }}" data-id="{{ product.id }}">
					<a href="{{ product.url }}"><img src="{{ product.image.full }}" alt="{{ product.title|e_attr }}" title="{{ product.title|e_attr }}"></a>
					<div class="box">
						<h3><a href="{{ product.url }}">{{ product.title }}</a></h3>

						<p>{{ product.description_short }}</p>

						<span class="price">

							{% if product.price_on_request == true %}
								Preço sob consulta
							{% else %}
								{% if product.promo == true %}
									<del>{{ product.price | money_with_sign }}</del> &nbsp; {{ product.price_promo | money_with_sign }}
								{% else %}
									{{ product.price | money_with_sign }}
								{% endif %}
							{% endif %}

						</span>
					</div>
				</div>

			{% else %}

				<div class="span9 product">
					<h5>Não existem produtos.</h5>
				</div>

			{% endfor %}

			<div class="span9 product">
				<hr>
				{{ pagination("category:#{category.id} limit:9") }}
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