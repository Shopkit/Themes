{#
Description: Search Page
#}

{% extends 'base.tpl' %}

{% block content %}

	{% set products_per_page = 12 %}
	{% set search = products("search limit:#{products_per_page}") %}

	{% set total_products = search.total_results %}
	{% set cur_page = (pagination_segment / products_per_page) + 1 %}
	{% set cur_page_from = pagination_segment + 1 %}
	{% set cur_page_to = (cur_page * products_per_page) < search.total_results ? cur_page * products_per_page : search.total_results %}

	<h1 class="wide">Pesquisa</h1>

	{% if search.results %}

		{% if search.results %}
			<p class="wide">A mostrar {{ cur_page_from }}-{{ cur_page_to }} de {{ total_products }} produtos para a pesquisa: <strong><em>{{ search.query }}</em></strong></p>
		{% else %}
			<p class="wide">Foram encontrados <strong>{{ search.total_results }}</strong> produtos para a pesquisa: <strong><em>{{ search.query }}</em></strong></p>
		{% endif %}

		<ul class="unstyled products">

			{% for product in search.results %}
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

						<p class="category">{{ product.categories[0].title }}</p>

					</div>

				</li>
			{% endfor %}

		</ul>

		{{ pagination("search limit:#{products_per_page}") }}

	{% else %}
		<p class="wide">Não existem produtos para a pesquisa: <strong><em>{{ search.query }}</em></strong></p>
	{% endif %}

{% endblock %}