{#
Description: Promotions Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    {% set products = products("on_sale limit:#{products_per_page_catalog}") %}

    <div class="products products-full section">
        <div class="{{ layout_container }}">
            <h2 class="products-title title title_mb-lg">{{ store.page.sales.title }}</h2>

            {% if store.page.sales.content %}
                <div class="page-content margin-bottom">
                    {{ store.page.sales.content }}
                </div>
            {% endif %}

            <div class="products-list row row-cols-{{ mobile_products_per_row }} row-cols-sm-2 row-cols-md-3 row-cols-lg-{{ products_per_row }}">
                {% for product in products %}
                    <div class="col">
                        {{ generic_macros.product_list(product, category_badges) }}
                    </div>
                {% else %}
                    <div class="no-products">
                        <h3>{{ 'lang.storefront.product_list.no_products'|t }}</h3>
                    </div>
                {% endfor %}
            </div>

            <nav>
                {{ pagination("on_sale limit:#{products_per_page_catalog}") }}
            </nav>
        </div>
    </div>

{% endblock %}