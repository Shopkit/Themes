{# 
Description: About page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="container">	
		
		<h1>{{ store.page.about.title }}</h1>

		<div class="row">

			<div class="col-sm-7">
				<div class="page-content">
					{{ store.page.about.content }}
				</div>
			</div>

			<div class="col-sm-4 col-sm-offset-1">

				{% if store.description %}
    				<p class="lead margin-bottom">{{ store.description }}</p>
    			{% endif %}

				{% if store.facebook_likebox %}
					<div class="margin-bottom">
						<div class="fb-page" data-href="{{ store.facebook }}" data-small-header="false" data-adapt-container-width="true" data-hide-cover="false" data-show-facepile="true" data-show-posts="false"><div class="fb-xfbml-parse-ignore"><blockquote cite="{{ store.facebook }}"><a href="{{ store.facebook }}">Facebook</a></blockquote></div></div>

						<div id="fb-root"></div>
						<script>(function(d, s, id) {
						  var js, fjs = d.getElementsByTagName(s)[0];
						  if (d.getElementById(id)) return;
						  js = d.createElement(s); js.id = id;
						  js.src = "//connect.facebook.net/pt_PT/sdk.js#xfbml=1&version=v2.3&appId=267439666615965";
						  fjs.parentNode.insertBefore(js, fjs);
						}(document, 'script', 'facebook-jssdk'));</script>
					</div>
				{% endif %}
				
				<ul class="social">
					{% if store.facebook %}
						<li><a href="{{ store.facebook }}" target="_blank" title="Facebook"><i class="fa fa-facebook fa-fw fa-lg"></i></a></li>
					{% endif %}

					{% if store.twitter %}
						<li><a href="{{ store.twitter }}" target="_blank" title="Twitter"><i class="fa fa-twitter fa-fw fa-lg"></i></a></li>
					{% endif %}

					{% if store.instagram %}
						<li><a href="{{ store.instagram }}" target="_blank" title="Instagram"><i class="fa fa-instagram fa-fw fa-lg"></i></a></li>
					{% endif %}

					{% if store.pinterest %}
						<li><a href="{{ store.pinterest }}" target="_blank" title="Pinterest"><i class="fa fa-pinterest fa-fw fa-lg"></i></a></li>
					{% endif %}
				</ul>

			</div>

		</div>
	</div>

{% endblock %}