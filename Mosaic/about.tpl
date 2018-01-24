{# 
Description: About page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">

		<section class="page">

			<h1>{{ store.page.about.title }}</h1>

			{% if store.image_header_1 or store.image_header_2 or store.image_header_3 %}
				<hr>

				<div class="flexslider">
					<ul class="slides">
						{% if store.image_header_1 %}<li><img src="{{ store.image_header_1 }}" alt="{{ store.name }}"></li>{% endif %}
						{% if store.image_header_2 %}<li><img src="{{ store.image_header_2 }}" alt="{{ store.name }}"></li>{% endif %}
						{% if store.image_header_3 %}<li><img src="{{ store.image_header_3 }}" alt="{{ store.name }}"></li>{% endif %}
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