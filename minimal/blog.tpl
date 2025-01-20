{#
Description: Blog page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set posts = blog_posts("limit:#{posts_per_page}") %}
	{% set card_hover_effect = store.theme_options.card_hover_effect != 'none' ? store.theme_options.card_hover_effect : '' %}

	<div class="{{ layout_container }}">

		<h1 class="margin-top-0 margin-bottom">{{ 'lang.storefront.blog.title'|t }}</h1>

		<div class="row">

			{% if posts %}
				{% for post in posts %}
					<div class="col-sm-{{ 12 / posts_per_row }}">
						<article class="blog-post {{ store.theme_options.card_shadow }} {{ card_hover_effect }}">

							{% if post.image %}
								<div class="image-post">
									<a href="{{ post.url }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ post.image.full }}" alt="{{ post.title|e_attr }}" title="{{ post.title|e_attr }}" class="lazy"></a>
								</div>
							{% endif %}

							<div class="description">
								<h4><a href="{{ post.url }}">{{ post.title }}</a></h4>
								<p class="small">{{ 'lang.storefront.blog.post_date'|t([post.date|format_datetime('long','none')]) }}</p>

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

