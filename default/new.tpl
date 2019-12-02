{#
Description: Last products page
#}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb">
		<li><a href="{{ site_url() }}">Home</a><span class="divider">›</span></li>
		<li class="active">{{ store.page.new.title }}</li>
	</ul>

	<h1>{{ store.page.new.title }}</h1>
	<p>{{ store.page.new.content }}</p>
	<hr>

	<div class="row products">

		{% for product in products('new limit:9') %}

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

			{{ pagination('new limit:9') }}

		</div>

	</div>

{% endblock %}