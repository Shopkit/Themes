{#
Description: Blog page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set posts_per_page = store.theme_options.posts_per_page ?: 3 %}

	<ul class="breadcrumb well-default">
		<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
		<li class="active">{{ 'lang.storefront.blog.title'|t }}</li>
	</ul>

	<h1>{{ 'lang.storefront.blog.title'|t }}</h1>
	<br>

	{% for post in blog_posts("limit:#{posts_per_page}") %}

		<h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
		<p><small class="muted"><em>{{ 'lang.storefront.blog.post_date'|t([post.date|format_datetime('long','none')]) }}</strong></em></small></p>

		<div class="row">

			<div class="span7">
				{{ word_limiter(post.excerpt, 100, ' ... <a href="' ~ post.url ~ '">' ~ 'lang.storefront.blog.read_more'|t ~'</a>') }}
			</div>

			{% if post.image %}
				<p class="span2"><a href="{{ post.url }}" class="box-medium well-default {{ store.theme_options.well_default_shadow }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ post.image.thumb }}" class="lazy"></a></p>
			{% endif %}

		</div>

		<hr>

	{% else %}

		<h5>{{ 'lang.storefront.blog.no_posts'|t }}</h5>

	{% endfor %}


	{{ pagination("limit:#{posts_per_page}") }}

{% endblock %}