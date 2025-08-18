{#
Description: Payment Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="{{ layout_container }}">

		<h1 class="margin-bottom">{{ 'lang.storefront.cart.payment.title'|t }}</h1>

		<ol class="breadcrumb margin-bottom hidden-xs">
			<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a></li>
			<li><a href="{{ site_url('cart') }}">{{ 'lang.storefront.cart.title'|t }}</a></li>
			<li><a href="{{ site_url('cart/data') }}">{{ 'lang.storefront.cart.data.title'|t }}</a></li>
			<li class="active">{{ 'lang.storefront.cart.payment.title'|t }}</li>
		</ol>

		{% if cart.items %}
			{{ form_open('cart/post/confirm', { 'class' : 'form', 'id' : 'form-payment' }) }}

				<div class="row">
					<div class="col-md-8 col-lg-8">

						{% if errors.form %}
							<div class="callout callout-danger {{ store.theme_options.well_danger_shadow }}">
								<h4>{{ 'lang.storefront.layout.events.form.error'|t }}</h4>
								{{ errors.form }}
							</div>
						{% endif %}

						{% if warnings.form %}
							<div class="callout callout-warning {{ store.theme_options.well_warning_shadow }}">
								<h4>{{ 'lang.storefront.layout.events.form.warning'|t }}</h4>
								{{ warnings.form }}
							</div>
						{% endif %}

						{% if success.form %}
							<div class="callout callout-success {{ store.theme_options.well_success_shadow }}">
								<h4>{{ 'lang.storefront.layout.events.form.success'|t }}</h4>
								{{ success.form }}
							</div>
						{% endif %}

						{{ generic_macros.cart_notice() }}

						{% if cart.shipping_methods %}
							<div class="shipping-methods">
								<h3 class="margin-top-0">{{ 'lang.storefront.order.shipment'|t }}</h3>
								<p class="margin-bottom text-muted">{{ user.delivery.country }}</p>

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
							<h3 class="margin-bottom">{{ 'lang.storefront.order.payment.title'|t }}</h3>

							<div class="payment-methods">
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
														<div class="clearfix visible-xs-block"></div>
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
													<div id="pickup-locations" class="well well-default {{ store.theme_options.well_featured_shadow }}">
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

					</div>

					<div class="col-md-4 col-md-offset-0 col-lg-3 col-lg-offset-1">
						<div class="order-resume well well-default {{ store.theme_options.well_default_shadow }} margin-bottom-0">
							<h3 class="margin-bottom-sm margin-top-0 bordered">{{ 'lang.storefront.cart.order_summary.title'|t }}</h3>

							<dl class="dl-horizontal text-left margin-bottom-0">
								<dt class="bold">{{ 'lang.storefront.layout.subtotal.title'|t }}:</dt>
								<dd class="text-dark price">{{ cart.subtotal | money_with_sign }}</dd>

								{% if cart.discount %}
									<dt><a class="link-inherit" data-toggle="collapse" href="#discount-detail" role="button" aria-expanded="true" aria-controls="discount-detail">{{ 'lang.storefront.order.discount'|t }} {{ icons('angle-down') }}</a></dt>
									<dd class="text-dark price">{{ '- ' ~ cart.discount | money_with_sign }}</dd>

									<div class="collapse in text-muted" id="discount-detail">
										{% if cart.coupon %}
											<dt class="margin-left-xs normal">{{ 'lang.storefront.order.discount.coupon'|t }}</dt>
											<dd>{{ cart.coupon.type == 'shipping' ? 'lang.storefront.cart.order_summary.free_shipping'|t : '- ' ~ cart.coupon.discount | money_with_sign }}</dd>
										{% endif %}
										{% if cart.rewards %}
											<dt class="margin-left-xs normal">{{ store.settings.rewards.plural_label ?: 'lang.storefront.account.rewards.plural.label'|t }}</dt>
											<dd>{{ '- ' ~ cart.rewards.discount | money_with_sign }}</dd>
										{% endif %}
									</div>
								{% endif %}

								<div class="shipping">
									{% set no_shipping_text = 'lang.storefront.cart.order_summary.shipping.calculating.text'|t ~ ' <span data-toggle="tooltip" data-placement="top" title="' ~ 'lang.storefront.cart.order_summary.shipping.calculating.tooltip'|t ~ '">'~ icons('question-circle') ~'</span>' %}
									<dt>{{ 'lang.storefront.cart.order_summary.shipping.title'|t }}</dt>
									<dd class="text-dark price shipping-value total-shipping">{{ cart.shipping_methods ? (user.shipping_method ? (cart.coupon.type == 'shipping' or cart.total_shipping == 0 ? 'lang.storefront.cart.order_summary.shipping_total.free'|t : cart.total_shipping | money_with_sign) : no_shipping_text) : cart.total_shipping | money_with_sign }}</dd>
								</div>

								<div class="flex payment-tax {{ not cart.total_payment ? 'hidden' }}">
									<dt>{{ 'lang.storefront.cart.order_summary.total_payment'|t }} <span data-toggle="tooltip" data-placement="top" title="{{ user.payment_method.title }}">{{ icons('question-circle') }}</span></dt>
									<dd class="text-dark price payment-tax-value">{{ cart.total_payment | money_with_sign }}</dd>
								</div>

								{% if not store.taxes_included or cart.total_taxes == 0 %}
									<div class="total-taxes">
										<dt>{{ user.l10n.tax_name }}</dt>
										<dd class="text-dark price total-taxes-value">{{ cart.total_taxes | money_with_sign }}</dd>
									</div>
								{% endif %}
							</dl>

							<hr>

							<dl class="dl-horizontal text-left h3 margin-bottom-0 total">
                                <dt>{{ 'lang.storefront.order.total'|t }}</dt>
                                <dd class="bold price total-value">{{ cart.total | money_with_sign }}</dd>
                            </dl>

                            {% if store.taxes_included and cart.total_taxes > 0 %}
                                <div class="text-right text-left-xs total-taxes">
                                    <small class="text-muted">{{ 'lang.storefront.cart.order_summary.taxes_included'|t([user.l10n.tax_name, cart.total_taxes|money_with_sign]) }}</small>
                                </div>
                            {% endif %}

							{% if cart.coupon %}
								<hr>

								<div class="coupon-code">
									<label for="cupao">{{ 'lang.storefront.cart.order_summary.coupon_code.title'|t }}</label>
									<div class="coupon-code-label margin-top-xxs">
										<span class="label label-light-bg h5">
											{{ icons('tags') }}
											<span class="coupon-code-text">{{ cart.coupon.code }}</span>
											<a href="{{ site_url('cart/coupon/remove') }}" class="btn-close">{{ icons('times') }}</a>
										</span>
									</div>
								</div>
							{% endif %}

							{% if cart.rewards %}
								<hr>

								<div class="cart-rewards">
									<label for="rewards">{{ rewards_label }}</label>

									<div class="cart-rewards-label margin-top-xxs">
										<span class="label label-light-bg h5">
											{{ icons('trophy') }}
											<span class="cart-rewards-text">{{ cart.rewards.rewards|rewards_label }}</span>
											<a href="{{ site_url('cart/rewards/remove') }}" class="btn-close">{{ icons('times') }}</a>
										</span>
									</div>
								</div>
							{% endif %}

							<button class="btn btn-lg btn-primary {{ store.theme_options.button_primary_shadow }} btn-block margin-top hidden-xs hidden-sm">{{ 'lang.storefront.layout.button.checkout'|t }} {{ icons('arrow-right') }}</button>
						</div>

					</div>

				</div>

				<div class="row">
					<div class="col-md-8 col-lg-8">
						<footer class="clearfix">
							<div class="pull-left steps hidden-xs">
								{{ 'lang.storefront.cart.payment.step_two'|t }}
							</div>
							<div class="pull-right">
								<small class="text-muted-dark"><a href="{{ site_url('cart') }}">{{ 'lang.storefront.cart.data.cart_edit.button'|t }}</a> &nbsp; &bull; &nbsp; </small> <button class="btn btn-primary {{ store.theme_options.button_primary_shadow }}">{{ 'lang.storefront.layout.button.checkout'|t }} {{ icons('arrow-right') }}</button>
							</div>
						</footer>
					</div>
				</div>

			{{ form_close() }}

		{% else %}
			<p class="h2 light text-muted margin-top-lg">{{ 'lang.storefront.cart.no_products'|t }}</p>
		{% endif %}

	</div>

{% endblock %}
