{#
Description: Brands list page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set brands = brands("order:#{store.brands_sorting} limit:#{brands_per_page}") %}
	{% set card_hover_effect = store.theme_options.card_hover_effect != 'none' ? store.theme_options.card_hover_effect : '' %}
	{% set card_thumbnail_type = store.theme_options.catalog_thumbail_type == 'square' ? 'square' : 'thumb' %}

	<ul class="breadcrumb well-default">
		<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
		<li class="active">{{ 'lang.storefront.brands.title'|t }}</li>
	</ul>

	<h1>{{ 'lang.storefront.brands.title'|t }}</h1>
	<hr>

	<div class="row brands">

		{% for brand in brands %}
			<div class="span3 brand brand-id-{{ brand.id }} {{ card_hover_effect }}">
				<div class="{{ store.theme_options.card_shadow }}">
					<a href="{{ brand.url }}"><img src="{{ brand.image[card_thumbnail_type] }}" alt="{{ brand.image.alt ? brand.image.alt : brand.title }}" title="{{ brand.title }}"></a>
					<div class="box">
						<h3><a href="{{ brand.url }}">{{ brand.title }}</a></h3>
					</div>
				</div>
			</div>
		{% else %}

			<div class="span9 brand">
				<h5>{{ 'lang.storefront.brands.no_brands'|t }}.</h5>
			</div>

		{% endfor %}

		<div class="span9">
			<hr>

			{{ pagination("brands limit:#{brands_per_page}") }}
		</div>

	</div>

{% endblock %}