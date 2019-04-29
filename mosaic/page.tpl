{# 
Description: Page
#}

{% extends 'base.tpl' %}

{% block content %}
	
	<div class="content">

		<article class="page">

			<h1>{{ page.title }}</h1>
				
			<hr>

			{{ page.content }}
			
		</article>

	</div>

{% endblock %}