{#
Description: Brands list page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set brands = brands("order:#{store.brands_sorting} limit:#{brands_per_page}") %}

	<div class="container">

		<div class="row">
			<div class="col-lg-3">
				<h1 class="margin-top-0 margin-bottom">Todas as marcas</h1>
			</div>

			<div class="col-lg-9">
				<div class="brands margin-top-0">
					<div class="row">

						{% for brand in brands %}
							<div class="col-xs-3 margin-bottom-lg">
								<a href="{{ brand.url }}" class="img-frame"><img src="{{ brand.image.thumb }}" class="img-responsive" alt="{{ brand.title }}" title="{{ brand.title }}"></a>
							</div>
						{% else %}
							<div class="col-xs-12">
								<h3 class="margin-bottom-lg margin-top-0 text-gray light">Não existem marcas</h3>
							</div>
						{% endfor %}

					</div>
				</div>

				<nav class="text-center">
					{{ pagination("brands limit:#{brands_per_page}") }}
				</nav>

			</div>
		</div>

	</div>

{% endblock %}
