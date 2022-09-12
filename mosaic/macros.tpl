{# Macros #}
{% macro product_list(product) %}
	{% import _self as generic_macros %}

	{% set product_title = product.title|e_attr %}
	{% set product_url = product.url %}

	<li class="product-id-{{ product.id }} {% if product.status_alias == 'out_of_stock' %}out_of_stock{% endif %}" data-id="{{ product.id }}">
		<span class="product-badges">
			{% if product.status_alias == 'out_of_stock' %}
				<span class="out_of_stock">Sem stock</span>
			{% elseif product.status_alias == 'soon' %}
				<span class="soon">Brevemente</span>
			{% elseif product.promo == true %}
				<span class="promo">Promoção</span>
				{% if product.price_promo_percentage == true %}
					<span class="product-promo-percent promo-percentage">-<span>{{ product.price_promo_percentage }}</span>%</span>
				{% endif %}
			{% elseif product.new == true %}
				<span class="new">Novidade</span>
			{% endif %}
		</span>

		<img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image.square }}" alt="{{ product_title }}" title="{{ product_title }}" class="lazy">

		<div class="description">
			<h3><a href="{{ product_url }}">{{ product.title }}</a></h3>

			<span class="price">

			{% if product.price_on_request == true %}
				Preço sob consulta
			{% else %}
				{% if product.promo == true %}
					{{ product.price_promo | money_with_sign }} &nbsp; <del>{{ product.price | money_with_sign }}</del>
				{% else %}
					{{ product.price | money_with_sign }}
				{% endif %}
			{% endif %}

			</span>

			{% if product.status == 1 and product.price_on_request == false and not product.option_groups %}
				<a href="{{ product_url }}" class="button white"><i class="fa fa-shopping-cart"></i><span>Comprar</span></a>
			{% elseif product.option_groups %}
				<a href="{{ product_url }}" class="button white"><i class="fa fa-plus-square"></i><span>Opções</span></a>
			{% else %}
				<a href="{{ product_url }}" class="button white"><i class="fa fa-plus-square"></i><span>Info</span></a>
			{% endif %}

			<p class="category">{{ product.categories[0].title }}</p>

		</div>

	</li>
{% endmacro %}

{% macro category_list(category, show_number_products = true) %}
	{% import _self as generic_macros %}

	{% set category_title = category.title|e_attr %}
	{% set category_url = category.url %}

	<li class="category-id-{{ category.id }}">
		<img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ category.image.square }}" alt="{{ category_title }}" title="{{ category_title }}" class="lazy">
		<div class="description">
			<h3><a href="{{ category_url }}">{{ category_title }}</a></h3>
			{% if not category.parent == 0 and category.children and show_number_products %}
				<p>{{ category.children|length }} Categorias</p>
			{% elseif show_number_products %}
				<p class="total-products">{{ category.total_products }} Produtos</p>
			{% endif %}
			<a href="{{ category_url }}" class="button white"><span>Explorar</span></a>
		</div>
	</li>
{% endmacro %}