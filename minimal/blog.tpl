{#
Description: Blog page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set posts = blog_posts("limit:#{posts_per_page}") %}
	{% set card_hover_effect = store.theme_options.card_hover_effect != 'none' ? store.theme_options.card_hover_effect : '' %}

	<div class="{{ layout_container }}">

		<h1 class="margin-top-0 margin-bottom"><a href="{{ site_url('blog') }}" class="link-inherit">{{ 'lang.storefront.blog.title'|t }}</a></h1>
		{% if get.id_author and posts[0] %}
			<p class="text-muted">{{ 'lang.storefront.blog.written_by'|t([posts[0].author.name]) }}</p>
		{% endif %}
		{% if get.tag and posts[0] %}
			<p class="text-muted">{{ 'lang.storefront.blog.tag'|t([get.tag]) }}</p>
		{% endif %}

		<div class="row">

			{% if posts %}
				{% for post in posts %}
					<div class="col-sm-{{ 12 / posts_per_row }}">
						<article class="blog-post {{ store.theme_options.card_shadow }} {{ card_hover_effect }}">

							{% if post.image %}
								<div class="image-post">
									<a href="{{ post.url }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ post.image.full }}" alt="{{ post.image.alt ? post.image.alt : post.title|e_attr }}" title="{{ post.title|e_attr }}" class="lazy"></a>
								</div>
							{% endif %}

							<div class="description">
								<h4><a href="{{ post.url }}">{{ post.title }}</a></h4>
								{% if post.author.name or post.date or post.tags %}
                                    <div class="post-details small text-muted margin-bottom">
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

								<div>
									{{ word_limiter(post.excerpt, 100, ' ... <a href="' ~ post.url ~ '">' ~ 'lang.storefront.blog.read_more'|t ~'</a>') }}
								</div>
							</div>

						</article>
					</div>

					{% if loop.index0 % posts_per_row == (posts_per_row - 1) %}
						<div class="clearfix hidden-xs"></div>
					{% endif %}
				{% endfor %}
			{% else %}
				<p class="h2 text-center light text-muted margin-top-lg">{{ 'lang.storefront.blog.no_posts'|t }}</p>
			{% endif %}
		</div>

		{% if posts %}
			<div class="row">
				<nav class="text-center">
					{{ pagination("limit:#{posts_per_page}") }}
				</nav>
			</div>
		{% endif %}

	</div>

{% endblock %}

