{#
Description: Search Page
#}

{% extends 'base.tpl' %}

{% block content %}

	{% set products_per_page = 12 %}
	{% set products = products("search order:featured limit:#{products_per_page}") %}

	<h1 class="wide">Pesquisa</h1>

	{% if products %}

		<p class="wide">Resultados de produtos para a pesquisa: <em>{{ search.query }}</em></p>

		<ul class="unstyled products">

			{% for product in products %}
				<li>
					<img src="{{ product.image.square }}" alt="{{ product.title }}" title="{{ product.title }}">

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
		<p class="wide">Não existem produtos para a pesquisa: <em>{{ search.query }}</em>.</p>
	{% endif %}

{% endblock %}