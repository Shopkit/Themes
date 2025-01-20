{#
Description: Search Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    {#  Setup order #}
    {% set order_options = { 'relevance' : 'lang.storefront.layout.order_options.position'|t, 'title' : 'lang.storefront.layout.order_options.title'|t, 'newest' : 'lang.storefront.layout.order_options.newest'|t, 'sales' : 'lang.storefront.layout.order_options.sales'|t, 'price_asc' : 'lang.storefront.layout.order_options.price_asc'|t, 'price_desc' : 'lang.storefront.layout.order_options.price_desc'|t, 'stock_desc' : 'lang.storefront.layout.order_options.stock_desc'|t, 'stock_asc' : 'lang.storefront.layout.order_options.stock_asc'|t, 'rating' : 'lang.storefront.layout.order_options.rating'|t } %}
    {% set query_order = get.order_by %}

    {% if not get.order_by in order_options|keys %}
        {% if not get %}
            {% set get = [] %}
        {% endif %}
        {% set get = get|merge({'order_by': store.theme_options.search_default_order}) %}
    {% endif %}

    {% set search = products("search order:#{get.order_by} limit:#{products_per_page_catalog}") %}

    {% set total_products = search.total_results %}
    {% set cur_page = (pagination_segment / products_per_page_catalog) + 1 %}
    {% set cur_page_from = pagination_segment + 1 %}
    {% set cur_page_to = (cur_page * products_per_page_catalog) < search.total_results ? cur_page * products_per_page_catalog : search.total_results %}

    <div class="breadcrumbs hidden-xs">
        <div class="{{ layout_container }}">
            <ul class="breadcrumbs-list">
                <li class="breadcrumbs-item">
                    <a class="breadcrumbs-link" href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a>
                </li>
                <li class="breadcrumbs-item">{{ 'lang.storefront.search.title'|t }}</li>
            </ul>
        </div>
    </div>

    <div class="products products-search section">
        <div class="{{ layout_container }}">
            <h2 class="products-title title title_mb-md">{{ 'lang.storefront.search.title'|t }}</h2>

            <div class="filters js-filters">
                <div class="filters-sorting">

                    <div class="search-message">
                        {% if search.results %}
                            {{ 'lang.storefront.search.results'|t([cur_page_from, cur_page_to, total_products, search.query]) }}
                        {% else %}
                            {{ 'lang.storefront.search.results.variant'|t([search.total_results, search.query]) }}
                        {% endif %}
                    </div>

                    <div class="filters-field">
                        {{ generic_macros.order_by(get, order_options) }}
                    </div>
                </div>
            </div>



            <div class="products-list row row-cols-{{ mobile_products_per_row }} row-cols-sm-2 row-cols-md-3 row-cols-lg-{{ products_per_row }}">
                {% for product in search.results %}
                    <div class="col">
                        {{ generic_macros.product_list(product, category_badges) }}
                    </div>
                {% endfor %}
            </div>

            <nav>
                {{ pagination("search limit:#{products_per_page_catalog}") }}
            </nav>
        </div>
    </div>

    {% if apps.newsletter %}
        {{ generic_macros.newsletter_block() }}
    {% endif %}

{% endblock %}