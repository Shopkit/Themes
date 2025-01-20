{#
Description: Contact Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb well-default">
		<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
		<li class="active">{{ store.page.contact.title }}</li>
	</ul>

	<h1>{{ store.page.contact.title }}</h1>
	<br>

	<h4>{{ store.name }}</h4>
	<br>

	<div class="row">
		<div class="span4">
			{% if store.show_email %}
				<h5>{{ 'lang.storefront.form.email.label'|t }}</h5>
				<p>{{ safe_mailto(store.email) }}</p><br>
			{% endif %}

			{% if store.phone %}
				<h5>{{ 'lang.storefront.form.phone.label'|t }}</h5>
				<p><a href="tel:{{ store.phone }}">{{ store.phone }}</a></p><br>
			{% endif %}

			{% if store.cellphone %}
				<h5>{{ 'lang.storefront.form.cellphone.label'|t }}</h5>
				<p><a href="tel:{{ store.cellphone }}">{{ store.cellphone }}</a></p><br>
			{% endif %}

			{% if store.address %}
				<h5>{{ 'lang.storefront.form.address.label'|t }}</h5>
				<p>{{ store.address|nl2br }}</p>
			{% endif %}
		</div>
		<div class="span5">
			<h5>{{ 'lang.storefront.contact.contact_form.title'|t }}</h5>
			<br>

			{{ form_open('contact_form', 'class="contact-form" id="contact-form"') }}
				<label for="name">{{ 'lang.storefront.form.name.label'|t }} <small class="muted">(*)</small></label>
				<input type="text" name="name" id="name" class="span5" placeholder="{{ 'lang.storefront.form.name.placeholder'|t }}" value="{{ store.page.contact.form.name|default(user.name) }}" required>

				<label for="email">{{ 'lang.storefront.form.email.label'|t }} <small class="muted">(*)</small></label>
				<input type="email" name="email" id="email" class="span5" placeholder="{{ 'lang.storefront.form.email.placeholder'|t }}" value="{{ store.page.contact.form.email|default(user.email) }}" required>

				<label for="subject">{{ 'lang.storefront.form.subject.label'|t }} <small class="muted">(*)</small></label>
				<input type="text" name="subject" id="subject" class="span5" placeholder="{{ 'lang.storefront.form.subject.placeholder'|t }}" value="{{ store.page.contact.form.subject|default(get.p) }}" required>

				<label for="message">{{ 'lang.storefront.form.message.label'|t }} <small class="muted">(*)</small></label>
				<textarea rows="6" class="span5" id="message" name="message" required>{% if not events.contact_form_success %}{{ get.p ? 'lang.storefront.contact.contact_form.message.default'|t([get.p]) }}{% endif %}</textarea>

				{% if store.settings.cart.page_terms or store.settings.cart.page_privacy %}
					<div class="checkbox">
						<label>
							<input type="checkbox" name="accept_terms" id="accept_terms" value="1" required>

							{% if store.settings.cart.page_terms and store.settings.cart.page_privacy %}
                                {{ 'lang.storefront.cart.terms_privacy'|t([store.settings.cart.page_terms.url, store.settings.cart.page_privacy.url]) }}
                            {% elseif store.settings.cart.page_terms and not store.settings.cart.page_privacy %}
                                {{ 'lang.storefront.cart.terms'|t([store.settings.cart.page_terms.url]) }}
                            {% elseif store.settings.cart.page_privacy and not store.settings.cart.terms %}
                                {{ 'lang.storefront.cart.privacy'|t([store.settings.cart.page_privacy.url]) }}
                            {% endif %}
						</label>
					</div>
				{% endif %}

				<div class="g-recaptcha margin-top-xs margin-bottom-sm" id="g-recaptcha-contact"></div>

				<button type="submit" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} btn-large">{{ 'lang.storefront.form.message.button'|t }}</button>
			{{ form_close() }}

		</div>
	</div>

	<hr>

	{{ store.page.contact.content }}

	{% if store.latitude and store.longitude %}
		<div class="location-map">
			<hr>
			<div class="row">
				<div class="span9">
					<h4>{{ 'lang.storefront.contact.map.title'|t }}</h4><br>
					<iframe width="100%" height="400" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="https://maps.google.com/?q={{ store.latitude }},{{ store.longitude }}&amp;ie=UTF8&amp;t=m&amp;z=12&amp;output=embed"></iframe>
				</div>
			</div>
		</div>

	{% endif %}

{% endblock %}