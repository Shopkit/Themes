{% from 'macros.tpl' import product_list %}

{% set col_mapping = {
    1 : 'span9',
    2 : 'span4',
    3 : 'span3',
    4 : 'span2'
} %}

{% set row_col = col_mapping[products_per_row] is defined ? col_mapping[products_per_row] : col_mapping[3] %}

<div class="row products {{ css_class_wrapper }}">
	{% for product in products %}
		<div class="{{ row_col }}">
			{{ product_list(product) }}
		</div>
	{% else %}
		<div class="span9">
			<h4 class="margin-bottom-lg margin-top-0 text-gray light">{{ 'lang.storefront.product_list.no_products'|t }}</h4>
		</div>
	{% endfor %}
</div>