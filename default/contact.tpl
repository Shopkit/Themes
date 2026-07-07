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

	<h2 class="h3">{{ store.name }}</h2>
	<br>

	<div class="row">
		<div class="span4">
			{% if store.show_email %}
				<h3 class="h4">{{ 'lang.storefront.form.email.label'|t }}</h3>
				<p>{{ safe_mailto(store.email) }}</p><br>
			{% endif %}

			{% if store.phone %}
				<h3 class="h4">{{ 'lang.storefront.form.phone.label'|t }}</h3>
				<p><a href="tel:{{ store.phone }}">{{ store.phone }}</a></p><br>
			{% endif %}

			{% if store.cellphone %}
				<h3 class="h4">{{ 'lang.storefront.form.cellphone.label'|t }}</h3>
				<p><a href="tel:{{ store.cellphone }}">{{ store.cellphone }}</a></p><br>
			{% endif %}

			{% if store.address %}
				<h3 class="h4">{{ 'lang.storefront.form.address.label'|t }}</h3>
				<p>{{ store.address|nl2br }}</p>
			{% endif %}
		</div>
		<div class="span5">
			<h3 class="h4">{{ 'lang.storefront.contact.contact_form.title'|t }}</h3>
			<br>

			{# withdrawal:start #}
			{% if store.settings.withdrawal_form_active %}
				<div class="alert alert-warning {{ store.theme_options.well_warning_shadow }}" id="withdrawal">
					<h4>{{ 'lang.storefront.withdrawal.block.title'|t }}</h4>
					<p>{{ 'lang.storefront.withdrawal.block.description'|t }}</p>

					<button type="button" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} js-withdrawal-open">
						{{ 'lang.storefront.withdrawal.block.button'|t }}
					</button>
				</div>

				<div class="modal hide fade" id="withdrawal-modal" tabindex="-1" role="dialog" aria-labelledby="withdrawal-modal-title">
					<div class="modal-dialog" role="document">
						<div class="modal-content text-left">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-label="{{ 'lang.storefront.layout.button.close'|t }}"><span aria-hidden="true">&times;</span></button>
								<h3 class="modal-title" id="withdrawal-modal-title">{{ 'lang.storefront.withdrawal.modal.title'|t }}</h3>
							</div>
							{{ form_open(site_url('withdrawal_form'), { 'id' : 'withdrawal-form', 'method' : 'post' }) }}
								<input type="hidden" name="confirmed" value="0">

								<div class="modal-body js-withdrawal-step1">
									<div class="form-group">
										<label for="withdrawal-name">{{ 'lang.storefront.form.name.label'|t }} <small class="muted">(*)</small></label>
										<input type="text" name="name" id="withdrawal-name" class="form-control input-block-level" placeholder="{{ 'lang.storefront.form.name.placeholder'|t }}" value="{{ user.name|e_attr }}" required>
									</div>
									<div class="form-group">
										<label for="withdrawal-email">{{ 'lang.storefront.form.email.label'|t }} <small class="muted">(*)</small></label>
										<input type="email" name="email" id="withdrawal-email" class="form-control input-block-level" placeholder="{{ 'lang.storefront.form.email.placeholder'|t }}" value="{{ user.email|e_attr }}" required>
									</div>
									<div class="form-group">
										<label for="withdrawal-order-number">{{ 'lang.storefront.withdrawal.form.order_number.label'|t }} <small class="muted">(*)</small></label>
										<input type="text" name="order_number" id="withdrawal-order-number" class="form-control input-block-level" placeholder="{{ 'lang.storefront.withdrawal.form.order_number.help'|t }}" required>
									</div>
									<div class="form-group">
										<label>{{ 'lang.storefront.withdrawal.scope.label'|t }}</label>
										<div class="radio"><label><input type="radio" name="scope" value="all" checked> {{ 'lang.storefront.withdrawal.scope.all'|t }}</label></div>
										<div class="radio"><label><input type="radio" name="scope" value="some"> {{ 'lang.storefront.withdrawal.scope.some'|t }}</label></div>
									</div>
									<div class="form-group">
										<label for="withdrawal-products">{{ 'lang.storefront.withdrawal.products.label'|t }}</label>
										<textarea name="products" id="withdrawal-products" rows="2" class="form-control input-block-level" placeholder="{{ 'lang.storefront.withdrawal.products.help'|t }}"></textarea>
									</div>
									<div class="form-group">
										<label for="withdrawal-notes">{{ 'lang.storefront.withdrawal.notes.label'|t }}</label>
										<textarea name="notes" id="withdrawal-notes" rows="2" class="form-control input-block-level" placeholder="{{ 'lang.storefront.withdrawal.notes.help'|t }}"></textarea>
									</div>
								</div>

								<div class="modal-body js-withdrawal-step2 hidden">
									<p class="text-info">{{ 'lang.storefront.withdrawal.review.intro'|t }}</p>
									<div class="withdrawal-recap">
										<p><strong>{{ 'lang.storefront.form.name.label'|t }}:</strong> <span class="js-recap-name"></span></p>
										<p><strong>{{ 'lang.storefront.form.email.label'|t }}:</strong> <span class="js-recap-email"></span></p>
										<p><strong>{{ 'lang.storefront.withdrawal.form.order_number.label'|t }}:</strong> <span class="js-recap-order"></span></p>
										<p><strong>{{ 'lang.storefront.withdrawal.scope.label'|t }}:</strong> <span class="js-recap-scope"></span></p>
										<p class="js-recap-products-row"><strong>{{ 'lang.storefront.withdrawal.products.label'|t }}:</strong> <span class="js-recap-products"></span></p>
										<p class="js-recap-notes-row"><strong>{{ 'lang.storefront.withdrawal.notes.label'|t }}:</strong> <span class="js-recap-notes"></span></p>
									</div>
									<div class="g-recaptcha margin-top-xs margin-bottom-sm" id="g-recaptcha-withdrawal"></div>
								</div>

								<div class="modal-body js-withdrawal-step3 hidden">
									<div class="alert js-withdrawal-result" data-success="alert-success" data-danger="alert-danger" data-default-error="{{ 'lang.storefront.withdrawal.messages.error'|t }}"></div>
								</div>

								<div class="modal-footer">
									<button type="button" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} js-withdrawal-continue js-withdrawal-step1">{{ 'lang.storefront.withdrawal.continue'|t }}</button>
									<button type="button" class="btn btn-default js-withdrawal-back js-withdrawal-step2 hidden">{{ 'lang.storefront.withdrawal.back'|t }}</button>
									<button type="button" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} js-withdrawal-confirm js-withdrawal-step2 hidden">{{ 'lang.storefront.withdrawal.confirm_button'|t }}</button>
									<button type="button" class="btn btn-default js-withdrawal-back-result js-withdrawal-step3 hidden">{{ 'lang.storefront.withdrawal.back'|t }}</button>
								</div>
							{{ form_close() }}
						</div>
					</div>
				</div>
			{% endif %}
			{# withdrawal:end #}

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
					<iframe width="100%" title="map" height="400" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="https://maps.google.com/?q={{ store.latitude }},{{ store.longitude }}&amp;ie=UTF8&amp;t=m&amp;z=12&amp;output=embed"></iframe>
				</div>
			</div>
		</div>

	{% endif %}

{% endblock %}