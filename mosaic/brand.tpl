{#
Description: Product brand page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set category_default_order = store.category_default_order|default('position') %}

	{% set products = products("order:#{category_default_order} brand:#{brand.id} limit:#{products_per_page_catalog}") %}

	<h1 class="wide">{{ brand.title }}</h1>

	<p class="breadcrumbs wide">
		<a href="{{ site_url() }}">{{ icons('home') }}</a> ›
		<a href="{{ site_url('brands') }}">{{ 'lang.storefront.brand.title'|t }}</a> ›
		{{ brand.title }}
	</p>

	<div class="brand-wide wide">
		{% if brand.description %}
			<p>{{ brand.description|nl2br }}</p>
		{% endif %}

	{% if brand.brand_url %}
        <div class="margin-top-sm"><a href="{{ brand.brand_url }}" target="_blank">{{ brand.brand_url }}</a></div>
    {% endif %}

    {% if brand.manufacturer or brand.responsible or brand.importer %}
        <div class="gpsr-brand-content margin-top ">
            <div class="margin-bottom">{{ 'lang.storefront.product.tab.gpsr.title'|t }}</div>

            {% if brand.manufacturer %}
                <div>{{ brand.manufacturer|nl2br }}</div>
            {% endif %}

            {% if brand.responsible %}
				<hr>
                <div>{{ brand.responsible|nl2br }}</div>
            {% endif %}

            {% if brand.importer %}
				<hr>
                <div>{{ brand.importer|nl2br }}</div>
            {% endif %}
        </div>
    {% endif %}
	</div>

	{% if products %}

		<ul class="unstyled products">

			{% for product in products %}
				{{ generic_macros.product_list(product) }}
			{% endfor %}

		</ul>

		{{ pagination("brand:#{brand.id} limit:#{products_per_page_catalog}") }}

	{% else %}
		<p class="wide">{{ 'lang.storefront.brand.no_products'|t }}</p>
	{% endif %}

{% endblock %}