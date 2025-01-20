{#
Description: Blog post Page
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
                <li class="breadcrumbs-item">
                    <a class="breadcrumbs-link" href="{{ site_url('blog') }}">{{ 'lang.storefront.blog.title'|t }}</a>
                </li>
                <li class="breadcrumbs-item">{{ blog_post.title }}</li>
            </ul>
        </div>
    </div>

    <div class="blog-post section">
        <div class="{{ layout_container }}">

            <div class="row">
                <div class="col">

                    <div class="post-detail well-featured {{ store.theme_options.well_featured_shadow }}">

                        {% if blog_post.image %}
                            <div class="image-post">
                                <img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ blog_post.image.full }}" alt="{{ blog_post.title|e_attr }}" title="{{ blog_post.title|e_attr }}" class="img-responsive lazy">
                            </div>
                        {% endif %}

                        <div class="content">

                            <h2 class="blog-post-title title"><a href="{{ blog_post.url }}" class="link-inherit">{{ blog_post.title }}</a></h2>
                            <p class="small text-muted margin-bottom">{{ 'lang.storefront.blog.post_date'|t([blog_post.date|format_datetime('long','none')]) }}</p>

                            {{ blog_post.text }}

                            <div class="share margin-top">
                                <a target="_blank" href="http://www.facebook.com/sharer.php?u={{ blog_post.url }}" class="text-muted"><i data-feather="facebook"></i></a> &nbsp;
                                <a target="_blank" href="http://www.facebook.com/dialog/send?app_id=229578494202981&link={{ blog_post.url }}&redirect_uri={{ blog_post.url }}" class="text-muted"><i class="fab fa-facebook-messenger"></i></a> &nbsp;
                                <a target="_blank" href="https://wa.me/?text={{ "#{blog_post.title}: #{blog_post.url}"|url_encode }}" class="text-muted"><i class="fab fa-whatsapp"></i></a> &nbsp;
                                <a target="_blank" href="https://twitter.com/share?url={{ blog_post.url }}&text={{ character_limiter(description, 100)|url_encode }}" class="text-muted"><i data-feather="twitter"></i></a> &nbsp;
                                <a target="_blank" href="https://pinterest.com/pin/create/bookmarklet/?media={{ blog_post.image.full }}&url={{ blog_post.url }}&description={{ blog_post.title|url_encode }}" class="text-muted"><i class="fab fa-pinterest-p"></i></a>
                            </div>
                        </div>
                    </div>

                    {% if apps.facebook_comments.comments_blog %}
                        <div class="row justify-content-center">
                            <div class="col-lg-8 margin-top-lg">
                                <div class="fb-comments" data-href="{{ blog_post.url }}" data-numposts="5" data-width="100%"></div>
                            </div>
                        </div>
                    {% endif %}

                </div>
            </div>
        </div>
    </div>

{% endblock %}