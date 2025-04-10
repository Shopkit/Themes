{#
Description: Shopping cart page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">

		<section class="page">

			<p class="breadcrumbs">
				<a href="{{ site_url() }}">{{ icons('home') }}</a> ›
				<a href="{{ site_url('cart') }}">{{ 'lang.storefront.cart.title'|t }}</a> ›
				<a href="{{ site_url('cart/data') }}">{{ 'lang.storefront.cart.data.title'|t }}</a> ›
				{{ 'lang.storefront.cart.payment.title'|t }}
			</p><br>

			<h1>{{ 'lang.storefront.cart.payment.title'|t }}</h1>

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

			{% if cart.items %}

			{{ form_open('cart/post/confirm', { 'class' : 'form', 'id' : 'form-payment' }) }}

				{% if cart.shipping_methods %}

					<div class="shipping-methods">
						<h4>{{ 'lang.storefront.order.shipment'|t }} <small>({{ user.delivery.country }})</small></h4>
						<br>
						<ul class="list-group well-featured {{ store.theme_options.well_featured_shadow }}">

							{% for method in cart.shipping_methods %}
								<li class="list-group-item list-radio-block {% if user.shipping_method.id == method.id %}list-group-item-active{% endif %}">
									<label for="shipping_method_{{ method.id }}">
										<div class="list-radio-content">
											<div class="list-radio-input">
												<input type="radio" name="envio" id="shipping_method_{{ method.id }}" value="{{ method.id }}" required {% if user.shipping_method.id == method.id %}checked{% endif %}>
											</div>
											<div class="list-radio-description">
												<div class="shipping-method">
													<h4>{{ method.title }}</h4>
													{% if method.description %}
														<p>{{ method.description }}</p>
													{% endif %}
												</div>
											</div>
											<div class="list-radio-price">
												<div class="price">{{ method.price == 0 or cart.coupon.type == 'shipping' ? 'lang.storefront.cart.order_summary.shipping_total.free'|t : method.price|money_with_sign }}</div>
											</div>
										</div>
									</label>
								</li>
							{% endfor %}

						</ul>
					</div>

				{% endif %}

				{% if cart.payments %}
					<div class="payment-methods">
						<h4>{{ 'lang.storefront.order.payment.title'|t }}</h4>
						<br>
						<ul class="list-group well-featured {{ store.theme_options.well_featured_shadow }}">

							{% for payment in cart.payments %}
								{% if payment.active %}

									{% if user.payment_method %}
										{% set active = user.payment_method.alias == payment.alias ? true : false %}
									{% else %}
										{% set active = payment.default ? true : false %}
									{% endif %}

									<li class="list-group-item list-radio-block payment-method-{{ payment.alias }} {% if active %}list-group-item-active{% endif %}">
										<label for="{{ payment.alias }}">
											<div class="list-radio-content">
												<div class="list-radio-input">
													<input type="radio" name="pagamento" id="{{ payment.alias }}" value="{{ payment.alias }}" {% if active %}checked{% endif %}>
												</div>
												<div class="list-radio-description">
													<div class="shipping-method">
														<h4>{{ payment.title }}</h4>
														<p>{{ payment.description }}</p>
													</div>
												</div>
												<div class="clearfix visible-phone"></div>
												<div class="list-radio-logo-wrapper">
													{% if payment.logo %}
														<div class="list-radio-logo">
																<img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ payment.logo }}" alt="{{ payment.title }}" title="{{ payment.title }}" height="25" class="lazy">
														</div>
													{% endif %}
													{% if payment.value or payment.value_percent %}
														<div class="list-radio-payment-price {{ payment.logo ? 'margin-top-xs' }}">
															{{ 'lang.storefront.cart.payment.tax.label'|t }}: {{ payment.value ? payment.value | money_with_sign }}{{ payment.value and payment.value_percent ? ' + ' }}{{ payment.value_percent ? payment.value_percent ~ '%' }}
														</div>
													{% endif %}
												</div>
											</div>
										</label>
										{% if payment.alias == 'credit_card' %}
											<div id="card-element"></div>
										{% endif %}

										{% if payment.alias == 'pick_up' and store.locations %}
											<div id="pickup-locations" class="well well-default {{ store.theme_options.well_default_shadow }}">
												<div class="form-group">
													<label for="pick_up_location">{{ 'lang.storefront.cart.payment.pick_up_location.label'|t }}</label>
													<select name="pick_up_location" id="pick_up_location" class="form-control input-block-level">
														<option value="" disabled {% if not user.pick_up_location %}selected{% endif %}>{{ 'lang.storefront.cart.payment.pick_up_location.select.default'|t }}</option>

														{% for location in store.locations %}
															{% set selected = false %}

															{% if user.pick_up_location %}
																{% set selected = user.pick_up_location.id == location.id ? true : false %}
															{% endif %}

															<option value="{{ location.id }}" {% if selected %}selected{% endif %}>{{ location.name }} - {{ location.city }}, {{ location.country }}</option>
														{% endfor %}
													</select>
												</div>
											</div>
										{% endif %}
									</li>

								{% endif %}
							{% endfor %}

						</ul>
					</div>
				{% endif %}

				{% if cart.coupon %}
					<hr>

					<div class="coupon-code">
						<h4>{{ 'lang.storefront.cart.order_summary.coupon_code.title'|t }}</h4>

						<div class="coupon-code-label margin-top-xxs">
							<span class="label label-light-bg h5">
								{{ icons('tags') }}
								<span class="coupon-code-text">{{ cart.coupon.code }}</span>
								<a href="{{ site_url('cart/coupon/remove') }}" class="btn-close">{{ icons('times') }}</a>
							</span>
						</div>
					</div>
				{% endif %}

				<hr>

				<button type="submit" class="button btn-primary {{ store.theme_options.button_primary_shadow }}" style="width:200px">
					{{ icons('angle-right') }}
					<span>{{ 'lang.storefront.layout.button.checkout'|t }}</span>
				</button>

			{{ form_close() }}

		{% else %}

			<p>{{ 'lang.storefront.cart.no_products'|t }}.</p>

		{% endif %}

		</section>

	</div>

{% endblock %}
