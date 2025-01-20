{#
Description: Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="{{ layout_container }}">

		<div class="row">
			<div class="col-sm-10 col-sm-offset-1 col-md-8 col-md-offset-2">

				<h1 class="margin-bottom">{{ page.title }}</h1>

				<div>
					{{ page.content }}
				</div>

			</div>
		</div>
	</div>

{% endblock %}