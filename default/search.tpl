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

	<ul class="breadcrumb">
		<li><a href="{{ site_url() }}">Home</a><span class="divider">›</span></li>
		<li>Pesquisa<span class="divider">›</span></li>
		<li class="active">{{ search.query }}</li>
	</ul>

	<h1>Pesquisa</h1>
	{% if search.results %}
		<p>A mostrar {{ cur_page_from }}-{{ cur_page_to }} de {{ total_products }} produtos para a pesquisa: <strong><em>{{ search.query }}</em></strong></p>
	{% else %}
		<p>Foram encontrados <strong>{{ search.total_results }}</strong> produtos para a pesquisa: <strong><em>{{ search.query }}</em></strong></p>
	{% endif %}
	<br>

	<div class="row products">

		{% for product in search.results %}

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

		<div class="span9 product">

			<hr>

			{{ pagination("search limit:#{products_per_page}") }}

		</div>

	</div>

{% endblock %}