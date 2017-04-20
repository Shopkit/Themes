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
				<a href="/"><i class="fa fa-home"></i></a> ›
				<a href="{{ site_url('blog') }}">Blog</a> › 
				{{ blog_post.title }}
			</p>
			<br>

			<h1>{{ blog_post.title }}</h1>
			<p><small class="muted"><em>Escrito em <strong>{{ blog_post.date|date("d \\d\\e M. \\d\\e Y") }}</strong></em></small></p>

			<hr>

			{% if blog_post.image %}
				<img class="img-stretched" src="{{ blog_post.image.full }}" alt="{{ blog_post.title }}">
				<br><br>
			{% endif %}

			{{ blog_post.text }}

			<br>

			<div class="row-fluid visible-desktop">
				<div class="span3">
					<div class="fb-like" data-send="true" data-width="" data-show-faces="false" data-font="tahoma" data-layout="button_count" data-action="like"></div>
				</div>

				<div class="span2">
					<div class="g-plusone" data-size="medium"></div>
				</div>

				<div class="span2">
					<a href="http://twitter.com/share" class="twitter-share-button" data-count="none" data-lang="pt">Tweet</a>
				</div>

				<div class="span2">
					<a href="http://pinterest.com/pin/create/button/?url={{ blog_post.url }}&media={{ blog_post.image.full }}&description={{ description }}" class="pin-it-button" count-layout="horizontal"><img border="0" src="//assets.pinterest.com/images/PinExt.png" title="Pin It" /></a>
				</div>
			</div>

			<hr>

			{% if apps.facebook_comments.comments_blog %}
				<div class="boxed hidden-phone">
					<div class="fb-comments" data-href="{{ current_url() }}" data-num-posts="3" data-colorscheme="light" data-width="100%"></div>
				</div>
			{% endif %}

		</article>

		<script>
		Modernizr.load([
			{load: '//platform.twitter.com/widgets.js'},
			{load: '//apis.google.com/js/plusone.js'},
			{load: '//assets.pinterest.com/js/pinit.js'}
		]);
		</script>

	</div>

{% endblock %}