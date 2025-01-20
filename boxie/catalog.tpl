{#
Description: Product catalog page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    {#  Setup order #}
    {% set order_options = { 'position' : 'lang.storefront.layout.order_options.position'|t, 'title' : 'lang.storefront.layout.order_options.title'|t, 'newest' : 'lang.storefront.layout.order_options.newest'|t, 'sales' : 'lang.storefront.layout.order_options.sales'|t, 'price_asc' : 'lang.storefront.layout.order_options.price_asc'|t, 'price_desc' : 'lang.storefront.layout.order_options.price_desc'|t, 'stock_desc' : 'lang.storefront.layout.order_options.stock_desc'|t, 'stock_asc' : 'lang.storefront.layout.order_options.stock_asc'|t, 'rating' : 'lang.storefront.layout.order_options.rating'|t } %}
    {% set query_order = get.order_by %}

    {% if not get.order_by in order_options|keys %}
        {% if not get %}
            {% set get = [] %}
        {% endif %}
        {% set get = get|merge({'order_by': store.category_default_order|default('position')}) %}
    {% endif %}

    {% set products = products("order:#{get.order_by} limit:#{products_per_page_catalog} price:[#{get.price_min},#{get.price_max}] tag:#{get.filter_tag}") %}

    <div class="breadcrumbs hidden-xs">
        <div class="{{ layout_container }}">
            <ul class="breadcrumbs-list">
                <li class="breadcrumbs-item">
                    <a class="breadcrumbs-link" href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a>
                </li>
                <li class="breadcrumbs-item">{{ 'lang.storefront.catalog.title'|t }}</li>
            </ul>
        </div>
    </div>

    <div class="products products-full section">
        <div class="{{ layout_container }}">
            <h2 class="products-title title title_mb-lg">{{ 'lang.storefront.catalog.title'|t }}</h2>

            <div class="filters js-filters {{ show_filters }}">
                <div class="filters-sorting">

                    {{ generic_macros.filters_list(products) }}

                    <div class="filters-field">
                        {{ generic_macros.order_by(get, order_options) }}
                    </div>
                </div>
                <div class="filters-tags">
                    {% if get.price_min is defined and get.price_max is defined %}
                        <div class="filters-tag tag-price" data-remove="" data-type="price">{{ get.price_min|money_without_trailing_zeros }} - {{ get.price_max|money_without_trailing_zeros }}<button class="filters-remove"></button></div>
                    {% endif %}
                    {% if get.filter_tag %}
                        {% set filter_tags = get.filter_tag|e|split(',') %}
                        {% for filter_tag in filter_tags %}
                            <div class="filters-tag tag-tag" data-remove="{{ filter_tag }}" data-type="tag">{{ filter_tag }}<button class="filters-remove"></button></div>
                        {% endfor %}
                    {% endif %}
                </div>
            </div>

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
                {{ pagination("products limit:#{products_per_page_catalog} price:[#{get.price_min},#{get.price_max}] tag:#{get.filter_tag}") }}
            </nav>

        </div>
    </div>

    {% if apps.newsletter %}
        {{ generic_macros.newsletter_block() }}
    {% endif %}

{% endblock %}