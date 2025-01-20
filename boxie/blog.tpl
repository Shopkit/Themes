{#
Description: Blog page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    {% set card_hover_effect = store.theme_options.card_hover_effect != 'none' ? store.theme_options.card_hover_effect : '' %}

    <div class="breadcrumbs hidden-xs">
        <div class="{{ layout_container }}">
            <ul class="breadcrumbs-list">
                <li class="breadcrumbs-item">
                    <a class="breadcrumbs-link" href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a>
                </li>
                <li class="breadcrumbs-item">{{ 'lang.storefront.blog.title'|t }}</li>
            </ul>
        </div>
    </div>

    <div class="blog-page section">
        <div class="{{ layout_container }}">
            <h2 class="blog-title title title_mb-md">{{ 'lang.storefront.blog.title'|t }}</h2>

            <div class="blog-row">
                <div class="blog-col row row-cols-lg-{{ posts_per_row }} row-cols-md-{{ posts_per_row > 3 ? '3' : posts_per_row }} row-cols-sm-1 row-cols-1">
                    {% for post in blog_posts("limit:#{posts_per_page}") %}
                        <div class="col margin-bottom-md">
                            <div class="blog-item {{ store.theme_options.card_shadow }} {{ card_hover_effect }}">
                                {% if post.image %}
                                    <div class="col-lg-3">
                                        <div class="blog-image">
                                            <a href="{{ post.url }}"><img class="lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ post.image.square }}" alt="{{ post.title|e_attr }}" title="{{ post.title|e_attr }}"></a>
                                        </div>
                                    </div>
                                {% endif %}
                                <div class="{{ post.image ? 'col-lg-9' : 'col no-margin' }} blog-details">
                                    <div class="blog-post"><a href="{{ post.url }}" class="link-inherit">{{ post.title }}</a></div>
                                    <div class="blog-text">{{ 'lang.storefront.blog.post_date'|t([post.date|format_datetime('long','none')]) }}</div>
                                    <a href="{{ post.url }}" class="blog-btn btn btn-primary {{ store.theme_options.button_primary_shadow }}">{{ 'lang.storefront.blog.read_more'|t }}</a>
                                </div>
                            </div>
                        </div>
                    {% endfor %}
                </div>
            </div>

            <nav>
                {{ pagination("blog limit:#{posts_per_page}") }}
            </nav>
        </div>
    </div>

{% endblock %}
