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
				<a href="{{ site_url() }}"><i class="fa fa-home"></i></a> ›
				<a href="{{ site_url('blog') }}">Blog</a> ›
				{{ blog_post.title }}
			</p>
			<br>

			<h1>{{ blog_post.title }}</h1>
			<p><small class="muted"><em>Escrito em <strong>{{ blog_post.date|date("d \\d\\e M. \\d\\e Y") }}</strong></em></small></p>

			<hr>

			{% if blog_post.image %}
				<img class="img-stretched" src="{{ blog_post.image.full }}" alt="{{ blog_post.title|e_attr }}">
				<br><br>
			{% endif %}

			{{ blog_post.text }}

			<br>

			<div class="row-fluid">
				<div class="share">
					<a target="_blank" href="http://www.facebook.com/sharer.php?u={{ blog_post.url }}" class="text-muted"><i class="fa fa-facebook fa-fw fa-lg"></i></a> &nbsp;
					<a target="_blank" href="https://wa.me/?text={{ "#{blog_post.title}: #{blog_post.url}"|url_encode }}" class="text-muted"><i class="fa fa-lg fa-whatsapp fa-fw"></i></a> &nbsp;
					<a target="_blank" href="https://twitter.com/share?url={{ blog_post.url }}&text={{ character_limiter(description, 100)|url_encode }}" class="text-muted"><i class="fa fa-twitter fa-fw fa-lg"></i></a> &nbsp;
					<a target="_blank" href="https://pinterest.com/pin/create/bookmarklet/?media={{ blog_post.image.full }}&url={{ blog_post.url }}&description={{ blog_post.title|url_encode }}" class="text-muted"><i class="fa fa-pinterest fa-fw fa-lg"></i></a>
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