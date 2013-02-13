{# 
Description: Home Page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="row products">

		{% for product in products('order:featured') %} 

			<div class="span3 product">
				<a href="{{ product.url }}"><img src="{{ product.image.full }}" alt="{{ product.title }}" title="{{ product.title }}"></a>
				<div class="box">
					<h3><a href="{{ product.url }}">{{ product.title }}</a></h3>
					
					<p>{{ product.description_short }}</p>
					
					<span class="price">
						{% if product.promo == true %}
							<del>&euro; {{ product.price }}</del> &nbsp; &euro;  {{ product.price_promo }}
						{% else %}
							&euro;  {{ product.price }}
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