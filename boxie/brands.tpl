{#
Description: Brands list page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    {% set brands = brands("order:#{store.brands_sorting} limit:#{brands_per_page}") %}

    <div class="breadcrumbs hidden-xs">
        <div class="{{ layout_container }}">
            <ul class="breadcrumbs-list">
                <li class="breadcrumbs-item">
                    <a class="breadcrumbs-link" href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a>
                </li>
                <li class="breadcrumbs-item">{{ 'lang.storefront.brands.title'|t }}</li>
            </ul>
        </div>
    </div>

    <div class="section">
        <div class="{{ layout_container }}">
            <div class="row">
                <div class="col">
                    <div class="brands">
                        <div class="brands-list row row-cols-lg-{{ brands_per_row }} row-cols-md-{{ brands_per_row > 3 ? '3' : brands_per_row }} row-cols-sm-1 row-cols-{{ mobile_brands_per_row }}">
                            {% set card_hover_effect = store.theme_options.card_hover_effect != 'none' ? store.theme_options.card_hover_effect : '' %}
                            {% set card_thumbnail_type = store.theme_options.catalog_thumbail_type == 'square' ? 'square' : 'thumb' %}
                            {% for brand in brands %}
                                <div class="col">
                                    <div class="brand brand-id-{{ brand.id }} {{ card_hover_effect }}">
                                        <div class="{{ store.theme_options.card_shadow }}">
                                            <div class="brand-view">
                                                <a class="brand-preview" href="{{ brand.url }}">
                                                    <img class="brand-pic lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ brand.image[card_thumbnail_type] }}" alt="{{ brand.title }}" title="{{ brand.title }}" />
                                                </a>
                                                <a class="brand-btn btn btn-primary {{ store.theme_options.button_primary_shadow }}" href="{{ brand.url }}">{{ 'lang.storefront.macros.button.explore'|t }}</a>
                                            </div>
                                            <a class="brand-name" href="{{ brand.url }}">{{ brand.title }}</a>
                                        </div>
                                    </div>
                                </div>
                            {% else %}
                                <div class="col no-brands">
                                    <h3>{{ 'lang.storefront.brands.no_brands'|t }}</h3>
                                </div>
                            {% endfor %}
                        </div>

                        <nav class="text-center">
                            {{ pagination("brands limit:#{brands_per_page}") }}
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>

{% endblock %}