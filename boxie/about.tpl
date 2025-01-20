{#
Description: About page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    {% set social_on_page_about = store.theme_options.social_on_page_about == 'show' ? 'hidden' : 'show' %}

    <div class="breadcrumbs hidden-xs">
        <div class="{{ layout_container }}">
            <ul class="breadcrumbs-list">
                <li class="breadcrumbs-item">
                    <a class="breadcrumbs-link" href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a>
                </li>
                <li class="breadcrumbs-item">{{ store.page.about.title }}</li>
            </ul>
        </div>
    </div>

    <div class="about section">
        <div class="{{ layout_container }}">
            <h2 class="about-title title title_mb-lg">{{ store.page.about.title }}</h2>
            <div class="row">
                <div class="col-md-{{ social_on_page_about == 'show' ? '7' : '12' }}">
                    <div class="about-text">
                        {{ store.page.about.content }}
                    </div>
                </div>

                <div class="col-md-4 col-md-offset-1 {{ social_on_page_about }}">

                    {% if store.description %}
                        <p class="lead margin-bottom">{{ store.description }}</p>
                    {% endif %}

                    {% if apps.facebook_page %}
                        <div class="margin-bottom">
                            <div class="fb-page" data-href="{{ apps.facebook_page.facebook_url }}" data-small-header="false" data-adapt-container-width="true" data-hide-cover="false" data-show-facepile="true" data-show-posts="false"><div class="fb-xfbml-parse-ignore"><blockquote cite="{{ apps.facebook_page.facebook_url }}"><a href="{{ apps.facebook_page.facebook_url }}">{{ 'lang.storefront.layout.social.facebook'|t }}</a></blockquote></div></div>
                        </div>
                    {% endif %}

                </div>
            </div>
        </div>
    </div>

    {% if store.featured_blocks %}
        <div class="featured-blocks section">
            <div class="{{ layout_container }}">
                <div class="row justify-content-center">
                    {% for featured_block in store.featured_blocks %}
                        <div class="col-lg-4 col-featured-block {{ loop.first ? 'col-lg-offset-' ~ (12 - 4 * store.featured_blocks|length) / 2 }}">
                            <div class="featured-block">
                                <div class="featured-block-icon">
                                    <div style="-webkit-mask-image: url('{{ featured_block.icon }}');mask-image: url('{{ featured_block.icon }}');"></div>
                                </div>
                                <div class="featured-block-category">{{ featured_block.title }}</div>
                                <div class="featured-block-text">{{ featured_block.description }}</div>
                              </div>
                        </div>
                    {% endfor %}
                </div>
            </div>
        </div>
    {% endif %}

    {% if apps.newsletter %}
        {{ generic_macros.newsletter_block() }}
    {% endif %}


{% endblock %}