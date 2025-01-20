{#
Description: Order data form page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">

		<section class="page">

			<p class="breadcrumbs">
				<a href="{{ site_url() }}"><i class="fa fa-home"></i></a> ›
				<a href="{{ site_url('cart') }}">{{ 'lang.storefront.cart.title'|t }}</a> ›
				{{ 'lang.storefront.cart.data.title'|t }}
			</p><br>

			<h1>{{ 'lang.storefront.cart.data.title'|t }}</h1>

			<hr>

			{% if errors.form %}
				<div class="alert alert-error {{ store.theme_options.well_danger_shadow }}">
					<button type="button" class="close" data-dismiss="alert">×</button>
					<h5>{{ 'lang.storefront.layout.events.form.error'|t }}</h5>
					{{ errors.form }}
				</div>
			{% endif %}

			{% if warnings.form %}
				<div class="alert alert-warning {{ store.theme_options.well_warning_shadow }}">
					<button type="button" class="close" data-dismiss="alert">×</button>
					<h5>{{ 'lang.storefront.layout.events.form.warning'|t }}</h5>
					{{ warnings.form }}
				</div>
			{% endif %}

			{% if success.form %}
				<div class="alert alert-success {{ store.theme_options.well_success_shadow }}">
					<button type="button" class="close" data-dismiss="alert">×</button>
					<h5>{{ 'lang.storefront.layout.events.form.success'|t }}</h5>
					{{ success.form }}
				</div>
			{% endif %}

			{{ generic_macros.cart_notice() }}

			{{ form_open('cart/post/payment', {'class': 'form'}) }}

				<input type="hidden" name="user-auth-data" value="true">

				{% if not user.is_logged_in %}
					{% if store.settings.cart.users_registration == 'optional' %}
						<div class="well well-default {{ store.theme_options.well_default_shadow }}">
							{{ 'lang.storefront.cart.data.users_registration.optional'|t([site_url('signin')]) }}
						</div>
					{% elseif store.settings.cart.users_registration == 'required' %}
						<div class="well well-default {{ store.theme_options.well_default_shadow }}">
							{{ 'lang.storefront.cart.data.users_registration.required'|t([site_url('signin')]) }}
						</div>
					{% endif %}
				{% endif %}

				{% if store.settings.cart.users_registration != 'required' or user.is_logged_in %}

					{% if user.is_logged_in %}
						{# If user is logged in, no need to show the form #}
						<div class="row-fluid">
							<div class="span12">
								<h4>{{ 'lang.storefront.cart.checkout.client.title'|t }}</h4>
								{{ user.email }}<br>
								{{ user.l10n.tax_id_abbr }}: {{ user.fiscal_id ? user.fiscal_id : 'n/a' }}<br>
								{{ 'lang.storefront.order.client.company'|t }}: {{ user.company ? user.company : 'n/a' }}
							</div>
						</div>
						<div class="row-fluid">
							<div class="span6">
								<h4 class="margin-top">{{ 'lang.storefront.order.delivery.address'|t }}</h4>
								{% if user.delivery.address %}
									<p>
										{{ user.delivery.name }}<br>
										{{ user.delivery.address }} {{ user.delivery.address_extra }}<br>
										{{ user.delivery.zip_code }} {{ user.delivery.city }}<br>
										{{ user.delivery.country }}
									</p>
									<p>
										{{ user.delivery.phone ? 'lang.storefront.form.phone.label'|t ~ ': ' ~ user.delivery.phone : '' }}
									</p>
								{% else %}
									<p>{{ 'lang.storefront.order.delivery.no_address'|t }}</p>
								{% endif %}
								<a href="{{ site_url('account/profile') }}">{{ 'lang.storefront.order.edit'|t }}</a>
							</div>
							<div class="span6">
								<h4 class="margin-top">{{ 'lang.storefront.order.billing.address'|t }}</h4>
								{% if user.billing.address %}
									<p>
										{{ user.billing.name }}<br>
										{{ user.billing.address }} {{ user.billing.address_extra }}<br>
										{{ user.billing.zip_code }} {{ user.billing.city }}<br>
										{{ user.billing.country }}
									</p>
									<p>
										{{ user.billing.phone ? 'lang.storefront.form.phone.label'|t ~ ': ' ~ user.billing.phone : '' }}
									</p>
								{% else %}
									<p>{{ 'lang.storefront.order.billing.no_address'|t }}</p>
								{% endif %}
								<a href="{{ site_url('account/profile') }}">{{ 'lang.storefront.order.edit'|t }}</a>
							</div>
						</div>
						<br>

					{% else %}
						<h4 class="margin-bottom">{{ 'lang.storefront.cart.checkout.client.title'|t }}</h4>

						<div class="row-fluid">
							<div class="span12 margin-bottom-sm">
								<label for="email">{{ 'lang.storefront.form.email.label'|t }} <small class="muted">(*)</small></label>
								<input type="email" name="email" id="email" class="input-block-level" value="{{ user.email }}" required>

								{% if apps.newsletter %}
									<br>
									<label class="checkbox"><input type="checkbox" name="subscribe_newsletter" id="subscribe_newsletter" value="1" {% if user.subscribe_newsletter %} checked {% endif %}> {{ apps.newsletter.label }}</label>
								{% endif %}
							</div>
						</div>

						<div class="row-fluid">
							{% if store.settings.cart.field_company != 'hidden' %}
								<div class="span7">
									<label for="company">{{ 'lang.storefront.order.client.company'|t }} {{ store.settings.cart.field_company == 'required' ? '<small class="muted">(*)</small>' }}</label>
									<input type="text" name="company" id="company" class="input-block-level" value="{{ user.company }}" placeholder="{{ store.settings.cart.field_company == 'optional' ? 'lang.storefront.form.optional.placeholder'|t }}" {{ store.settings.cart.field_company == 'required' ? 'required' }}>
								</div>
							{% endif %}

							{% if store.settings.cart.field_fiscal_id != 'hidden' %}
								<div class="span5">
									<label for="fiscal_id">{{ user.l10n.tax_id_abbr }} {{ store.settings.cart.field_fiscal_id == 'required' ? '<small class="muted">(*)</small>' }}</label>
									<input type="text" name="fiscal_id" id="fiscal_id" class="input-block-level" value="{{ user.fiscal_id }}" placeholder="{{ store.settings.cart.field_fiscal_id == 'optional' ? 'lang.storefront.form.optional.placeholder'|t }}" {{ store.settings.cart.field_fiscal_id == 'required' ? 'required' }}>
								</div>
							{% endif %}
						</div>

						{% if not cart.is_digital %}
							<h4 class="margin-bottom">{{ 'lang.storefront.order.delivery.address'|t }}</h4>

							<div class="delivery-info">
								<div class="row-fluid">
									<div class="span7">
										<label for="delivery_name">{{ 'lang.storefront.form.name.label'|t }} <small class="muted">(*)</small></label>
										<input type="text" name="delivery_name" id="delivery_name" class="input-block-level" value="{{ user.delivery.name }}" required>
									</div>
								{% if store.settings.cart.field_delivery_phone != 'hidden' %}
									<div class="span5">
										<label for="delivery_phone">{{ 'lang.storefront.form.phone.label'|t }} {{ store.settings.cart.field_delivery_phone == 'required' ? '<small class="muted">(*)</small>' }}</label>
										<input type="tel" name="delivery_phone" id="delivery_phone" class="input-block-level intl-validate" value="{{ user.delivery.phone }}" placeholder="{{ store.settings.cart.field_delivery_phone == 'optional' ? 'lang.storefront.form.optional.placeholder'|t }}" {{ store.settings.cart.field_delivery_phone == 'required' ? 'required' }}>
									</div>
								{% endif %}
								</div>

								<div class="row-fluid">
									<div class="span12">
										<label for="morada">{{ 'lang.storefront.form.address.label'|t }} <small class="muted">(*)</small></label>
										<div class="row-fluid">
											<div class="span7">
												<input type="text" name="delivery_address" id="delivery_address" class="input-block-level" placeholder="{{ 'lang.storefront.form.address.label'|t }}" value="{{ user.delivery.address }}" data-places="route" required>
											</div>
											<div class="span5">
												<input type="text" name="delivery_address_extra" id="delivery_address_extra" class="input-block-level" placeholder="{{ 'lang.storefront.form.address.extra.placeholder'|t }}" value="{{ user.delivery.address_extra }}" autocomplete="off">
											</div>
										</div>
									</div>
								</div>

								<div class="row-fluid">
									<div class="span3">
										<label for="delivery_zip_code">{{ 'lang.storefront.form.zip_code.label'|t }} <small class="muted">(*)</small></label>
										<input type="text" name="delivery_zip_code" id="delivery_zip_code" class="input-block-level" value="{{ user.delivery.zip_code }}" data-places="postal_code" required>
									</div>

									<div class="span4">
										<label for="delivery_city">{{ 'lang.storefront.form.city.label'|t }} <small class="muted">(*)</small></label>
										<input type="text" name="delivery_city" id="delivery_city" class="input-block-level" value="{{ user.delivery.city }}" data-places="locality" required>
									</div>

									<div class="span5">
										<label for="delivery_country">{{ 'lang.storefront.form.country.label'|t }} <small class="muted">(*)</small></label>
										<select name="delivery_country" id="delivery_country" class="input-block-level" required>
											<option value selected disabled>{{ 'lang.storefront.form.country.select.default'|t }}</option>
											{% for key, country in countries %}
												<option value="{{ key }}" {% if user.delivery.country_code == key %} selected {% endif %}>{{ country }}</option>
											{% endfor %}
										</select>
									</div>
								</div>
							</div>
						{% endif %}

						<h4 class="margin-bottom">{{ 'lang.storefront.order.billing.address'|t }}</h4>
						{% if not cart.is_digital %}
							<div class="checkbox margin-bottom">
								<label>
									<input type="checkbox" name="billing_info_same_delivery" id="billing_info_same_delivery" value="1" {% if not user.billing.same_as_delivery is same as(false) %} checked {% endif %} data-target=".billing-info">
									{{ 'lang.storefront.order.billing_info_same_delivery'|t }}
								</label>
							</div>
						{% endif %}

						<div class="{% if not cart.is_digital and not user.billing.same_as_delivery is same as(false) %}hidden{% endif %} billing-info">
							<div class="row-fluid">
								<div class="span7">
									<label for="billing_name">{{ 'lang.storefront.form.name.label'|t }} <small class="muted">(*)</small></label>
									<input type="text" name="billing_name" id="billing_name" class="input-block-level" value="{{ user.billing.name }}">
								</div>

								{% if store.settings.cart.field_billing_phone != 'hidden' %}
									<div class="span5">
										<label for="billing_phone">{{ 'lang.storefront.form.phone.label'|t }} {{ store.settings.cart.field_billing_phone == 'required' ? '<small class="muted">(*)</small>' }}</label>
										<input type="tel" name="billing_phone" id="billing_phone" class="input-block-level intl-validate" value="{{ user.billing.phone }}" placeholder="{{ store.settings.cart.field_billing_phone == 'optional' ? 'lang.storefront.form.optional.placeholder'|t }}">
									</div>
								{% endif %}
							</div>

							<div class="row-fluid">
								<div class="span12">
									<label for="morada">{{ 'lang.storefront.form.address.label'|t }} <small class="muted">(*)</small></label>
									<div class="row-fluid">
										<div class="span7">
											<input type="text" name="billing_address" id="billing_address" class="input-block-level" placeholder="{{ 'lang.storefront.form.address.label'|t }}" value="{{ user.billing.address }}" data-places="route">
										</div>
										<div class="span5">
											<input type="text" name="billing_address_extra" id="billing_address_extra" class="input-block-level" placeholder="{{ 'lang.storefront.form.address.extra.placeholder'|t }}" value="{{ user.billing.address_extra }}" autocomplete="off">
										</div>
									</div>
								</div>
							</div>

							<div class="row-fluid">
								<div class="span3">
									<label for="billing_zip_code">{{ 'lang.storefront.form.zip_code.label'|t }} <small class="muted">(*)</small></label>
									<input type="text" name="billing_zip_code" id="billing_zip_code" class="input-block-level" value="{{ user.billing.zip_code }}" data-places="postal_code">
								</div>

								<div class="span4">
									<label for="billing_city">{{ 'lang.storefront.form.city.label'|t }} <small class="muted">(*)</small></label>
									<input type="text" name="billing_city" id="billing_city" class="input-block-level" value="{{ user.billing.city }}" data-places="locality">
								</div>

								<div class="span5">
									<label for="billing_country">{{ 'lang.storefront.form.country.label'|t }} <small class="muted">(*)</small></label>
									<select name="billing_country" id="billing_country" class="input-block-level">
										<option value selected disabled>{{ 'lang.storefront.form.country.select.default'|t }}</option>
										{% for key, country in countries %}
											<option value="{{ key }}" {% if user.billing.country_code == key %} selected {% endif %}>{{ country }}</option>
										{% endfor %}
									</select>
								</div>
							</div>
							<br>
						</div>

					{% endif %}

					<div class="row-fluid">
						<div class="span12">
							<label for="observations">{{ 'lang.storefront.order.observations'|t }}</label>
							<textarea cols="80" rows="4" class="input-block-level" id="observations" name="observations" placeholder="{{ 'lang.storefront.cart.data.observations.placeholder'|t }}">{{ user.observations }}</textarea>
						</div>
					</div>

				{% endif %}

				{% if cart.coupon %}
					<hr>

					<div class="coupon-code">
						<h4>{{ 'lang.storefront.cart.order_summary.coupon_code.title'|t }}</h4>

						<div class="coupon-code-label margin-top-xxs">
							<span class="label label-light-bg h5">
								<i class="fa fa-tags fa-fw" aria-hidden="true"></i>
								<span class="coupon-code-text">{{ cart.coupon.code }}</span>
								<a href="{{ site_url('cart/coupon/remove') }}" class="btn-close"><i class="fa fa-times fa-fw" aria-hidden="true"></i></a>
							</span>
						</div>
					</div>
				{% endif %}

				<hr>

				<button type="submit" class="button btn-primary {{ store.theme_options.button_primary_shadow }}" style="width:200px">
					<i class="fa fa-chevron-right"></i>
					<span>{{ 'lang.storefront.layout.button.checkout'|t }}</span>
				</button>

			{{ form_close() }}

		</section>

	</div>

{% endblock %}
