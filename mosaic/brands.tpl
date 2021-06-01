{#
Description: Brands list page
#}

{% import 'base.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set brands = brands("limit:#{brands_per_page}") %}

	<h1 class="wide">Todas as marcas</h1>

	{% if brands %}

		<ul class="unstyled brands-list">

			{% for brand in brands %}
				<li class="brand-id-{{ brand.id }}">
					<img src="{{ brand.image.square }}" alt="{{ brand.title }}" title="{{ brand.title }}">
					<div class="description">
						<h3><a href="{{ brand.url }}">{{ brand.title }}</a></h3>

						<a href="{{ brand.url }}" class="button white"><span>Explorar</span></a>
					</div>
				</li>
			{% endfor %}

		</ul>

		{{ pagination("brands limit:#{brands_per_page}") }}

	{% else %}
		<p class="wide">Não existem marcas.</p>
	{% endif %}

{% endblock %}