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
			{% endif %}

			<hr>

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
						<h5>Telemovel</h5>
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
				<input type="text" name="name" id="name" class="input-block-level" required>
				<br><br>
				
				<label for="email">E-mail <small class="muted">(*)</small></label>
				<input type="email" name="email" id="email" class="input-block-level" required>
				<br><br>
				
				<label for="subject">Assunto <small class="muted">(*)</small></label>
				<input type="text" name="subject" id="subject" class="input-block-level" value="{% if not notices.contact_form_success %}{{ get.p }}{% endif %}" required>
				<br><br>
				
				<label for="message">Mensagem <small class="muted">(*)</small></label>
				<textarea rows="6" class="input-block-level" id="message" name="message" required>{% if not notices.contact_form_success %}{{ get.p ? "Desejo receber mais informações sobre o produto #{get.p}" }}{% endif %}</textarea>
				
				<br>

				<div class="g-recaptcha" data-sitekey="{{ apps.google_recaptcha.sitekey }}"></div>

				<br>

				<button type="submit" class="button" style="width:175px">
					<span>Enviar Mensagem</span>
					<i class="fa fa-envelope"></i>
				</button>
				
			{{ form_close() }}

			{% if apps.facebook_page %}
				<hr>
				<div class="fb-like-box" data-width="690" data-height="250" data-href="{{ apps.facebook_page.facebook_url }}" data-show-faces="true" data-show-border="false" data-stream="false" data-header="false"></div>
			{% endif %}
			
		</article>

	</div>

{% endblock %}