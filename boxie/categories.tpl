{#
Description: Categories list page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    {% set categories = categories("limit:#{categories_per_page}") %}

    <div class="breadcrumbs hidden-xs">
        <div class="{{ layout_container }}">
            <ul class="breadcrumbs-list">
                <li class="breadcrumbs-item">
                    <a class="breadcrumbs-link" href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a>
                </li>
                <li class="breadcrumbs-item">{{ 'lang.storefront.categories.title'|t }}</li>
            </ul>
        </div>
    </div>

    <div class="categories section">
        <div class="{{ layout_container }}">
            <h2 class="categories-title title title_mb-lg">{{ 'lang.storefront.categories.title'|t }}</h2>

            <div class="categories-list row row-cols-{{ mobile_categories_per_row }} row-cols-sm-2 row-cols-md-3  row-cols-lg-{{ categories_per_row }}">
                {% for category in categories %}
                    <div class="col">
                        {{ generic_macros.category_list(category, false) }}
                    </div>
                {% else %}
                    <div class="col no-categories">
                        <h3>{{ 'lang.storefront.categories.no_categories'|t }}</h3>
                    </div>
                {% endfor %}
            </div>

            <nav>
                {{ pagination("categories limit:#{categories_per_page}") }}
            </nav>
        </div>
    </div>

{% endblock %}