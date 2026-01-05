{#
Description: Blog page
#}

{% extends 'base.tpl' %}

{% block content %}

	{% set posts = blog_posts("limit:#{posts_per_page}") %}

	<div class="content">

		<section class="page">

			<h1><a href="{{ site_url('blog') }}" class="link-inherit">{{ 'lang.storefront.blog.title'|t }}</a></h1>
			{% if get.id_author and posts[0] %}
				<p class="text-muted">{{ 'lang.storefront.blog.written_by'|t([posts[0].author.name]) }}</p>
			{% endif %}
			{% if get.tag and posts[0] %}
				<p class="text-muted">{{ 'lang.storefront.blog.tag'|t([get.tag]) }}</p>
			{% endif %}

			<hr>

			{% if posts %}

				{% for post in posts %}
					<article class="break-word clearfix">

						<h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
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

						<div class="row-fluid">

							<div class="span9 blog-text">
								{{ word_limiter(post.excerpt, 100, ' ... <a href="' ~ post.url ~ '">' ~ 'lang.storefront.blog.read_more'|t ~'</a>') }}
							</div>

							{% if post.image %}
								<p class="span3"><a href="{{ post.url }}"><img class="boxed lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ post.image.thumb }}" alt="{{ post.image.alt ? post.image.alt : post.title|e_attr }}"></a></p>
							{% endif %}

						</div>

					</article>

					<hr>
				{% endfor %}

				{{ pagination("limit:#{posts_per_page}") }}

			{% else %}

				<h5>{{ 'lang.storefront.blog.no_posts'|t }}</h5>

			{% endif %}

		</section>

	</div>

{% endblock %}