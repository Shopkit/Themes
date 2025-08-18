{#
Description: Complete order page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb well-default">
		<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
		<li class="active">{{ 'lang.storefront.order.label'|t }}</li>
	</ul>

	{{ generic_macros.cart_notice() }}

	<h1>{{ 'lang.storefront.cart.complete.order_successfull'|t }}</h1>
	<br>

	<h3>{{ 'lang.storefront.order.label'|t }} <strong>#{{ order.id }}</strong></h3>

	{% if store.settings.rewards.active and store.settings.rewards.message_confirm and (user.is_logged_in or user.create_user) and order.rewards.earned %}
		<div class="alert alert-success">
			<i class="icon margin-right-xxs">{{ icons('trophy') }}</i>
			{{ store.settings.rewards.message_confirm|rewards_message(order.rewards.total_earned) }}
		</div>
	{% endif %}

	<ul class="list-group well-featured {{ store.theme_options.well_featured_shadow }}">
		<li class="list-group-item">
			<span class="badge text-h6">{{ order.id }}</span>
			{{ 'lang.storefront.cart.complete.order_number.label'|t }}:
		</li>
		<li class="list-group-item">
			<span class="badge price text-h6">{{ order.total | money_with_sign }}</span>
			{{ 'lang.storefront.order.total'|t }}:
		</li>
		<li class="list-group-item">
			<span class="badge text-h6">{{ order.payment.title }}</span>
			{{ 'lang.storefront.cart.complete.order_payment.label'|t }}:

			<div>

				{% if order.payment.type == 'bank_transfer' and order.payment.data %}
					<div class="margin-top-sm">
						<strong>{{ 'lang.storefront.order.payment.bank_transfer.label'|t }}:</strong> {{ order.payment.data }}
					</div>

				{% elseif order.payment.type == 'multibanco' %}
					{% if order.payment.data and order.payment.data.reference %}
						<div class="margin-top-sm text-nowrap">
							<strong>{{ 'lang.storefront.order.payment.multibanco.entity'|t }}:</strong> <span>{{ order.payment.data.entity }}</span>
							<br>
							<strong>{{ 'lang.storefront.order.payment.multibanco.reference'|t }}:</strong>
							<span style="padding: 0 2px">{{ order.payment.data.reference|slice(0, 3) }}</span>
							<span style="padding: 0 2px">{{ order.payment.data.reference|slice(3, 3) }}</span>
							<span style="padding: 0 2px">{{ order.payment.data.reference|slice(6, 3) }}</span>
							<br>
							<strong>{{ 'lang.storefront.order.payment.multibanco.value'|t }}:</strong> <span class="text-muted price">{{ order.payment.data.value | money_with_sign }}</span>
						</div>
					{% else %}
						<div class="margin-top-sm text-danger">
							<strong>{{ 'lang.storefront.layout.events.form.error'|t }}:</strong> {{ 'lang.storefront.order.payment.multibanco.error_message'|t }}
						</div>
					{% endif %}

				{% elseif order.payment.type == 'wallets' %}
					<div class="wallets-data margin-top-sm">
						<div id="payment-request-button"></div>
					</div>

				{% elseif order.payment.type == 'payshop' %}
					{% if order.payment.data and order.payment.data.reference %}
						<div class="margin-top-sm text-nowrap">
							<strong>{{ 'lang.storefront.order.payment.multibanco.reference'|t }}:</strong> {{ order.payment.data.reference }}
							<br>
							<strong>{{ 'lang.storefront.order.payment.multibanco.value'|t }}:</strong> <span class="text-muted price">{{ order.payment.data.value | money_with_sign }}</span>
						</div>
					{% else %}
						<div class="margin-top-sm text-danger">
							<strong>{{ 'lang.storefront.layout.events.form.error'|t }}:</strong> {{ 'lang.storefront.order.payment.payshop.error_message'|t }}
						</div>
					{% endif %}


				{% elseif order.payment.type == 'pick_up' and order.payment.data %}
					<div class="pick_up-data margin-top-sm text-h6">
						<strong>{{ 'lang.storefront.order.pick_up_address'|t }}</strong><br>
						{{ order.payment.data.name }}<br>
						{{ order.payment.data.address }} {{ order.payment.data.address_extra }}<br>
						{{ order.payment.data.zip_code }} {{ order.payment.data.city }}<br>
						{{ order.payment.data.country }}
					</div>

				{% endif %}
			</div>
		</li>
	</ul>

	{% if order.payment.message %}
		<div class="well well-default {{ store.theme_options.well_default_shadow }} payment-msg">
			<p>{{ order.payment.message }}</p>
		</div>
	{% endif %}

{% endblock %}
