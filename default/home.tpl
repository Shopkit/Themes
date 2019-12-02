{# 
Description: Home Page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="row products">

		{% for product in products('order:featured') %} 

			<div class="span3 product product-id-{{ product.id }}">
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

	</div>

{% endblock %}