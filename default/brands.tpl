{#
Description: Brands list page
#}

{% import 'base.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set brands = brands("order:#{store.brands_sorting} limit:#{brands_per_page}") %}

	<ul class="breadcrumb">
		<li><a href="{{ site_url() }}">Home</a><span class="divider">›</span></li>
		<li class="active">Todas as marcas</li>
	</ul>

	<h1>Todas as marcas</h1>
	<hr>

	<div class="row brands">

		{% for brand in brands %}
			<div class="span3 brand brand-id-{{ brand.id }}">
				<a href="{{ brand.url }}"><img src="{{ brand.image.full }}" alt="{{ brand.title }}" title="{{ brand.title }}"></a>
				<div class="box">
					<h3><a href="{{ brand.url }}">{{ brand.title }}</a></h3>
				</div>
			</div>
		{% else %}

			<div class="span9 brand">
				<h5>Não existem marcas.</h5>
			</div>

		{% endfor %}

		<div class="span9">
			<hr>

			{{ pagination("brands limit:#{brands_per_page}") }}
		</div>

	</div>

{% endblock %}