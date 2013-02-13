{# 
Description: Blog post Page
#}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb">
		<li><a href="/">Home</a><span class="divider">›</span></li>
		<li><a href="{{ site_url('blog') }}">Blog</a><span class="divider">›</span></li>
		<li class="active">{{ blog_post.title }}</li>
	</ul>

	<h1>{{ blog_post.title }}</h1>
		
	<p><small class="muted"><em>Escrito em <strong>{{ sdate("%d de %M. de %Y", blog_post.date) }}</strong></em></small></p>
		
	<div class="row">
			
		<div class="span6">
			{{ blog_post.text }}
		</div>
			
		{% if blog_post.image %}
			<p class="span3"><a href="{{ blog_post.image }}" class="box-medium fancy"><img src="{{ blog_post.image }}"></a></p>
		{% endif %}
			
	</div>
		
	<hr>
		
	{% if store.facebook_comments_blog %}

		<div class="hidden-phone">
			<h6>Comentários</h6>
			<br>
			<div class="fb-comments" data-href="{{ blog_post.url }}" data-num-posts="5"></div>
		</div>

	{% endif %}


{% endblock %}