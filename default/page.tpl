{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

<ul class="breadcrumb well-default">
	<li>
		<a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span>
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