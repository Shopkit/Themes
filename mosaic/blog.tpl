{#
Description: Blog page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">

		<section class="page">

			<h1>Blog</h1>

			<hr>

			{% for post in blog_posts() %}

				<article class="break-word clearfix">

					<h2><a href="{{ post.url }}">{{ post.title }}</a></h2>
					<p><small class="muted"><em>Escrito em <strong>{{ post.date|date("d \\d\\e F \\d\\e Y") }}</strong></em></small></p>

					<div class="row-fluid">

						<div class="span9">
							{{ word_limiter(post.excerpt, 100, ' ... <a href="' ~ post.url ~ '">Ler mais</a>') }}
						</div>

						{% if post.image %}
							<p class="span3"><a href="{{ post.url }}"><img class="boxed lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ post.image.thumb }}" alt="{{ post.title|e_attr }}"></a></p>
						{% endif %}

					</div>

				</article>

				<hr>

			{% else %}

				<h5>Não existem entradas no blog.</h5>

			{% endfor %}

		</section>

	</div>

{% endblock %}