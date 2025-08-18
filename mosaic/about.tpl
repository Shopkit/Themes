{#
Description: About page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">

		<section class="page">

			<h1>{{ store.page.about.title }}</h1>

			<hr>

			{% if store.gallery or store.theme_options.mobile_gallery %}
				<div class="slideshow">
					<div class="flexslider">
						<ul class="slides"></ul>
					</div>
				</div>

				<hr>

			{% endif %}

			{{ store.page.about.content }}

			{% if apps.facebook_page %}
				<hr>
				<div class="fb-page" data-href="{{ apps.facebook_page.facebook_url }}" data-small-header="false" data-adapt-container-width="true" data-hide-cover="false" data-show-facepile="true"><blockquote cite="{{ apps.facebook_page.facebook_url }}" class="fb-xfbml-parse-ignore"><a href="{{ apps.facebook_page.facebook_url }}">{{ 'lang.storefront.layout.social.facebook'|t }}</a></blockquote></div>
			{% endif %}

		</section>

	</div>


{% endblock %}