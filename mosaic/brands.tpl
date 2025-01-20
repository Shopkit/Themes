{#
Description: Brands list page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set brands = brands("order:#{store.brands_sorting} limit:#{brands_per_page}") %}

	<h1 class="wide">{{ 'lang.storefront.brands.title'|t }}</h1>

	{% if brands %}

		<ul class="unstyled brands-list">

			{% for brand in brands %}
				<li class="brand-id-{{ brand.id }}">
					<img src="{{ brand.image.square }}" alt="{{ brand.title }}" title="{{ brand.title }}">
					<div class="description">
						<h3><a href="{{ brand.url }}">{{ brand.title }}</a></h3>

						<a href="{{ brand.url }}" class="button btn-primary {{ store.theme_options.button_primary_shadow }}"><span>{{ 'lang.storefront.macros.button.explore'|t }}</span></a>
					</div>
				</li>
			{% endfor %}

		</ul>

		{{ pagination("brands limit:#{brands_per_page}") }}

	{% else %}
		<p class="wide">{{ 'lang.storefront.brands.no_brands'|t }}.</p>
	{% endif %}

{% endblock %}