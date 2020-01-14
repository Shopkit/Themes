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

	{% set category_default_order = store.category_default_order|default('position') %}

	{% set products = products("order:#{category_default_order} category:#{category.id} limit:12") %}

	<h1 class="wide">{{ category.title }}</h1>

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
				<li class="product-id-{{ product.id }}">
					<img src="{{ product.image.square }}" alt="{{ product.title|e_attr }}" title="{{ product.title|e_attr }}">

					<div class="description">
						<h3><a href="{{ product.url }}">{{ product.title }}</a></h3>

						<span class="price">

						{% if product.price_on_request == true %}
							Preço sob consulta
						{% else %}
							{% if product.promo == true %}
								{{ product.price_promo | money_with_sign }} &nbsp; <del>{{ product.price | money_with_sign }}</del>
							{% else %}
								{{ product.price | money_with_sign }}
							{% endif %}
						{% endif %}

						</span>

						{% if product.status == 1 and product.price_on_request == false and not product.option_groups %}
							<a href="{{ product.url }}" class="button white"><i class="fa fa-shopping-cart"></i><span>Comprar</span></a>
						{% elseif product.option_groups %}
							<a href="{{ product.url }}" class="button white"><i class="fa fa-plus-square"></i><span>Opções</span></a>
						{% else %}
							<a href="{{ product.url }}" class="button white"><i class="fa fa-plus-square"></i><span>Info</span></a>
						{% endif %}

						<p class="category">{{ product.categories[0].title }}</p>

					</div>

				</li>
			{% endfor %}

		</ul>

		{{ pagination("category:#{category.id} limit:12") }}

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