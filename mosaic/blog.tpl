{#
Description: Blog page
#}

{% extends 'base.tpl' %}

{% block content %}

	{% set posts = blog_posts("limit:#{posts_per_page}") %}

	<div class="content">

		<section class="page">

			<h1>{{ 'lang.storefront.blog.title'|t }}</h1>

			<hr>

			{% if posts %}

				{% for post in posts %}
					<article class="break-word clearfix">

						<h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
						<p><small class="muted"><em>{{ 'lang.storefront.blog.post_date'|t([post.date|format_datetime('long','none')]) }}</strong></em></small></p>

						<div class="row-fluid">

							<div class="span9">
								{{ word_limiter(post.excerpt, 100, ' ... <a href="' ~ post.url ~ '">' ~ 'lang.storefront.blog.read_more'|t ~'</a>') }}
							</div>

							{% if post.image %}
								<p class="span3"><a href="{{ post.url }}"><img class="boxed lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ post.image.thumb }}" alt="{{ post.title|e_attr }}"></a></p>
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