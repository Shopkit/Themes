{# 
Description: Blog page
#}

{% extends 'base.tpl' %}

{% block content %}

	{% set posts_per_page = 3 %}

	<div class="container">	

		<div class="row">
			<div class="col-sm-10 col-sm-offset-1 col-md-8 col-md-offset-2">

				<h1 class="margin-bottom">Blog</h1>

				{% for post in blog_posts("limit:#{posts_per_page}") %} 

					<article class="blog-post">

						{% if post.image %}
							<div class="image-post">
								<a href="{{ post.url }}"><img src="{{ post.image.full }}" alt="{{ post.title|e_attr }}" title="{{ post.title|e_attr }}"></a>
							</div>
						{% endif %}

						<div class="description">
							<h4><a href="{{ post.url }}">{{ post.title }}</a></h4>
							<p class="small">Escrito em {{ post.date|date("d \\d\\e M. \\d\\e Y") }}</p>
							
							<div>
								{{ word_limiter(post.excerpt, 100, ' ... <a href="' ~ post.url ~ '">Ler mais</a>') }}
							</div>
						</div>

					</article>

				{% else %}
					<p class="h2 text-center light text-light-grey margin-top-lg">Não existem posts.</p>
				{% endfor %}

				<nav class="text-center">
					{{ pagination("limit:#{posts_per_page}") }}	
				</nav>

			</div>

		</div>

	</div>
		
{% endblock %}

