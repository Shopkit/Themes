{#
Description: Search Page
#}

{% extends 'base.tpl' %}

{% block content %}

	{% set products_per_page = 9 %}
	{% set search = products("search limit:#{products_per_page}") %}

	{% set total_products = search.total_results %}
	{% set cur_page = (pagination_segment / products_per_page) + 1 %}
	{% set cur_page_from = pagination_segment + 1 %}
	{% set cur_page_to = (cur_page * products_per_page) < search.total_results ? cur_page * products_per_page : search.total_results %}

	<div class="container">

		<div class="row">

			<div class="col-sm-12 col-md-3">
				<h1 class="margin-top-0">Pesquisa</h1>
				{% if search.results %}
					<p>A mostrar {{ cur_page_from }}-{{ cur_page_to }} de {{ total_products }} produtos para a pesquisa: <strong><em>{{ search.query }}</em></strong></p>
				{% else %}
					<p>Foram encontrados <strong>{{ search.total_results }}</strong> produtos para a pesquisa: <strong><em>{{ search.query }}</em></strong></p>
				{% endif %}
			</div>

			<div class="col-sm-12 col-md-9">

				<div class="products">
					<div class="row">

						{% for product in search.results %}
							<div class="col-sm-4">
								<article class="product product-id-{{ product.id }}">

									{% if product.status_alias == 'out_of_stock' %}
										<span class="badge out_of_stock">Sem stock</span>
									{% elseif product.promo == true %}
										<span class="badge promo">Promoção</span>
									{% endif %}

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