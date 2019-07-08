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
				<iframe width="100%" height="400" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="https://maps.google.com/?q={{ store.latitude }},{{ store.longitude }}&amp;ie=UTF8&amp;t=m&amp;z=12&amp;output=embed"></iframe>

				<hr>
			{% endif %}

			<h3>{{ store.name }}</h3>
			<br>

			<div class="row-fluid">

				<div class="span6">
					{% if store.show_email %}
						<h5>E-mail</h5>
						<p>{{ safe_mailto(store.email) }}</p><br>
					{% endif %}

					{% if store.address %}
						<h5>Morada</h5>
						<p>{{ store.address|nl2br }}</p>
					{% endif %}
				</div>

				<div class="span6">
					{% if store.phone %}
						<h5>Telefone</h5>
						<p>{{ store.phone }}</p><br>
					{% endif %}

					{% if store.cellphone %}
						<h5>Telemóvel</h5>
						<p>{{ store.cellphone }}</p><br>
					{% endif %}
				</div>

			</div>

			{% if store.page.contact.content %}
				<hr>
				{{ store.page.contact.content }}
			{% endif %}

			<hr>

			<h4 class="here">Formulário de Contacto</h4>
			<br>

			{{ form_open('contact_form', 'class="contact-form" id="contact-form"') }}

				<label for="name">Nome <small class="muted">(*)</small></label>
				<input type="text" name="name" id="name" class="input-block-level" placeholder="O seu nome" value="{{ store.page.contact.form.name|default(user.name) }}" required>
				<br><br>

				<label for="email">E-mail <small class="muted">(*)</small></label>
				<input type="email" name="email" id="email" class="input-block-level" placeholder="Endereço de e-mail" value="{{ store.page.contact.form.email|default(user.email) }}" required>
				<br><br>

				<label for="subject">Assunto <small class="muted">(*)</small></label>
				<input type="text" name="subject" id="subject" class="input-block-level" placeholder="Assunto do contacto" value="{{ store.page.contact.form.subject|default(get.p) }}" required>
				<br><br>

				<label for="message">Mensagem <small class="muted">(*)</small></label>
				<textarea rows="6" class="input-block-level" id="message" name="message" required>{% if not events.contact_form_success %}{{ get.p ? "Desejo receber mais informações sobre #{get.p}" }}{% endif %}</textarea>

				<div class="g-recaptcha margin-top margin-bottom" id="g-recaptcha-contact"></div>

				<button type="submit" class="button" style="width:175px">
					<span>Enviar Mensagem</span>
					<i class="fa fa-envelope"></i>
				</button>

			{{ form_close() }}

			{% if apps.facebook_page %}
				<hr>
				<div class="fb-page" data-href="{{ apps.facebook_page.facebook_url }}" data-small-header="false" data-adapt-container-width="true" data-hide-cover="false" data-show-facepile="true"><blockquote cite="{{ apps.facebook_page.facebook_url }}" class="fb-xfbml-parse-ignore"><a href="{{ apps.facebook_page.facebook_url }}">Facebook</a></blockquote></div>
			{% endif %}

		</article>

	</div>

{% endblock %}