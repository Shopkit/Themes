{#
Description: About page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb well-default">
		<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
		<li class="active">{{ store.page.about.title }}</li>
	</ul>

	<h1>{{ store.page.about.title }}</h1>
	<br>

	{{ store.page.about.content }}

	<hr>

{% endblock %}