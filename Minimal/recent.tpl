{# 
Description: Last products page
#}

{% extends 'base.tpl' %}

{% block content %}

	{% set products_per_page = 9 %}

	<div class="container">	

		<h1 class="margin-top-0 margin-bottom">Novidades</h1>

		<div class="products">

			<div class="row">
				{% for product in products("new limit:#{products_per_page}") %} 
					<div class="col-sm-4">
						<article class="product">

							{% if product.promo == true %}
								<span class="badge promo">Promoção</span>
							{% endif %}

							<img src="{{ product.image.square }}" class="img-responsive" alt="{{ product.title }}" title="{{ product.title }}" width="400" height="400">

							<div class="product-info">
								<a class="product-details" href="{{ product.url }}">
									<div>
										<h2>{{ product.title }}</h2>

										<span class="price">
											{% if product.price_on_request == true %}
												Preço sob consulta
											{% else %}
												{% if product.promo == true %}
													 {{ product.price_promo | money_with_sign }} <del>{{ product.price | money_with_sign }}</del>
												{% else %}
													{{ product.price | money_with_sign }}
												{% endif %}
											{% endif %}
										</span>
									</div>
								</a>
							</div>
							
						</article>
					</div>
				{% else %}
					<div class="col-xs-12">
						Não existem produtos
					</div>
				{% endfor %}

			</div>
		</div>
		
		<nav class="text-center" data-animation="fadeInUp" data-delay="0">
			{{ pagination("new limit:#{products_per_page}") }}
		</nav>

	</div>



{% endblock %}