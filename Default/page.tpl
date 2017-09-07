{% extends 'base.tpl' %}

{% block content %}

<ul class="breadcrumb">
	<li>
		<a href="/">Home</a><span class="divider">›</span>
	</li>
	<li class="active">
		{{ page.title }}
	</li>
</ul>
		
<h1>{{ page.title }}</h1>
<br>		
{{ page.content }}

<hr>

{% endblock %}