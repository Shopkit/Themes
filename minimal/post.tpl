{#
Description: Blog post Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="{{ layout_container }}">

		<div class="row">
			<div class="col-sm-10 col-sm-offset-1 col-md-8 col-md-offset-2">

				<a href="{{ site_url('blog') }}" class="text-muted">{{ icons('angle-left') }} &nbsp; {{ 'lang.storefront.blog.title'|t }}</a>

				<h1 class="margin-top-sm margin-bottom-sm"><a href="{{ blog_post.url }}" class="link-inherit">{{ blog_post.title }}</a></h1>

				{% if blog_post.author.name or blog_post.date or blog_post.tags %}
                    <div class="post-details small text-muted">
                        {% if blog_post.author.name %}
                            <span>{{ 'lang.storefront.blog.post_author'|t([icons('user', 'margin-right-xxs'), site_url('blog?id_author=' ~ blog_post.author.id), blog_post.author.name]) }}</span>
                        {% endif %}
                        {% if blog_post.date %}
                            <span>{{ icons('calendar', 'margin-right-xxs') }}{{ 'lang.storefront.blog.post_date_simple'|t([blog_post.date|format_datetime('long','none')]) }}</span>
                        {% endif %}
                        {% if blog_post.tags %}
                            <span>
                                {{ icons('tags', 'margin-right-xxs') }}
                                {% for tag in blog_post.tags %}
                                    <a href="{{ site_url('blog?tag=' ~ tag.handle) }}" class="link-inherit" rel="tag">{{ tag.title }}</a>{% if not loop.last %}, {% endif %}
                                {% endfor %}
                            </span>
                        {% endif %}
                    </div>
                {% endif %}

				<article class="margin-top">

					{% if blog_post.image %}
						<div class="image-post margin-bottom">
							<img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ blog_post.image.full }}" alt="{{ blog_post.title|e_attr }}" title="{{ blog_post.title|e_attr }}" class="img-responsive border-radius lazy">
						</div>
					{% endif %}

					<div class="post-content">
						{{ blog_post.text }}
					</div>

					<hr>

					<div class="share">
						<a target="_blank" href="http://www.facebook.com/sharer.php?u={{ blog_post.url }}" class="text-muted">{{ icons('facebook-f', 'fa-lg') }}</a> &nbsp;
						<a target="_blank" href="https://wa.me/?text={{ "#{blog_post.title}: #{blog_post.url}"|url_encode }}" class="text-muted">{{ icons('whatsapp', 'fa-lg') }}</a> &nbsp;
						<a target="_blank" href="https://twitter.com/share?url={{ blog_post.url }}&text={{ character_limiter(description, 100)|url_encode }}" class="text-muted">{{ icons('twitter', 'fa-lg') }}</a> &nbsp;
						<a target="_blank" href="https://pinterest.com/pin/create/bookmarklet/?media={{ blog_post.image.full }}&url={{ blog_post.url }}&description={{ blog_post.title|url_encode }}" class="text-muted">{{ icons('pinterest', 'fa-lg') }}</a>
					</div>
				</article>

				{% if apps.facebook_comments.comments_blog %}
					<div class="margin-top">
						<div class="fb-comments" data-href="{{ blog_post.url }}" data-numposts="5" data-width="100%"></div>
					</div>
				{% endif %}

			</div>

		</div>

	</div>

{% endblock %}