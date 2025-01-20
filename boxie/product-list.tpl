{% from 'macros.tpl' import product_list %}

{% set category_badges = ['yellow', 'blue', 'pink', 'green', 'red', 'purple', 'orange', 'dark-green', 'blue-gray', 'maroon']|shuffle %}

<div class="products {{ css_class_wrapper }}">
	{% for product in products %}
        {{ product_list(product, category_badges) }}
    {% else %}
        <div class="col-xs-12">
            <h4 class="margin-bottom-lg margin-top-0 text-gray light">{{ 'lang.storefront.product_list.no_products'|t }}</h4>
        </div>
    {% endfor %}
</div>