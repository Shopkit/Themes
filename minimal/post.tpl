{#
Description: Blog post Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="{{ layout_container }}">

		<div class="row">
			<div class="col-sm-10 col-sm-offset-1 col-md-8 col-md-offset-2">

				<a href="{{ site_url('blog') }}" class="text-muted"><i class="fa fa-angle-left"></i> &nbsp; {{ 'lang.storefront.blog.title'|t }}</a>

				<h1 class="margin-top-sm"><a href="{{ blog_post.url }}" class="link-inherit">{{ blog_post.title }}</a></h1>
				<p class="small">{{ 'lang.storefront.blog.post_date'|t([blog_post.date|format_datetime('long','none')]) }}</p>

				<article class="margin-top">

					{% if blog_post.image %}
						<div class="image-post margin-bottom">
							<img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ blog_post.image.full }}" alt="{{ blog_post.title|e_attr }}" title="{{ blog_post.title|e_attr }}" class="img-responsive border-radius lazy">
						</div>
					{% endif %}

					<div>
						{{ blog_post.text }}
					</div>

					<hr>

					<div class="share">
						<a target="_blank" href="http://www.facebook.com/sharer.php?u={{ blog_post.url }}" class="text-muted"><i class="fa fa-facebook fa-fw fa-lg"></i></a> &nbsp;
						<a target="_blank" href="https://wa.me/?text={{ "#{blog_post.title}: #{blog_post.url}"|url_encode }}" class="text-muted"><i class="fa fa-whatsapp fa-fw fa-lg"></i></a> &nbsp;
						<a target="_blank" href="https://twitter.com/share?url={{ blog_post.url }}&text={{ character_limiter(description, 100)|url_encode }}" class="text-muted"><i class="fa fa-twitter fa-fw fa-lg"></i></a> &nbsp;
						<a target="_blank" href="https://pinterest.com/pin/create/bookmarklet/?media={{ blog_post.image.full }}&url={{ blog_post.url }}&description={{ blog_post.title|url_encode }}" class="text-muted"><i class="fa fa-pinterest fa-fw fa-lg"></i></a>
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