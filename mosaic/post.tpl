{#
Description: Blog post Page
#}

{% extends 'base.tpl' %}

{% block content %}

	{% if blog_post.image %}
		<div class="bg-img" style="background-image: url({{ blog_post.image.full }});"></div>
		<div class="bg-mask"></div>
	{% endif %}

	<div class="content">

		<article class="page">

			<p class="breadcrumbs">
				<a href="{{ site_url() }}">{{ icons('home') }}</a> ›
				<a href="{{ site_url('blog') }}">{{ 'lang.storefront.blog.title'|t }}</a> ›
				{{ blog_post.title }}
			</p>
			<br>

			<h1>{{ blog_post.title }}</h1>
			<p><small class="muted"><em>{{ 'lang.storefront.blog.post_date'|t([blog_post.date|format_datetime('long','none')]) }}</strong></em></small></p>

			<hr>

			{% if blog_post.image %}
				<img class="img-stretched lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ blog_post.image.full }}" alt="{{ blog_post.title|e_attr }}">
				<br><br>
			{% endif %}

			{{ blog_post.text }}

			<br>

			<div class="row-fluid">
				<div class="share">
					<a target="_blank" href="http://www.facebook.com/sharer.php?u={{ blog_post.url }}" class="text-muted">{{ icons('facebook-f', 'fa-lg') }}</a> &nbsp;
					<a target="_blank" href="https://wa.me/?text={{ "#{blog_post.title}: #{blog_post.url}"|url_encode }}" class="text-muted">{{ icons('whatsapp', 'fa-lg') }}</a> &nbsp;
					<a target="_blank" href="https://twitter.com/share?url={{ blog_post.url }}&text={{ character_limiter(description, 100)|url_encode }}" class="text-muted">{{ icons('twitter', 'fa-lg') }}</a> &nbsp;
					<a target="_blank" href="https://pinterest.com/pin/create/bookmarklet/?media={{ blog_post.image.full }}&url={{ blog_post.url }}&description={{ blog_post.title|url_encode }}" class="text-muted">{{ icons('pinterest', 'fa-lg') }}</a>
				</div>
			</div>

			<hr>

			{% if apps.facebook_comments.comments_blog %}
				<div class="boxed hidden-phone">
					<div class="fb-comments" data-href="{{ current_url() }}" data-num-posts="3" data-colorscheme="light" data-width="100%"></div>
				</div>
			{% endif %}

		</article>

	</div>

{% endblock %}