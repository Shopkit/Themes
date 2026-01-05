{#
Description: Home Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    {% if categories and store.theme_options.home_num_categories > 0 %}
        <div class="categories section">
            <div class="{{ layout_container }}">
                <h2 class="section-title title title_mb-lg">{{ 'lang.storefront.layout.categories.title'|t }}</h2>
                <div class="categories-container">
                    <div class="categories-slider">
                        {% for category in categories %}
                            {% if loop.index0 < (store.theme_options.home_num_categories ? store.theme_options.home_num_categories : categories|length) %}
                                <div class="categories-slide">
                                    <a class="categories-item" href="{{ category.url }}">
                                        <div class="categories-text hyphenate">{{ category.title }}</div>
                                    </a>
                                </div>
                            {% endif %}
                        {% endfor %}
                    </div>
                </div>
            </div>
        </div>
    {% endif %}

    {% set products_count = products("order:featured")|length %}
    {% set products_per_page_home = store.products_per_page_home %}
    {% set products = products("order:featured limit:#{products_per_page_home}") %}
    {% set products_per_row_home = store.theme_options.home_products_per_row %}
    {% if products_per_page_home and products %}
        <div class="products products-main section">
            <div class="{{ layout_container }}">
                <div class="products-featured">
                    <h2 class="products-title title title_mb-lg">{{ 'lang.storefront.macros.products.title'|t }}</h2>

                    <div class="products-list row row-cols-lg-{{ products_per_row_home }} row-cols-md-{{ products_per_row_home > 3 ? '3' : products_per_row_home }} row-cols-sm-{{ mobile_products_per_row }} row-cols-{{ mobile_products_per_row }}">
                        {% for product in products %}
                            <div class="col">
                                {{ generic_macros.product_list(product, category_badges) }}
                            </div>
                        {% endfor %}
                    </div>

                    {% if products_count > products_per_page_home %}
                        <div class="products-btns">
                            <a class="products-btn btn btn-primary {{ store.theme_options.button_primary_shadow }}" href="{{ site_url('catalog') }}">{{ 'lang.storefront.home.random_product.load_more.button'|t }}</a>
                        </div>
                    {% endif %}
                </div>
            </div>
        </div>
    {% endif %}

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

    {% set reviews = reviews("order:random limit:6") %}
    {% if apps.product_reviews and apps.product_reviews.product_reviews_block and reviews.reviews %}
        {{ generic_macros.reviews_block(reviews) }}
    {% endif %}

    {% set blog = blog_posts("limit:#{posts_per_page}") %}

    {% if blog %}
        <div class="blog section">
            <div class="{{ layout_container }}">
                <h2 class="blog-block-title title title_mb-lg">{{ 'lang.storefront.blog.title'|t }}</h2>

                <div class="blog-list">
                    {% for post in blog %}
                        {% if post.image and loop.index < 6 %}
                            <a href="{{ post.url }}" class="blog-item {{ loop.first ? 'blog-item_w66' : 'blog-item_w33' }}">
                                {% if loop.first %}<div class="blog-status blog-status_recent">{{ 'lang.storefront.home.recent_post.label'|t }}</div>{% endif %}
                                <div class="blog-preview" style="background-image: url('{{ post.image.full }}');"></div>
                                <h3 class="blog-info">{{ post.title }}</h3>
                            </a>
                        {% endif %}
                    {% endfor %}
                </div>
                {% if blog|length > 5 %}
                    <div class="blog-btns">
                        <a class="blog-btn btn btn-primary {{ store.theme_options.button_primary_shadow }}" href="{{ site_url('blog') }}">Ver todos</a>
                    </div>
                {% endif %}
            </div>
        </div>
    {% endif %}

    {% if apps.newsletter %}
        {{ generic_macros.newsletter_block() }}
    {% endif %}

    {% set brands = brands("order:#{store.theme_options.home_brands_sorting} limit:25") %}
    {% if brands %}
        <section class="brands section brands-block">
            <div class="{{ layout_container }}">
                <h2 class="brands-title title title_mb-lg">{{ 'lang.storefront.home.block.brands.title'|t }}</h2>
                <div class="brands-list">
                    {% for brand in brands %}
                        <a href="{{ brand.url }}" class="img-frame"><img src="{{ brand.image.thumb }}" alt="{{ brand.image.alt ? brand.image.alt : brand.title }}" title="{{ brand.title }}"></a>
                    {% endfor %}
                </div>
                <p class="small margin-top"><a href="{{ site_url('brands') }}" class="text-muted text-underline">{{ 'lang.storefront.brands.title'|t }}</a></p>
            </div>
        </section>
    {% endif %}

{% endblock %}
