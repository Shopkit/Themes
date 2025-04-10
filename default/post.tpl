{#
Description: Blog post Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb well-default">
		<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
		<li><a href="{{ site_url('blog') }}">{{ 'lang.storefront.blog.title'|t }}</a><span class="divider">›</span></li>
		<li class="active">{{ blog_post.title }}</li>
	</ul>

	<h1>{{ blog_post.title }}</h1>

	<p><small class="muted"><em>{{ 'lang.storefront.blog.post_date'|t([blog_post.date|format_datetime('long','none')]) }}</strong></em></small></p>

	<div class="row">

		<div class="span6">
			{{ blog_post.text }}
		</div>

		{% if blog_post.image %}
			<p class="span3"><a href="{{ blog_post.image.full }}" class="box-medium well-default {{ store.theme_options.well_default_shadow }} fancy"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ blog_post.image.thumb }}" alt="{{ blog_post.title|e_attr }}" class="lazy"></a></p>
		{% endif %}

	</div>

	<br>

	<div class="share visible-desktop">
		<a target="_blank" href="http://www.facebook.com/sharer.php?u={{ blog_post.url }}" class="text-muted">{{ icons('facebook-f', 'fa-lg') }}</a> &nbsp;
		<a target="_blank" href="https://wa.me/?text={{ "#{blog_post.title}: #{blog_post.url}"|url_encode }}" class="text-muted">{{ icons('whatsapp', 'fa-lg') }}</a> &nbsp;
		<a target="_blank" href="https://twitter.com/share?url={{ blog_post.url }}&text={{ character_limiter(description, 100)|url_encode }}" class="text-muted">{{ icons('twitter', 'fa-lg') }}</a> &nbsp;
		<a target="_blank" href="https://pinterest.com/pin/create/bookmarklet/?media={{ blog_post.image.full }}&url={{ blog_post.url }}&description={{ blog_post.title|url_encode }}" class="text-muted">{{ icons('pinterest', 'fa-lg') }}</a>
	</div>

	{% if apps.facebook_comments.comments_blog %}
		<div class="hidden-phone">
			<hr>
			<div class="fb-comments" data-href="{{ current_url() }}" data-num-posts="5" data-colorscheme="light" data-width="100%"></div>
		</div>
	{% endif %}

{% endblock %}