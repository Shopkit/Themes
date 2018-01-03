{#
Description: Last products page
#}

{% extends 'base.tpl' %}

{% block content %}

	{% set products = products('new limit:12') %}

	<h1 class="wide">{{ store.page.new.title }}</h1>

	{% if store.page.new.content %}
		<div class="wide">{{ store.page.new.content }}</div>
	{% endif %}

	{% if products %}

		<ul class="unstyled products">

			{% for product in products %}
				<li class="product-id-{{ product.id }}">
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

		{{ pagination("new limit:12") }}

	{% else %}
		<p class="wide">Não existem produtos.</p>
	{% endif %}

{% endblock %}