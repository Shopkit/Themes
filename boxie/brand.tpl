{#
Description: Product brand page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    {#  Setup order #}
    {% set order_options = { 'position' : 'lang.storefront.layout.order_options.position'|t, 'title' : 'lang.storefront.layout.order_options.title'|t, 'newest' : 'lang.storefront.layout.order_options.newest'|t, 'sales' : 'lang.storefront.layout.order_options.sales'|t, 'price_asc' : 'lang.storefront.layout.order_options.price_asc'|t, 'price_desc' : 'lang.storefront.layout.order_options.price_desc'|t, 'stock_desc' : 'lang.storefront.layout.order_options.stock_desc'|t, 'stock_asc' : 'lang.storefront.layout.order_options.stock_asc'|t, 'rating' : 'lang.storefront.layout.order_options.rating'|t } %}

    {% if not get.order_by in order_options|keys %}
        {% set get = {'order_by': store.category_default_order|default('position')} %}
    {% endif %}

    {% set products = products("order:#{get.order_by} brand:#{brand.id} limit:#{products_per_page_catalog}") %}

    <div class="breadcrumbs hidden-xs">
        <div class="{{ layout_container }}">
            <ul class="breadcrumbs-list">
                <li class="breadcrumbs-item">
                    <a class="breadcrumbs-link" href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a>
                </li>
                <li class="breadcrumbs-item">
                    <a class="breadcrumbs-link" href="{{ site_url('brands') }}">{{ 'lang.storefront.brand.title'|t }}</a>
                </li>
                <li class="breadcrumbs-item">{{ brand.title }}</li>
            </ul>
        </div>
    </div>

    <section class="section">
        <div class="{{ layout_container }}">
            <div class="row">
                <div class="col-12">
                    <h2 class="products-title title title_mb-lg">{{ brand.title }}</h2>

                    {% if brand.description %}
                        <div class="page-content margin-top-sm">{{ brand.description }}</div>
                    {% endif %}

                    {% if products %}
                        <div class="products">
                            <div class="products-list row row-cols-{{ mobile_products_per_row }} row-cols-sm-2 row-cols-md-3 row-cols-lg-{{ products_per_row }}">
                                {% for product in products %}
                                    <div class="col">
                                        {{ generic_macros.product_list(product, category_badges) }}
                                    </div>
                                {% endfor %}
                            </div>

                            <nav class="text-center">
                                {{ pagination("brand:#{brand.id} limit:#{products_per_page_catalog}") }}
                            </nav>
                        </div>
                    {% else %}
                        <div class="products">
                            <div class="products-list">
                                <div class="no-products">
                                    <h3>{{ 'lang.storefront.brand.no_products'|t }}</h3>
                                </div>
                            </div>
                        </div>
                    {% endif %}
                </div>
            </div>
        </div>
    </section>

{% endblock %}