{# 
Description: Blog page
#}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb">
		<li><a href="/">Home</a><span class="divider">›</span></li>
		<li class="active">Blog</li>
	</ul>

	<h1>Blog</h1>
	<br>

	{% for post in blog_posts("limit:9") %} 
			
		<h3><a href="{{ post.url }}">{{ post.title }}</a></h3>
		<p><small class="muted"><em>Escrito em <strong>{{ sdate("%d de %M. de %Y", post.date) }}</strong></em></small></p>
		
		<div class="row">
			
			<div class="span7">
				{{ word_limiter(post.text, 100, ' ... <a href="' ~ post.url ~ '">Ler mais</a>') }}
			</div>
			
			{% if post.image %}
				<p class="span2"><a href="{{ post.url }}" class="box-medium"><img src="{{ post.image }}"></a></p>
			{% endif %}
			
		</div>
		
		<hr>
		
	{% else %}
		
		<h5>Não existem entradas no blog.</h5>
		
	{% endfor %}

	
	{{ pagination("limit:9") }}	
	
{% endblock %}