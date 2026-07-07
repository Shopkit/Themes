{#
Description: Contact Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="{{ layout_container }}">

		<h1 class="margin-top-0 margin-bottom">{{ store.page.contact.title }}</h1>

		{% if store.latitude and store.longitude %}
			<div class="location-map margin-bottom">
				<iframe width="100%" title="map" height="400" frameborder="0" scrolling="no" marginheight="0" marginwidth="0" src="https://maps.google.com/?q={{ store.latitude }},{{ store.longitude }}&amp;ie=UTF8&amp;t=m&amp;z=12&amp;output=embed"></iframe>
			</div>
		{% endif %}

		<div class="row">

			<div class="col-sm-3">

				<div>
					{% if store.show_email %}
						<p><strong>{{ 'lang.storefront.form.email.label'|t }}</strong><br>{{ safe_mailto(store.email) }}</p>
					{% endif %}

					{% if store.phone %}
						<p>
							<strong>{{ 'lang.storefront.form.phone.label'|t }}</strong><br>
							<a class="text-link" href="tel:{{ store.phone }}">{{ store.phone }}</a>
						</p>
					{% endif %}

					{% if store.cellphone %}
						<p>
							<strong>{{ 'lang.storefront.form.cellphone.label'|t }}</strong><br>
							<a class="text-link" href="tel:{{ store.cellphone }}">{{ store.cellphone }}</a>
						</p>
					{% endif %}

					{% if store.address %}
						<p>
							<strong>{{ 'lang.storefront.form.address.label'|t }}</strong><br>
							{{ line_break(store.address) }}
						</p>
					{% endif %}
				</div>

				<hr>

				{% if apps.newsletter %}
					<div class="newsletter margin-bottom">
						<h2 class="margin-bottom-md h3">{{ 'lang.storefront.form.newsletter.label'|t }}</h2>

						<div class="form-group">
							<label for="name_newsletter">{{ 'lang.storefront.form.name.placeholder'|t }}</label>
							<input type="text" name="name_newsletter" class="form-control" id="name_newsletter" required>
						</div>

						<div class="form-group">
							<label for="email_newsletter">{{ 'lang.storefront.form.email.label'|t }}</label>
							<input type="email" name="email_newsletter" class="form-control" id="email_newsletter" required>
						</div>

						<button type="button" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} submit-newsletter">{{ 'lang.storefront.form.newsletter.button'|t }}</button>
					</div>
				{% endif %}

				{% if apps.facebook_page %}
					<div class="margin-bottom">
						<div class="fb-page" data-href="{{ apps.facebook_page.facebook_url }}" data-small-header="false" data-adapt-container-width="true" data-hide-cover="false" data-show-facepile="true" data-show-posts="false"><div class="fb-xfbml-parse-ignore"><blockquote cite="{{ apps.facebook_page.facebook_url }}"><a href="{{ apps.facebook_page.facebook_url }}">{{ 'lang.storefront.layout.social.facebook'|t }}</a></blockquote></div></div>
					</div>
				{% endif %}

				<div>
					{% if store.facebook %}
					<p>
						<a href="{{ store.facebook }}" class="link-neutral" target="_blank">
							<span class="fa-stack fa-lg">
								{{ icons('circle', 'fa-stack-2x') }}
								{{ icons('facebook-f', 'fa-stack-1x fa-inverse') }}
							</span>
							{{ 'lang.storefront.layout.social.facebook'|t }}
						</a>
					</p>
					{% endif %}

					{% if store.twitter %}
					<p>
						<a href="{{ store.twitter }}" class="link-neutral" target="_blank">
							<span class="fa-stack fa-lg">
								{{ icons('circle', 'fa-stack-2x') }}
								{{ icons('twitter', 'fa-stack-1x fa-inverse') }}
							</span>
							{{ 'lang.storefront.layout.social.twitter'|t }}
						</a>
					</p>
					{% endif %}

					{% if store.instagram %}
					<p>
						<a href="{{ store.instagram }}" class="link-neutral" target="_blank">
							<span class="fa-stack fa-lg">
								{{ icons('circle', 'fa-stack-2x') }}
								{{ icons('instagram', 'fa-stack-1x fa-inverse') }}
							</span>
							{{ 'lang.storefront.layout.social.instagram'|t }}
						</a>
					</p>
					{% endif %}

					{% if store.pinterest %}
					<p>
						<a href="{{ store.pinterest }}" class="link-neutral" target="_blank">
							<span class="fa-stack fa-lg">
								{{ icons('circle', 'fa-stack-2x') }}
								{{ icons('pinterest', 'fa-stack-1x fa-inverse') }}
							</span>
							{{ 'lang.storefront.layout.social.pinterest'|t }}
						</a>
					</p>
					{% endif %}

					{% if store.youtube %}
					<p>
						<a href="{{ store.youtube }}" class="link-neutral" target="_blank">
							<span class="fa-stack fa-lg">
								{{ icons('circle', 'fa-stack-2x') }}
								{{ icons('youtube', 'fa-stack-1x fa-inverse') }}
							</span>
							{{ 'lang.storefront.layout.social.youtube'|t }}
						</a>
					</p>
					{% endif %}

					{% if store.linkedin %}
					<p>
						<a href="{{ store.linkedin }}" class="link-neutral" target="_blank">
							<span class="fa-stack fa-lg">
								{{ icons('circle', 'fa-stack-2x') }}
								{{ icons('linkedin-square', 'fa-stack-1x fa-inverse') }}
							</span>
							{{ 'lang.storefront.layout.social.linkedin'|t }}
						</a>
					</p>
					{% endif %}

					{% if store.tiktok %}
					<p>
						<a href="{{ store.tiktok }}" class="link-neutral" target="_blank">
							<span class="fa-stack fa-lg">
								{{ icons('circle', 'fa-stack-2x') }}
								{{ icons('tiktok', 'fa-stack-1x fa-inverse') }}
							</span>
							{{ 'lang.storefront.layout.social.tiktok'|t }}
						</a>
					</p>
					{% endif %}

					<p class="link-social-rss">
						<a href="{{ site_url('rss') }}" class="link-neutral" target="_blank">
							<span class="fa-stack fa-lg">
								{{ icons('circle', 'fa-stack-2x') }}
								{{ icons('rss', 'fa-stack-1x fa-inverse') }}
							</span>
							{{ 'lang.storefront.layout.social.rss'|t }}
						</a>
					</p>

				</div>

			</div>

			<div class="col-sm-8 col-sm-offset-1">

				<h2 class="margin-top-0 margin-bottom h3">{{ 'lang.storefront.contact.contact_form.title'|t }}</h2>

				{# withdrawal:start #}
				{% if store.settings.withdrawal_form_active %}
					<div class="callout callout-warning {{ store.theme_options.well_warning_shadow }}" id="withdrawal">
						<h4>{{ 'lang.storefront.withdrawal.block.title'|t }}</h4>
						<p>{{ 'lang.storefront.withdrawal.block.description'|t }}</p>

						<button type="button" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} js-withdrawal-open">
							{{ 'lang.storefront.withdrawal.block.button'|t }}
						</button>
					</div>

					<div class="modal fade" id="withdrawal-modal" tabindex="-1" role="dialog" aria-labelledby="withdrawal-modal-title">
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
										<div class="callout js-withdrawal-result" data-success="callout-success" data-danger="callout-danger" data-default-error="{{ 'lang.storefront.withdrawal.messages.error'|t }}"></div>
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

				{{ form_open('contact_form', { 'class' : 'contact-form', 'id' : 'contact-form' }) }}

					<div>
						<div class="form-group">
							<label for="name">{{ 'lang.storefront.form.name.label'|t }}</label>
							<input type="text" class="form-control" id="name" name="name" placeholder="{{ 'lang.storefront.form.name.placeholder'|t }}" value="{{ store.page.contact.form.name|default(user.name) }}" required>
						</div>

						<div class="form-group">
							<label for="email">{{ 'lang.storefront.form.email.label'|t }}</label>
							<input type="email" class="form-control" id="email" name="email" placeholder="{{ 'lang.storefront.form.email.placeholder'|t }}" value="{{ store.page.contact.form.email|default(user.email) }}" required>
						</div>

						<div class="form-group">
							<label for="subject">{{ 'lang.storefront.form.subject.label'|t }}</label>
							<input type="text" class="form-control" id="subject" name="subject" placeholder="{{ 'lang.storefront.form.subject.placeholder'|t }}" value="{{ store.page.contact.form.subject|default(get.p) }}" required>
						</div>

						<div class="form-group">
							<label for="message">{{ 'lang.storefront.form.message.label'|t }}</label>
							<textarea required class="form-control" id="message" name="message" placeholder="" rows="10">{% if not events.contact_form_success %}{{ get.p ? 'lang.storefront.contact.contact_form.message.default'|t([get.p]) }}{% endif %}</textarea>
						</div>

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

						<div class="form-group">
							<div class="g-recaptcha" id="g-recaptcha-contact"></div>
						</div>

						<button type="submit" class="btn btn-primary {{ store.theme_options.button_primary_shadow }}">{{ 'lang.storefront.form.message.button'|t }}</button>
					</div>

				{{ form_close() }}

				{% if store.page.contact.content %}
					<hr>
					{{ store.page.contact.content }}
				{% endif %}

			</div>

		</div>
	</div>

{% endblock %}