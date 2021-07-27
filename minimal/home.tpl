{#
Description: Home Page
#}

{% import 'base.tpl' as generic_macros %}

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

		{% if store.gallery %}
			<section class="slideshow slideshow-home hidden-xs">
				<div class="loader"><i class="fa fa-circle-o-notch fa-spin"></i></div>
				<div class="flexslider">
					<ul class="slides">
						{% for gallery in store.gallery %}
							{% set has_slide_content = gallery.title or gallery.button or gallery.description ? 'has-slide-content' %}
							<li class="slide {{ has_slide_content }}" style="background-image:url({{ gallery.image.full }})">
								{% if has_slide_content %}
								<div class="slide-content">
									{% if gallery.title %}
										{% if gallery.link %}
											<h4 class="slide-title"><a href="{{ gallery.link }}">{{ gallery.title }}</a></h4>
										{% else %}
											<h4 class="slide-title">{{ gallery.title }}</h4>
										{% endif %}
									{% endif %}
									{% if gallery.description %}
										<div class="slide-description">{{ gallery.description }}</div>
									{% endif %}
									{% if gallery.button %}
										<div class="slide-button">
											<a href="{{ gallery.button_link }}" class="btn btn-outline-white">{{ gallery.button }}</a>
										</div>
									{% endif %}
								</div>
							{% endif %}
							</li>
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

				{% for product in products("order:featured limit:#{products_per_page_home}") %}
					<div class="col-sm-4">
						{{ generic_macros.product_list(product) }}
					</div>
				{% else %}
					<div class="col-xs-12 padding-bottom-lg text-center">
						<h3 class="margin-top-0 text-gray light">Não existem produtos</h3>
					</div>
				{% endfor %}

			</div>
		</div>

		{% if store.featured_blocks %}
			<section class="featured-blocks">
				<div class="row">
					{% for featured_block in store.featured_blocks %}
						<div class="{{ loop.first ? 'col-sm-offset-' ~ (12 - 4 * store.featured_blocks|length) / 2 }} col-sm-4 col-featured-block">
							<div class="featured-block">
								<img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ featured_block.icon }}" alt="{{ featured_block.title }}" height="40" class="lazy">
								<h4 class="bold">{{ featured_block.title }}</h4>
								<p>{{ featured_block.description }}</p>
							</div>
						</div>
					{% endfor %}
				</div>
			</section>
		{% endif %}

	</div>

{% endblock %}