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
            <h2 class="blog-title title title_mb-md"><a href="{{ site_url('blog') }}" class="link-inherit">{{ 'lang.storefront.blog.title'|t }}</a></h2>
            {% set posts = blog_posts("limit:#{posts_per_page}") %}
            {% if get.id_author and posts[0] %}
                <p class="text-muted">{{ 'lang.storefront.blog.written_by'|t([posts[0].author.name]) }}</p>
            {% endif %}
            {% if get.tag and posts[0] %}
                <p class="text-muted">{{ 'lang.storefront.blog.tag'|t([get.tag]) }}</p>
            {% endif %}

            <div class="blog-row">
                <div class="blog-col row row-cols-lg-{{ posts_per_row }} row-cols-md-{{ posts_per_row > 3 ? '3' : posts_per_row }} row-cols-sm-1 row-cols-1">
                    {% for post in posts %}
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
                                    <div class="blog-text">
                                        {% if post.author.name or post.date or post.tags %}
                                            <div class="post-details small text-muted margin-bottom-sm">
                                                {% if post.author.name %}
                                                    <span>{{ 'lang.storefront.blog.post_author'|t([icons('user', 'margin-right-xxs'), site_url('blog?id_author=' ~ post.author.id), post.author.name]) }}</span>
                                                {% endif %}
                                                {% if post.date %}
                                                    <span>{{ icons('calendar', 'margin-right-xxs') }}{{ 'lang.storefront.blog.post_date_simple'|t([post.date|format_datetime('long','none')]) }}</span>
                                                {% endif %}
                                                {% if post.tags %}
                                                    <span>
                                                        {{ icons('tags', 'margin-right-xxs') }}
                                                        {% for tag in post.tags %}
                                                            <a href="{{ site_url('blog?tag=' ~ tag.handle) }}" class="link-inherit" rel="tag">{{ tag.title }}</a>{% if not loop.last %}, {% endif %}
                                                        {% endfor %}
                                                    </span>
                                                {% endif %}
                                            </div>
                                        {% endif %}
                                        <div class="blog-excerpt">
                                            {{ word_limiter(post.excerpt, 100, ' ... <a href="' ~ post.url ~ '">' ~ 'lang.storefront.blog.read_more'|t ~'</a>') }}
                                        </div>
                                    </div>
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
