{#
Description: Categories list page
#}

{% import 'base.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set categories = categories("limit:#{categories_per_page}") %}

	<div class="container">

		<div class="row">
			<div class="col-lg-3">
				<h1 class="margin-top-0 margin-bottom">Todas as categorias</h1>
			</div>

			<div class="col-lg-9">
				<div class="categories margin-top-0">
					<div class="row">

						{% for category in categories %}
							<div class="col-sm-4">
								{{ generic_macros.category_list(category, false) }}
							</div>

							{% if loop.index0%3 == 2 %}
								<div class="clearfix hidden-xs"></div>
							{% endif %}
						{% else %}
							<div class="col-xs-12">
								<h3 class="margin-bottom-lg margin-top-0 text-gray light">Não existem categorias</h3>
							</div>
						{% endfor %}

					</div>
				</div>

				<nav class="text-center">
					{{ pagination("categories limit:#{categories_per_page}") }}
				</nav>

			</div>
		</div>

	</div>

{% endblock %}