{#
Description: Home Page
#}

{% extends 'base.tpl' %}

{% block content %}

	{% set products = products('featured limit:12') %}

	{% if products %}

		<ul class="unstyled products">

			{% for product in products %}
				<li class="product-id-{{ product.id }}">
					<a href="{{ product.url }}">
						<img src="{{ product.image.square }}" alt="{{ product.title }}" title="{{ product.title }}">
					</a>

					<a href="{{ product.url }}" class="description">
						<h3>{{ product.title }}</h3>

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
							<button class="button white"><i class="fa fa-shopping-cart"></i><span>Comprar</span></button>
						{% elseif product.option_groups %}
							<button class="button white"><i class="fa fa-plus-square"></i><span>Opções</span></button>
						{% else %}
							<button class="button white"><i class="fa fa-plus-square"></i><span>Info</span></button>
						{% endif %}

						<p class="category">{{ product.categories[0].title }}</p>

					</a>
				</li>
			{% endfor %}

		</ul>

	{% else %}
		<p class="wide">Não existem produtos em destaque.</p>
	{% endif %}

{% endblock %}