{#
Description: Product category page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    {#  Parent category #}
    {% if category.is_parent %}
        {% set parent_category = category %}
        {% set is_parent = true %}

        {% if category.parent %}
            {% set main_parent = category(category.parent) %}
        {% else %}
            {% set main_parent = category %}
        {% endif %}
    {% else %}
        {% set parent_category = category(category.parent) %}
        {% set main_parent = category(parent_category.parent) ?: parent_category %}
    {% endif %}

    {#  Setup order #}
    {% set order_options = { 'position' : 'lang.storefront.layout.order_options.position'|t, 'title' : 'lang.storefront.layout.order_options.title'|t, 'newest' : 'lang.storefront.layout.order_options.newest'|t, 'sales' : 'lang.storefront.layout.order_options.sales'|t, 'price_asc' : 'lang.storefront.layout.order_options.price_asc'|t, 'price_desc' : 'lang.storefront.layout.order_options.price_desc'|t, 'stock_desc' : 'lang.storefront.layout.order_options.stock_desc'|t, 'stock_asc' : 'lang.storefront.layout.order_options.stock_asc'|t, 'rating' : 'lang.storefront.layout.order_options.rating'|t } %}
    {% set query_order = get.order_by %}

    {% if not get.order_by in order_options|keys %}
        {% if not get %}
            {% set get = [] %}
        {% endif %}
        {% set get = get|merge({'order_by': store.category_default_order|default('position')}) %}
    {% endif %}

    {% set products = products("order:#{get.order_by} category:#{category.id} limit:#{products_per_page_catalog} price:[#{get.price_min},#{get.price_max}] tag:#{get.filter_tag}") %}
    {% set products_default = products("order:#{get.order_by} category:#{category.id} limit:#{products_per_page_catalog}") %}

    <div class="breadcrumbs hidden-xs">
        <div class="{{ layout_container }}">
            <ul class="breadcrumbs-list">
                <li class="breadcrumbs-item">
                    <a class="breadcrumbs-link" href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a>
                </li>
                {% if main_parent and main_parent.id != category.id %}
                    <li class="breadcrumbs-item">
                        <a class="breadcrumbs-link" href="{{ main_parent.url }}">{{ main_parent.title }}</a>
                    </li>
                {% endif %}
                {% if category.id != parent_category.id and parent_category.is_parent and parent_category.is_child %}
                    <li class="breadcrumbs-item">
                        <a class="breadcrumbs-link" href="{{ parent_category.url }}">{{ parent_category.title }}</a>
                    </li>
                {% endif %}
                <li class="breadcrumbs-item">{{ category.title }}</li>
            </ul>
        </div>
    </div>

    <div class="section">
        <div class="{{ layout_container }}">
            <div class="row">
                <div class="col">
                    <h2 class="products-title title title_mb-lg">{{ category.title }}</h2>

                    {% if category.description %}
                        <div class="page-content margin-top-sm">{{ category.description }}</div>
                    {% endif %}

                    {% if products_default %}
                        <div class="products">

                            <div class="filters js-filters {{ show_filters }}">
                                <div class="filters-sorting">

                                    {{ generic_macros.filters_list(products, main_parent, category) }}

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
                                        <h3>{{ 'lang.storefront.category.no_products'|t }}</h3>
                                    </div>
                                {% endfor %}
                            </div>

                            <nav class="text-center">
                                {{ pagination("category:#{category.id} limit:#{products_per_page_catalog} price:[#{get.price_min},#{get.price_max}] tag:#{get.filter_tag}") }}
                            </nav>
                        </div>
                    {% elseif is_parent and parent_category.children %}

                        {% set sub_categories = categories("parent:#{parent_category.id} limit:#{categories_per_page}") %}

                        <div class="categories">
                            <div class="categories-list row row-cols-{{ mobile_categories_per_row }} row-cols-sm-2 row-cols-md-3  row-cols-lg-{{ categories_per_row }}">
                                {% for category in sub_categories %}
                                    <div class="col">
                                        {{ generic_macros.category_list(category) }}
                                    </div>
                                {% endfor %}
                            </div>

                            <nav class="text-center">
                                {{ pagination("categories parent:#{parent_category.id} limit:#{categories_per_page}") }}
                            </nav>
                        </div>

                    {% else %}
                        <div class="products">
                            <div class="products-list">
                                <div class="no-products">
                                    <h3>{{ 'lang.storefront.category.no_products'|t }}</h3>
                                </div>
                            </div>
                        </div>
                    {% endif %}
                </div>
            </div>
        </div>
    </div>

{% endblock %}