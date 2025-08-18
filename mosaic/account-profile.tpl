{#
Description: Account profile page
#}

{% import 'account.tpl' as account_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">
		<div class="row-fluid">

			<div class="span12">

				<p class="breadcrumbs">
					<a href="{{ site_url() }}">{{ icons('home') }}</a> ›
					<a href="{{ site_url('account') }}">{{ 'lang.storefront.account.my_account'|t }}</a> ›
					{{ 'lang.storefront.layout.client.title'|t }}
				</p><br>

				<h1>{{ 'lang.storefront.layout.greetings'|t }} <strong>{{ user.name|first_word }}</strong>.</h1>

				{% if errors.form %}
					<div class="alert alert-error {{ store.theme_options.well_danger_shadow }}">
						<button type="button" class="close" data-dismiss="alert">×</button>
						<h5>{{ 'lang.storefront.layout.events.form.error'|t }}</h5>
						{{ errors.form }}
					</div>
				{% endif %}

				{% if events.client.save_profile_success %}
					<div class="alert alert-success {{ store.theme_options.well_success_shadow }}">
						<p>{{ 'lang.storefront.layout.events.client.save_profile_success'|t }}</p>
					</div>
				{% endif %}

				{% if store.settings.rewards.newsletter and not user.subscribe_newsletter %}
					{% if store.settings.rewards.message_newsletter %}
						<div class="alert alert-info">
							<i class="icon margin-right-xxs">{{ icons('trophy') }}</i>
							{{ store.settings.rewards.message_newsletter|rewards_message(store.settings.rewards.newsletter_ratio) }}
						</div>
					{% endif %}
				{% endif %}

				{{ form_open('account/save-profile', {'role': 'form'}) }}

					<h3>{{ 'lang.storefront.layout.client.title'|t }}</h3>

					<div class="row-fluid">
						<div class="span6">
							<div class="form-group">
								<label for="delivery_name">{{ 'lang.storefront.form.name.label'|t }} <small class="text-light-gray normal">(*)</small></label>
								<input type="text" name="name" id="name" class="form-control span12" value="{{ user.name }}" required>
							</div>
						</div>
						<div class="span6">
							<div class="form-group">
								<label for="email">{{ 'lang.storefront.form.email.label'|t }} <small class="text-light-gray normal">(*)</small></label>
								<input type="email" name="email" id="email" class="form-control span12" value="{{ user.email }}" required>
							</div>
						</div>
					</div>

					<div class="row-fluid">
						{% if store.settings.cart.field_company != 'hidden' %}
							<div class="span6">
								<div class="form-group">
									<label for="company">{{ 'lang.storefront.order.client.company'|t }} {{ store.settings.cart.field_company == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
									<input type="text" name="company" id="company" class="form-control span12" value="{{ user.company }}" placeholder="{{ store.settings.cart.field_company == 'optional' ? 'lang.storefront.form.optional.placeholder'|t }}" {{ store.settings.cart.field_company == 'required' ? 'required' }}>
								</div>
							</div>
						{% endif %}

						{% if store.settings.cart.field_fiscal_id != 'hidden' %}
							<div class="span6">
								<div class="form-group">
									<label for="fiscal_id">{{ user.l10n.tax_id_abbr }} {{ store.settings.cart.field_fiscal_id == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
									<input type="text" name="fiscal_id" id="fiscal_id" class="form-control span12" value="{{ user.fiscal_id }}" placeholder="{{ store.settings.cart.field_fiscal_id == 'optional' ? 'lang.storefront.form.optional.placeholder'|t }}" {{ store.settings.cart.field_fiscal_id == 'required' ? 'required' }}>
								</div>
							</div>
						{% endif %}
					</div>

					<div class="row-fluid">
						<div class="span6">
							<div class="form-group">
								<label for="locale">{{ 'lang.storefront.form.language.label'|t }} <small class="text-light-gray normal">(*)</small></label>
								<select name="locale" id="locale" class="form-control span12" required>
									{% for key, name in locales %}
										<option value="{{ key }}" {% if user.locale == key %} selected {% endif %}>{{ name }}</option>
									{% endfor %}
								</select>
							</div>
						</div>
						<div class="span6">
							<div class="form-group">
								<label for="gender">{{ 'lang.storefront.form.gender.label'|t }}</label>
								<select name="gender" id="gender" class="form-control span12">
									<option value=""></option>
									<option value="female" {% if user.gender == 'female' %} selected {% endif %}>{{ 'lang.storefront.form.gender.female'|t }}</option>
									<option value="male" {% if user.gender == 'male' %} selected {% endif %}>{{ 'lang.storefront.form.gender.male'|t }}</option>
									<option value="other" {% if user.gender == 'other' %} selected {% endif %}>{{ 'lang.storefront.form.gender.other'|t }}</option>
								</select>
							</div>
						</div>
					</div>

					<div class="row-fluid">
						<div class="span6">
							<div class="form-group">
								<label for="birthday">{{ 'lang.storefront.form.birthday.label'|t }}</label>
								<input type="date" name="birthday" id="birthday" class="form-control span12" value="{{ user.birthday }}" {{ store.settings.rewards.anniversary and user.birthday ? 'disabled' : '' }}>
							</div>
						</div>
						<div class="span6">
							{% if apps.newsletter %}
								<label for="locale">{{ 'lang.storefront.form.newsletter.label'|t }}</label>
								<div class="checkbox">
									<label>
										<input type="checkbox" name="subscribe_newsletter" id="subscribe_newsletter" value="1" {% if user.subscribe_newsletter %} checked {% endif %}>
										{{ apps.newsletter.label }}
									</label>
								</div>
							{% endif %}
						</div>
					</div>

					<div class="row-fluid">
						<div class="span6">
							<div class="form-group">
								<label for="password">{{ 'lang.storefront.form.password.label'|t }}</label>
								<input type="password" name="password" id="password" class="form-control span12">
							</div>
						</div>
						<div class="span6">
							<div class="form-group">
								<label for="repeat_password">{{ 'lang.storefront.form.repeat_password.label'|t }}</label>
								<input type="password" name="repeat_password" id="repeat_password" class="form-control span12">
							</div>
						</div>
					</div>

					<h3>{{ 'lang.storefront.order.delivery.address'|t }}</h3>
					<div class="delivery-info">
						<div class="row-fluid">
							<div class="span8">
								<div class="form-group">
									<label for="delivery_name">{{ 'lang.storefront.form.name.label'|t }} <small class="text-light-gray normal">(*)</small></label>
									<input type="text" name="delivery_name" id="delivery_name" class="form-control span12" value="{{ user.delivery.name|default(user.name) }}" required>
								</div>
							</div>
							{% if store.settings.cart.field_delivery_phone != 'hidden' %}
								<div class="span4">
									<div class="form-group">
										<label for="delivery_phone">{{ 'lang.storefront.form.phone.label'|t }} {{ store.settings.cart.field_delivery_phone == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
										<input type="tel" name="delivery_phone" id="delivery_phone" class="form-control span12 intl-validate" value="{{ user.delivery.phone }}" placeholder="{{ store.settings.cart.field_delivery_phone == 'optional' ? 'lang.storefront.form.optional.placeholder'|t }}" {{ store.settings.cart.field_delivery_phone == 'required' ? 'required' }}>
									</div>
								</div>
							{% endif %}
						</div>

						<div class="row-fluid">
							<div class="span12">
								<div class="form-group">
									<label for="delivery_address">{{ 'lang.storefront.form.address.label'|t }} <small class="text-light-gray normal">(*)</small></label>
									<div class="row-fluid">
										<div class="span8">
											<input type="text" id="delivery_address" class="form-control span12" placeholder="{{ 'lang.storefront.form.address.label'|t }}" name="delivery_address" value="{{ user.delivery.address }}" data-places="route" required>
										</div>
										<div class="span4">
											<input type="text" class="form-control span12" placeholder="{{ 'lang.storefront.form.address.extra.placeholder'|t }}" name="delivery_address_extra" id="delivery_address_extra" value="{{ user.delivery.address_extra }}" autocomplete="off">
										</div>
									</div>
								</div>
							</div>
						</div>

						<div class="row-fluid">
							<div class="span3">
								<div class="form-group">
									<label for="delivery_zip_code">{{ 'lang.storefront.form.zip_code.label'|t }} <small class="text-light-gray normal">(*)</small></label>
									<input type="text" name="delivery_zip_code" id="delivery_zip_code" class="form-control span12" value="{{ user.delivery.zip_code }}" data-places="postal_code" required>
								</div>
							</div>
							<div class="span5">
								<div class="form-group">
									<label for="delivery_city">{{ 'lang.storefront.form.city.label'|t }} <small class="text-light-gray normal">(*)</small></label>
									<input type="text" name="delivery_city" id="delivery_city" class="form-control span12" value="{{ user.delivery.city }}" data-places="locality" required>
								</div>
							</div>
							<div class="span4">
								<div class="form-group">
									<label for="delivery_country">{{ 'lang.storefront.form.country.label'|t }} <small class="text-light-gray normal">(*)</small></label>
									<select name="delivery_country" id="delivery_country" class="form-control span12" required>
										<option value selected disabled>{{ 'lang.storefront.form.country.select.default'|t }}</option>
										{% for key, country in countries %}
											<option value="{{ key }}" {% if user.delivery.country_code == key %} selected {% endif %}>{{ country }}</option>
										{% endfor %}
									</select>
								</div>
							</div>
						</div>
					</div>

					<h3>{{ 'lang.storefront.order.billing.address'|t }}</h3>
					<div class="checkbox margin-bottom">
						<label>
							<input type="checkbox" name="billing_info_same_delivery" id="billing_info_same_delivery" value="1" {% if user.billing.same_as_delivery %} checked {% endif %} data-target=".billing-info">
							{{ 'lang.storefront.order.billing_info_same_delivery'|t }}
						</label>
					</div>
					<div class="{% if user.billing.same_as_delivery %}hidden{% endif %} billing-info">
						<div class="row-fluid">
							<div class="span8">
								<div class="form-group">
									<label for="billing_name">{{ 'lang.storefront.form.name.label'|t }} <small class="text-light-gray normal">(*)</small></label>
									<input type="text" name="billing_name" id="billing_name" class="form-control span12" value="{{ user.billing.name }}">
								</div>
							</div>
							{% if store.settings.cart.field_billing_phone != 'hidden' %}
								<div class="span4">
									<div class="form-group">
										<label for="billing_phone">{{ 'lang.storefront.form.phone.label'|t }} {{ store.settings.cart.field_billing_phone == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
										<input type="tel" name="billing_phone" id="billing_phone" class="form-control span12 intl-validate" value="{{ user.billing.phone }}" placeholder="{{ store.settings.cart.field_billing_phone == 'optional' ? 'lang.storefront.form.optional.placeholder'|t }}">
									</div>
								</div>
							{% endif %}
						</div>

						<div class="row-fluid">
							<div class="span12">
								<div class="form-group">
									<label for="billing_address">{{ 'lang.storefront.form.address.label'|t }} <small class="text-light-gray normal">(*)</small></label>
									<div class="row-fluid">
										<div class="span8">
											<input type="text" id="billing_address" class="form-control span12" placeholder="{{ 'lang.storefront.form.address.label'|t }}" name="billing_address" value="{{ user.billing.address }}" data-places="route">
										</div>
										<div class="span4">
											<input type="text" class="form-control span12" placeholder="{{ 'lang.storefront.form.address.extra.placeholder'|t }}" name="billing_address_extra" id="billing_address_extra" value="{{ user.billing.address_extra }}">
										</div>
									</div>
								</div>
							</div>
						</div>

						<div class="row-fluid">
							<div class="span3">
								<div class="form-group">
									<label for="billing_zip_code">{{ 'lang.storefront.form.zip_code.label'|t }} <small class="text-light-gray normal">(*)</small></label>
									<input type="text" name="billing_zip_code" id="billing_zip_code" class="form-control span12" value="{{ user.billing.zip_code }}" data-places="postal_code">
								</div>
							</div>
							<div class="span5">
								<div class="form-group">
									<label for="billing_city">{{ 'lang.storefront.form.city.label'|t }} <small class="text-light-gray normal">(*)</small></label>
									<input type="text" name="billing_city" id="billing_city" class="form-control span12" value="{{ user.billing.city }}" data-places="locality">
								</div>
							</div>
							<div class="span4">
								<div class="form-group">
									<label for="billing_country">{{ 'lang.storefront.form.country.label'|t }} <small class="text-light-gray normal">(*)</small></label>
									<select name="billing_country" id="billing_country" class="form-control span12">
										<option value selected disabled>{{ 'lang.storefront.form.country.select.default'|t }}</option>
										{% for key, country in countries %}
											<option value="{{ key }}" {% if user.billing.country_code == key %} selected {% endif %}>{{ country }}</option>
										{% endfor %}
									</select>
								</div>
							</div>
						</div>
					</div>

					<hr>

					<footer class="clearfix">
						<div class=" margin-top-xxs pull-left">
							<a href="{{ site_url('account/delete') }}" class="text-error small" onclick="return confirm('{{ 'lang.storefront.account.profile.delete_account.confirm'|t }}')">{{ icons('trash') }} {{ 'lang.storefront.account.profile.delete_account.text'|t }}</a>
						</div>
						<button class="button btn-primary {{ store.theme_options.button_primary_shadow }} pull-right">{{ 'lang.storefront.account.profile.save_data'|t }}</button>
					</footer>
				{{ form_close() }}
			</div>

		</div>
	</div>

{% endblock %}