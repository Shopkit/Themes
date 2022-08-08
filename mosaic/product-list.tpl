{% from 'macros.tpl' import product_list %}

{% set col_mapping = {
    1 : 'span12',
    2 : 'span6',
    3 : 'span4',
    4 : 'span3',
    6 : 'span2',
} %}

{% set row_col = col_mapping[products_per_row] is defined ? col_mapping[products_per_row] : col_mapping[4] %}

<div class="row-fluid">
	<ul class="products {{ css_class_wrapper }}">
		{% for product in products %}
			{{ product_list(product) }}
		{% endfor %}
	</ul>
</div>