{#
Description: About page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set social_on_page_about = store.theme_options.social_on_page_about == 'show' ? 'hidden' : 'show' %}

	<div class="{{ layout_container }}">

		<h1>{{ store.page.about.title }}</h1>

		<div class="row">

			<div class="col-sm-{{ social_on_page_about == 'show' ? '7' : '12' }}">
				<div class="page-content">
					{{ store.page.about.content }}
				</div>
			</div>

			<div class="col-sm-4 col-sm-offset-1 {{ social_on_page_about }}">

				{% if store.description %}
    				<p class="lead margin-bottom">{{ store.description }}</p>
    			{% endif %}

				{% if apps.facebook_page %}
					<div class="margin-bottom">
						<div class="fb-page" data-href="{{ apps.facebook_page.facebook_url }}" data-small-header="false" data-adapt-container-width="true" data-hide-cover="false" data-show-facepile="true" data-show-posts="false"><div class="fb-xfbml-parse-ignore"><blockquote cite="{{ apps.facebook_page.facebook_url }}"><a href="{{ apps.facebook_page.facebook_url }}">{{ 'lang.storefront.layout.social.facebook'|t }}</a></blockquote></div></div>
					</div>
				{% endif %}

				<ul class="social">
					{% if store.facebook %}
						<li><a href="{{ store.facebook }}" target="_blank" title="{{ 'lang.storefront.layout.social.facebook'|t }}"><i class="fa fa-facebook fa-fw fa-lg"></i></a></li>
					{% endif %}

					{% if store.twitter %}
						<li><a href="{{ store.twitter }}" target="_blank" title="{{ 'lang.storefront.layout.social.twitter'|t }}"><i class="fa fa-twitter fa-fw fa-lg"></i></a></li>
					{% endif %}

					{% if store.instagram %}
						<li><a href="{{ store.instagram }}" target="_blank" title="{{ 'lang.storefront.layout.social.instagram'|t }}"><i class="fa fa-instagram fa-fw fa-lg"></i></a></li>
					{% endif %}

					{% if store.pinterest %}
						<li><a href="{{ store.pinterest }}" target="_blank" title="{{ 'lang.storefront.layout.social.pinterest'|t }}"><i class="fa fa-pinterest fa-fw fa-lg"></i></a></li>
					{% endif %}

					{% if store.youtube %}
						<li><a href="{{ store.youtube }}" target="_blank" title="{{ 'lang.storefront.layout.social.youtube'|t }}"><i class="fa fa-youtube-play fa-fw fa-lg"></i></a></li>
					{% endif %}

					{% if store.linkedin %}
						<li><a href="{{ store.linkedin }}" target="_blank" title="{{ 'lang.storefront.layout.social.linkedin'|t }}"><i class="fa fa-linkedin-square fa-fw fa-lg"></i></a></li>
					{% endif %}

					{% if store.tiktok %}
						<li><a href="{{ store.tiktok }}" target="_blank" title="{{ 'lang.storefront.layout.social.tiktok'|t }}"><i class="fa fa-tiktok fa-fw fa-lg"></i></a></li>
					{% endif %}

					<li class="link-social-rss"><a href="{{ site_url('rss') }}" target="_blank" title="{{ 'lang.storefront.layout.social.rss'|t }}"><i class="fa fa-rss fa-fw"></i></a></li>
				</ul>

			</div>

		</div>
	</div>

{% endblock %}