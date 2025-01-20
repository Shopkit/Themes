{#
Description: Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    <div class="breadcrumbs hidden-xs">
        <div class="{{ layout_container }}">
            <ul class="breadcrumbs-list">
                <li class="breadcrumbs-item">
                    <a class="breadcrumbs-link" href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a>
                </li>
                <li class="breadcrumbs-item">{{ page.title }}</li>
            </ul>
        </div>
    </div>

    <div class="page section">
        <div class="{{ layout_container }}">
            <div class="row">
                <div class="col">
                    <h2 class="page-title title title_mb-lg">{{ page.title }}</h2>
                </div>
            </div>

            <div class="row justify-content-center">
                <div class="col-lg-9">
                    <div class="page-content well-featured {{ store.theme_options.well_featured_shadow }}">
                        {{ page.content }}
                    </div>
                </div>
            </div>
        </div>
    </div>

{% endblock %}