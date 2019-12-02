{#
Description: Home Page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="container">

		<ul class="social">
			{% if store.facebook %}
				<li><a href="{{ store.facebook }}" target="_blank" title="Facebook"><i class="fa fa-facebook fa-fw"></i></a></li>
			{% endif %}

			{% if store.twitter %}
				<li><a href="{{ store.twitter }}" target="_blank" title="Twitter"><i class="fa fa-twitter fa-fw"></i></a></li>
			{% endif %}

			{% if store.instagram %}
				<li><a href="{{ store.instagram }}" target="_blank" title="Instagram"><i class="fa fa-instagram fa-fw"></i></a></li>
			{% endif %}

			{% if store.pinterest %}
				<li><a href="{{ store.pinterest }}" target="_blank" title="Pinterest"><i class="fa fa-pinterest fa-fw"></i></a></li>
			{% endif %}
		</ul>

		{% if store.images_header %}
			<section class="slideshow slideshow-home">
				<div class="loader"><i class="fa fa-circle-o-notch fa-spin"></i></div>
				<div class="flexslider">
					<ul class="slides">
						{% for image_header in store.images_header %}
							<li class="slide" style="background-image:url({{ image_header }})"></li>
						{% endfor %}
					</ul>
				</div>

				{% if store.description %}
					<div class="store-description">
						{{ store.description }}
					</div>
				{% endif %}
			</section>
		{% endif %}

		<div class="products">
			<div class="row">

				{% for product in products('order:featured limit:9') %}
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
					<div class="col-xs-12 padding-bottom-lg text-center">
						<h3 class="margin-top-0 text-gray light">Não existem produtos</h3>
					</div>
				{% endfor %}

			</div>
		</div>

	</div>

{% endblock %}