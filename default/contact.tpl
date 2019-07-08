{#
Description: Contact Page
#}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb">
		<li><a href="/">Home</a><span class="divider">›</span></li>
		<li class="active">{{ store.page.contact.title }}</li>
	</ul>

	<h1>{{ store.page.contact.title }}</h1>
	<br>

	<h4>{{ store.name }}</h4>
	<br>

	<div class="row">
		<div class="span4">
			{% if store.show_email %}
				<h5>E-mail</h5>
				<p>{{ safe_mailto(store.email) }}</p><br>
			{% endif %}

			{% if store.phone %}
				<h5>Telefone</h5>
				<p>{{ store.phone }}</p><br>
			{% endif %}

			{% if store.cellphone %}
				<h5>Telemóvel</h5>
				<p>{{ store.cellphone }}</p><br>
			{% endif %}

			{% if store.address %}
				<h5>Morada</h5>
				<p>{{ store.address|nl2br }}</p>
			{% endif %}
		</div>
		<div class="span5">
			<h5>Formulário de Contacto</h5>
			<br>

			{{ form_open('contact_form', 'class="contact-form" id="contact-form"') }}
				<label for="name">Nome <small class="muted">(*)</small></label>
				<input type="text" name="name" id="name" class="span5" placeholder="O seu nome" value="{{ store.page.contact.form.name|default(user.name) }}" required>

				<label for="email">E-mail <small class="muted">(*)</small></label>
				<input type="email" name="email" id="email" class="span5" placeholder="Endereço de e-mail" value="{{ store.page.contact.form.email|default(user.email) }}" required>

				<label for="subject">Assunto <small class="muted">(*)</small></label>
				<input type="text" name="subject" id="subject" class="span5" placeholder="Assunto do contacto" value="{{ store.page.contact.form.subject|default(get.p) }}" required>

				<label for="message">Mensagem <small class="muted">(*)</small></label>
				<textarea rows="6" class="span5" id="message" name="message" required>{% if not events.contact_form_success %}{{ get.p ? "Desejo receber mais informações sobre #{get.p}" }}{% endif %}</textarea>

				<div class="g-recaptcha margin-top-xs margin-bottom-sm" id="g-recaptcha-contact"></div>

				<button type="submit" class="btn btn-large">Enviar Mensagem</button>
			{{ form_close() }}

		</div>
	</div>

	<hr>

	{{ store.page.contact.content }}

	{% if store.latitude and store.longitude %}
		<hr>
		<div class="row">
			<div class="span9">
				<h4>Mapa de Localização</h4><br>
				<iframe width="100%" height="400" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="https://maps.google.com/?q={{ store.latitude }},{{ store.longitude }}&amp;ie=UTF8&amp;t=m&amp;z=12&amp;output=embed"></iframe>
			</div>
		</div>

	{% endif %}

{% endblock %}