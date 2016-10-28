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
				<div class="fb-like-box" data-width="690" data-height="250" data-href="{{ apps.facebook_page.facebook_url }}" data-show-faces="true" data-show-border="false" data-stream="false" data-header="false"></div>
			{% endif %}
			
		</section>

	</div>


{% endblock %}