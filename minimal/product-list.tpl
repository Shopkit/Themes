{% from 'macros.tpl' import product_list %}

{% set mobile_products_per_row = store.theme_options.mobile_products_per_row == '2' ? '6' : '12' %}

<div class="products {{ css_class_wrapper }}">
    <div class="row">
        {% for product in products %}
            <div class="col-xs-{{ mobile_products_per_row }} col-sm-4 col-md-{{ 12 / products_per_row }}">
                {{ product_list(product) }}
            </div>
            {% if loop.index0 % products_per_row == (products_per_row - 1) %}
                <div class="clearfix hidden-xs hidden-sm"></div>
            {% endif %}
            {% if loop.index0 % 3 == 2 %}
                <div class="clearfix visible-sm"></div>
            {% endif %}
            {% if mobile_products_per_row == '6' and (loop.index % 2 == 0) %}
                <div class="clearfix visible-xs"></div>
            {% endif %}
        {% else %}
            <div class="col-xs-12">
                <h4 class="margin-bottom-lg margin-top-0 text-muted-dark light">{{ 'lang.storefront.product_list.no_products'|t }}</h4>
            </div>
        {% endfor %}
    </div>
</div>
