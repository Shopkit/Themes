{# 
Description: About page
#}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb">
		<li><a href="/">Home</a><span class="divider">›</span></li>
		<li class="active">{{ store.page.about.title }}</li>
	</ul>
			
	<h1>{{ store.page.about.title }}</h1>
	<br>		
	
	{{ store.page.about.content }}

	<hr>

{% endblock %}