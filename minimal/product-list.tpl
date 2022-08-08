{% from 'macros.tpl' import product_list %}

{% set col_mapping = {
    1 : 'col-sm-12',
    2 : 'col-sm-6',
    3 : 'col-sm-4',
    4 : 'col-sm-3',
    6 : 'col-sm-2',
} %}

{% set row_col = col_mapping[products_per_row] is defined ? col_mapping[products_per_row] : col_mapping[4] %}

<div class="products {{ css_class_wrapper }}">
    <div class="row">
        {% for product in products %}
            <div class="{{ row_col }}">
                {{ product_list(product) }}
            </div>
            {% if loop.index0%products_per_row == (products_per_row-1) %}
                <div class="clearfix hidden-xs"></div>
            {% endif %}
        {% else %}
            <div class="col-xs-12">
                <h4 class="margin-bottom-lg margin-top-0 text-gray light">Não existem produtos</h4>
            </div>
        {% endfor %}
    </div>
</div>
