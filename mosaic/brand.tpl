{#
Description: Product brand page
#}

{% import 'base.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set category_default_order = store.category_default_order|default('position') %}

	{% set products = products("order:#{category_default_order} brand:#{brand.id} limit:#{products_per_page_catalog}") %}

	<h1 class="wide">{{ brand.title }}</h1>

	<p class="breadcrumbs wide">
		<a href="{{ site_url() }}"><i class="fa fa-home"></i></a> ›
		<a href="{{ site_url('brands') }}">Marcas</a> ›
		{{ brand.title }}
	</p>

	{% if brand.description %}
		<p class="wide">{{ brand.description }}</p>
	{% endif %}

	{% if products %}

		<ul class="unstyled products">

			{% for product in products %}
				<li class="product-id-{{ product.id }}" data-id="{{ product.id }}">
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

					</div>

				</li>
			{% endfor %}

		</ul>

		{{ pagination("brand:#{brand.id} limit:#{products_per_page_catalog}") }}

	{% else %}
		<p class="wide">Não existem produtos.</p>
	{% endif %}

{% endblock %}