{#
Description: Contact Page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">

		<article class="page">

			<h1>{{ store.page.contact.title }}</h1>

			<hr>

			{% if store.latitude and store.longitude %}
				<div class="location-map">
					<iframe width="100%" height="400" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="https://maps.google.com/?q={{ store.latitude }},{{ store.longitude }}&amp;ie=UTF8&amp;t=m&amp;z=12&amp;output=embed"></iframe>

					<hr>
				</div>
			{% endif %}

			<h3>{{ store.name }}</h3>
			<br>

			<div class="row-fluid">

				<div class="span6">
					{% if store.show_email %}
						<h5>{{ 'lang.storefront.form.email.label'|t }}</h5>
						<p>{{ safe_mailto(store.email) }}</p><br>
					{% endif %}

					{% if store.address %}
						<h5>{{ 'lang.storefront.form.address.label'|t }}</h5>
						<p>{{ store.address|nl2br }}</p>
					{% endif %}
				</div>

				<div class="span6">
					{% if store.phone %}
						<h5>{{ 'lang.storefront.form.phone.label'|t }}</h5>
						<p><a href="tel:{{ store.phone }}">{{ store.phone }}</a></p><br>
					{% endif %}

					{% if store.cellphone %}
						<h5>{{ 'lang.storefront.form.cellphone.label'|t }}</h5>
						<p><a href="tel:{{ store.cellphone }}">{{ store.cellphone }}</a></p><br>
					{% endif %}
				</div>

			</div>

			{% if store.page.contact.content %}
				<hr>
				{{ store.page.contact.content }}
			{% endif %}

			<hr>

			<h4 class="here">{{ 'lang.storefront.contact.contact_form.title'|t }}</h4>
			<br>

			{{ form_open('contact_form', 'class="contact-form" id="contact-form"') }}

				<label for="name">{{ 'lang.storefront.form.name.label'|t }} <small class="muted">(*)</small></label>
				<input type="text" name="name" id="name" class="input-block-level" placeholder="{{ 'lang.storefront.form.name.placeholder'|t }}" value="{{ store.page.contact.form.name|default(user.name) }}" required>
				<br><br>

				<label for="email">{{ 'lang.storefront.form.email.label'|t }} <small class="muted">(*)</small></label>
				<input type="email" name="email" id="email" class="input-block-level" placeholder="{{ 'lang.storefront.form.email.placeholder'|t }}" value="{{ store.page.contact.form.email|default(user.email) }}" required>
				<br><br>

				<label for="subject">{{ 'lang.storefront.form.subject.label'|t }} <small class="muted">(*)</small></label>
				<input type="text" name="subject" id="subject" class="input-block-level" placeholder="{{ 'lang.storefront.form.subject.placeholder'|t }}" value="{{ store.page.contact.form.subject|default(get.p) }}" required>
				<br><br>

				<label for="message">{{ 'lang.storefront.form.message.label'|t }} <small class="muted">(*)</small></label>
				<textarea rows="6" class="input-block-level" id="message" name="message" required>{% if not events.contact_form_success %}{{ get.p ? 'lang.storefront.contact.contact_form.message.default'|t([get.p]) }}{% endif %}</textarea>

				{% if store.settings.cart.page_terms or store.settings.cart.page_privacy %}
					<div class="accept_terms checkbox">
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

				<div class="g-recaptcha margin-top margin-bottom" id="g-recaptcha-contact"></div>

				<button type="submit" class="button btn-primary {{ store.theme_options.button_primary_shadow }}" style="width:175px">
					<span>{{ 'lang.storefront.form.message.button'|t }}</span>
					{{ icons('envelope') }}
				</button>

			{{ form_close() }}

			{% if apps.facebook_page %}
				<hr>
				<div class="fb-page" data-href="{{ apps.facebook_page.facebook_url }}" data-small-header="false" data-adapt-container-width="true" data-hide-cover="false" data-show-facepile="true"><blockquote cite="{{ apps.facebook_page.facebook_url }}" class="fb-xfbml-parse-ignore"><a href="{{ apps.facebook_page.facebook_url }}">{{ 'lang.storefront.layout.social.facebook'|t }}</a></blockquote></div>
			{% endif %}

		</article>

	</div>

{% endblock %}