{# 
Description: Blog post Page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="container">	

		<div class="row">
			<div class="col-sm-10 col-sm-offset-1 col-md-8 col-md-offset-2">

				<a href="{{ site_url('blog') }}" class="text-light-gray"><i class="fa fa-angle-left"></i> &nbsp; Blog</a>

				<h1 class="margin-top-sm"><a href="{{ blog_post.url }}" class="link-inherit">{{ blog_post.title }}</a></h1>
				<p class="small">Escrito em {{ post.date|date("d \\d\\e M. \\d\\e Y") }}</p>

				<article class="margin-top">

					{% if blog_post.image %}
						<div class="image-post margin-bottom">
							<img src="{{ blog_post.image }}" alt="{{ blog_post.title }}" title="{{ blog_post.title }}" class="img-responsive border-radius">
						</div>
					{% endif %}

					<div>
						{{ blog_post.text }}
					</div>

					<hr>

					<div class="share">
						<a target="_blank" href="http://www.facebook.com/sharer.php?u={{ product.url }}" class="text-muted"><i class="fa fa-facebook fa-fw fa-lg"></i></a> &nbsp; 
						<a target="_blank" href="https://twitter.com/share?url={{ product.url }}&text={{ character_limiter(description, 100) }}" class="text-muted"><i class="fa fa-twitter fa-fw fa-lg"></i></a> &nbsp; 
						<a target="_blank" href="https://plus.google.com/share?url={{ product.url }}" class="text-muted"><i class="fa fa-google-plus fa-fw fa-lg"></i></a> &nbsp; 
						<a target="_blank" href="https://pinterest.com/pin/create/bookmarklet/?media={{ product.image.full }}&url={{ product.url }}&description={{ product.title }}" class="text-muted"><i class="fa fa-pinterest fa-fw fa-lg"></i></a>
					</div>
				</article>

				{% if apps.facebook_comments.comments_blog %}
					<div class="margin-top">
						<div class="fb-comments" data-href="{{ blog_post.url }}" data-numposts="5" data-width="100%"></div>
					</div>
						<div id="fb-root"></div>
						<script>(function(d, s, id) {
						  var js, fjs = d.getElementsByTagName(s)[0];
						  if (d.getElementById(id)) return;
						  js = d.createElement(s); js.id = id;
						  js.src = "//connect.facebook.net/pt_PT/sdk.js#xfbml=1&version=v2.3&appId=267439666615965";
						  fjs.parentNode.insertBefore(js, fjs);
						}(document, 'script', 'facebook-jssdk'));</script>
				{% endif %}

			</div>

		</div>

	</div>

{% endblock %}