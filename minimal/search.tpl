{#
Description: Search Page
#}

{% extends 'base.tpl' %}

{% block content %}

	{% set products_per_page = 9 %}

	<div class="container">

		<div class="row">

			<div class="col-sm-12 col-md-3">
				<h1 class="margin-top-0">Pesquisa</h1>
				<p>Resultados de produtos para a pesquisa: <em>{{ search.query }}</em></p>
			</div>

			<div class="col-sm-12 col-md-9">

				<div class="products">
					<div class="row">

						{% for product in products("search order:featured limit:#{products_per_page}") %}
							<div class="col-sm-4">
								<article class="product product-id-{{ product.id }}">

									{% if product.status_alias == 'out_of_stock' %}
										<span class="badge out_of_stock">Sem stock</span>
									{% elseif product.promo == true %}
										<span class="badge promo">Promoção</span>
									{% endif %}

									<a href="{{ product.url }}"><img src="{{ product.image.square }}" class="img-responsive" alt="{{ product.title }}" title="{{ product.title }}" width="400" height="400"></a>

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
								<h3 class="margin-bottom-lg margin-top-0 text-gray light">Não existem produtos</h3>
							</div>
						{% endfor %}

					</div>
				</div>

			</div>

		</div>

		<nav class="text-center">
			{{ pagination("search limit:#{products_per_page}") }}
		</nav>

	</div>

{% endblock %}