{#
Description: About page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">

		<section class="page">

			<h1>{{ store.page.about.title }}</h1>

			{% if store.gallery %}
				<hr>

				<div class="flexslider">
					<ul class="slides">
						{% for gallery in store.gallery %}
							{% set has_slide_content = gallery.title or gallery.button or gallery.description ? 'has-slide-content' %}
							<li class="slide">
								<img src="{{ gallery.image.full }}">
								{% if has_slide_content %}
								<div class="slide-content">
									{% if gallery.title %}
										{% if gallery.link %}
											<h4 class="slide-title"><a href="{{ gallery.link }}">{{ gallery.title }}</a></h4>
										{% else %}
											<h4 class="slide-title">{{ gallery.title }}</h4>
										{% endif %}
									{% endif %}
									{% if gallery.description %}
										<div class="slide-description">{{ gallery.description }}</div>
									{% endif %}
									{% if gallery.button %}
										<div class="slide-button">
											<a href="{{ gallery.button_link }}" class="button btn-outline-white">{{ gallery.button }}</a>
										</div>
									{% endif %}
								</div>
							{% endif %}
							</li>
						{% endfor %}
					</ul>
				</div>

			{% endif %}

			<hr>

			{{ store.page.about.content }}

			{% if apps.facebook_page %}
				<hr>
				<div class="fb-page" data-href="{{ apps.facebook_page.facebook_url }}" data-small-header="false" data-adapt-container-width="true" data-hide-cover="false" data-show-facepile="true"><blockquote cite="{{ apps.facebook_page.facebook_url }}" class="fb-xfbml-parse-ignore"><a href="{{ apps.facebook_page.facebook_url }}">Facebook</a></blockquote></div>
			{% endif %}

		</section>

	</div>


{% endblock %}