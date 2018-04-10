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
				<p class="small">Escrito em {{ blog_post.date|date("d \\d\\e M. \\d\\e Y") }}</p>

				<article class="margin-top">

					{% if blog_post.image %}
						<div class="image-post margin-bottom">
							<img src="{{ blog_post.image.full }}" alt="{{ blog_post.title }}" title="{{ blog_post.title }}" class="img-responsive border-radius">
						</div>
					{% endif %}

					<div>
						{{ blog_post.text }}
					</div>

					<hr>

					<div class="share">
						<a target="_blank" href="http://www.facebook.com/sharer.php?u={{ blog_post.url }}" class="text-muted"><i class="fa fa-facebook fa-fw fa-lg"></i></a> &nbsp; 
						<a target="_blank" href="https://twitter.com/share?url={{ blog_post.url }}&text={{ character_limiter(description, 100) }}" class="text-muted"><i class="fa fa-twitter fa-fw fa-lg"></i></a> &nbsp; 
						<a target="_blank" href="https://plus.google.com/share?url={{ blog_post.url }}" class="text-muted"><i class="fa fa-google-plus fa-fw fa-lg"></i></a> &nbsp; 
						<a target="_blank" href="https://pinterest.com/pin/create/bookmarklet/?media={{ blog_post.image.full }}&url={{ blog_post.url }}&description={{ blog_post.title }}" class="text-muted"><i class="fa fa-pinterest fa-fw fa-lg"></i></a>
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