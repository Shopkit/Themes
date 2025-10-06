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

	<h1><a href="{{ site_url('blog') }}" class="link-inherit">{{ 'lang.storefront.blog.title'|t }}</a></h1>
	{% set posts = blog_posts("limit:#{posts_per_page}") %}
	{% if get.id_author and posts[0] %}
		<p class="text-muted">{{ 'lang.storefront.blog.written_by'|t([posts[0].author.name]) }}</p>
	{% endif %}
	{% if get.tag and posts[0] %}
		<p class="text-muted">{{ 'lang.storefront.blog.tag'|t([get.tag]) }}</p>
	{% endif %}
	<br>

	{% for post in posts %}

		<h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
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

		<div class="row">

			<div class="span7 blog-text">
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