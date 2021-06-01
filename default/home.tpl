{#
Description: Home Page
#}

{% import 'base.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="row products">

		{% for product in products("order:featured limit:#{products_per_page_home}") %}
			{{ generic_macros.product_list(product) }}
		{% else %}

			<div class="span9 product">
				<h5>Não existem produtos.</h5>
			</div>

		{% endfor %}

	</div>

{% endblock %}