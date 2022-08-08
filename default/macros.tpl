{# Macros #}
{% macro product_list(product) %}
	{% import _self as generic_macros %}

	{% set product_title = product.title|e_attr %}
	{% set product_url = product.url %}

	<div class="product product-id-{{ product.id }}" data-id="{{ product.id }}">

		<a href="{{ product_url }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image.full }}" alt="{{ product_title }}" title="{{ product_title }}" class="lazy"></a>
		<div class="box">
			<h3><a href="{{ product_url }}">{{ product.title }}</a></h3>

			<p>{{ product.description_short }}</p>

			<span class="price">
				{% if product.price_on_request == true %}
					Preço sob consulta
				{% else %}
					{% if product.promo == true %}
						<del>{{ product.price | money_with_sign }}</del> &nbsp; {{ product.price_promo | money_with_sign }}
					{% else %}
						{{ product.price | money_with_sign }}
					{% endif %}
				{% endif %}
			</span>
		</div>
	</div>
{% endmacro %}

{% macro category_list(category, show_number_products = true) %}
	{% import _self as generic_macros %}

	{% set category_title = category.title|e_attr %}
	{% set category_url = category.url %}

	<div class="span3 category category-id-{{ category.id }}">
		<a href="{{ category_url }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ category.image.full }}" alt="{{ category_title }}" title="{{ category_title }}" class="lazy"></a>
		<div class="box">
			<h3><a href="{{ category_url }}">{{ category_title }}</a></h3>
			{% if not category.parent == 0 and category.children and show_number_products %}
				<span>{{ category.children|length }} Categorias</span>
			{% elseif show_number_products %}
				<span class="total-products">{{ category.total_products }} Produtos</span>
			{% endif %}
		</div>
	</div>
{% endmacro %}