{#
Description: Last products page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="container">

		<h1 class="margin-top-0 margin-bottom">{{ store.page.new.title }}</h1>

		<div class="products">
			{% if store.page.new.content %}
				<div class="row">
					<div class="col-sm-12">
						<div class="page-content margin-bottom">
							{{ store.page.new.content }}
						</div>
					</div>
				</div>
			{% endif %}

			<div class="row">
				{% for product in products("new limit:#{products_per_page_catalog}") %}
					<div class="col-sm-4">
						{{ generic_macros.product_list(product) }}
					</div>
				{% else %}
					<div class="col-xs-12">
						Não existem produtos
					</div>
				{% endfor %}

			</div>
		</div>

		<nav class="text-center">
			{{ pagination("new limit:#{products_per_page_catalog}") }}
		</nav>

	</div>

{% endblock %}
