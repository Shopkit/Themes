{#
Description: Promotions Page
#}

{% extends 'base.tpl' %}

{% block content %}

	{% set products_per_page = 9 %}

	<div class="container">

		<h1 class="margin-top-0 margin-bottom">{{ store.page.sales.title }}</h1>

		<div class="products">
			{% if store.page.sales.content %}
				<div class="row">
					<div class="col-sm-12">
						<div class="page-content margin-bottom">
							{{ store.page.sales.content }}
						</div>
					</div>
				</div>
			{% endif %}

			<div class="row">
				{% for product in products("on_sale limit:#{products_per_page}") %}
					<div class="col-sm-4">
						<article class="product product-id-{{ product.id }}">

							<a href="{{ product.url }}"><img src="{{ product.image.square }}" class="img-responsive" alt="{{ product.title|e_attr }}" title="{{ product.title|e_attr }}" width="400" height="400"></a>

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

		<nav class="text-center">
			{{ pagination("on_sale limit:#{products_per_page}") }}
		</nav>

	</div>

{% endblock %}