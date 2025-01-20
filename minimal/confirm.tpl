{#
Description: Confirm order page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="{{ layout_container }}">

		<h1 class="margin-bottom">{{ 'lang.storefront.cart.confirm.title'|t }}</h1>

		<ol class="breadcrumb margin-bottom hidden-xs">
			<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a></li>
			<li><a href="{{ site_url('cart') }}">{{ 'lang.storefront.cart.title'|t }}</a></li>
			<li><a href="{{ site_url('cart/data') }}">{{ 'lang.storefront.cart.data.title'|t }}</a></li>
			<li><a href="{{ site_url('cart/payment') }}">{{ 'lang.storefront.cart.payment.title'|t }}</a></li>
			<li class="active">{{ 'lang.storefront.cart.confirm.title'|t }}</li>
		</ol>

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

		{% if cart.items %}
			{{ form_open('cart/complete', { 'role' : 'form' }) }}
				<div class="row">
					<div class="col-md-8 col-lg-8">

						<h3 class="margin-top-0">{{ 'lang.storefront.macros.products.title'|t }}</h3>

						<div class="table-responsive table-cart-responsive well-featured {{ store.theme_options.well_featured_shadow }} margin-bottom">
							<table class="table table-cart table-confirm margin-bottom-0">
								<thead>
									<tr>
										<th colspan="2">{{ 'lang.storefront.account.orders.order.product.title'|t }}</th>
										<th class="text-right">{{ 'lang.storefront.layout.product.quantity'|t }}</th>
										<th class="text-right">{{ 'lang.storefront.layout.subtotal.title'|t }}</th>
									</tr>
								</thead>

								<tbody>

									{% for item in cart.items %}
										<tr>
											<td class="cart-img">
												<a href="{{ item.product_url }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ item.image }}" alt="{{ item.title|e_attr }}" title="{{ item.title|e_attr }}" class="border-radius lazy"></a>
											</td>
											<td>
												<h4 class="normal margin-top-0 margin-bottom-xxs"><a href="{{ item.product_url }}">{{ item.title }}</a></h4>

                                                <div class="unit-price text-muted small">{{ 'lang.storefront.cart.product.unit_price.label'|t }} <span class="semi-bold">{{ item.price | money_with_sign }}</span></div>

                                                {% if item.extras %}
                                                    <div class="items-extra-wrapper">
                                                        <a href="#item-extra-{{ item.item_id }}" class=" margin-top-xxs inline-block small text-default" data-toggle="collapse" href="#item-extra-{{ item.item_id }}">{{ item.extras|length }} {{ item.extras|length > 1 ? 'lang.storefront.product.extra_options.plural.label'|t : 'lang.storefront.product.extra_options.singular.label'|t }} <span class="text-muted">({{ item.subtotal_extras > 0 ? item.subtotal_extras | money_with_sign : 'lang.storefront.cart.order_summary.shipping_total.free'|t }})</span> <i class="fa fa-fw fa-angle-down" aria-hidden="true"></i></a>

                                                        <ul class="list-group extra-options collapse margin-bottom-0 margin-top-xs" id="item-extra-{{ item.item_id }}">
                                                            {% for key, extra in item.extras %}
                                                                <li class="list-group-item">
                                                                    <span class="badge">{{ extra.price ?  extra.price | money_with_sign : 'lang.storefront.cart.order_summary.shipping_total.free'|t }}</span>
                                                                    <h6 class="margin-0 semi-bold">{{ extra.title }}</h6>
                                                                    <div class="text-truncate small margin-top-xxs" style="max-width: 200px; min-width: 100%" data-toggle="tooltip" title="{{ extra.value }}"><span class="text-muted">{{ extra.qty }}x</span> {{ extra.value }}</div>
                                                                </li>
                                                            {% endfor %}
                                                        </ul>
                                                    </div>
                                                {% endif %}
											</td>
											<td class="text-right">
												{{ item.qty }}
											</td>
											<td class="text-right price">
												{{ item.subtotal | money_with_sign }}
											</td>
										</tr>
									{% endfor %}

								</tbody>
							</table>
						</div>

						<div class="row">
							<div class="col-sm-6">
								<h3>{{ 'lang.storefront.order.payment.title'|t }}</h3>
								<p>{{ user.payment_method.title }}</p>
							</div>
							<div class="visible-xs margin-bottom"></div>
							<div class="col-sm-6">
								{% if user.shipping_method %}
									<h3>{{ 'lang.storefront.order.shipment'|t }}</h3>
									<p>{{ user.shipping_method.title }}</p>
								{% endif %}
							</div>
						</div>

						<div class="row">
							<div class="col-sm-6">
								<h3>{{ 'lang.storefront.cart.checkout.client.title'|t }}</h3>
								{{ user.email }}<br>
								{% if store.settings.cart.field_fiscal_id != 'hidden' %}
									{{ user.l10n.tax_id_abbr }}: {{ user.fiscal_id ? user.fiscal_id : 'n/a' }}<br>
								{% endif %}
								{% if store.settings.cart.field_company != 'hidden' %}
									{{ 'lang.storefront.order.client.company'|t }}: {{ user.company ? user.company : 'n/a' }}
								{% endif %}
							</div>
						</div>

						<div class="confirm-data">
							<div class="row">
								{% if not cart.is_digital %}
									<div class="col-sm-6">
										<h3>{{ 'lang.storefront.order.delivery.address'|t }}</h3>
										<p>
											{{ user.delivery.name }}<br>
											{{ user.delivery.address }} {{ user.delivery.address_extra }}<br>
											{{ user.delivery.zip_code }} {{ user.delivery.city }}<br>
											{{ user.delivery.country }}
										</p>
										{% if store.settings.cart.field_delivery_phone != 'hidden' %}
											<p>
												{{ user.delivery.phone ? 'lang.storefront.form.phone.label'|t ~ ': ' ~ user.delivery.phone : '' }}
											</p>
										{% endif %}
									</div>
									<div class="visible-xs margin-bottom"></div>
								{% endif %}
								<div class="col-sm-6">
									<h3>{{ 'lang.storefront.order.billing.address'|t }}</h3>
									<p>
										{{ user.billing.name }}<br>
										{{ user.billing.address }} {{ user.billing.address_extra }}<br>
										{{ user.billing.zip_code }} {{ user.billing.city }}<br>
										{{ user.billing.country }}
									</p>
									{% if store.settings.cart.field_billing_phone != 'hidden' %}
										<p>
											{{ user.billing.phone ? 'lang.storefront.form.phone.label'|t ~ ': ' ~ user.billing.phone : '' }}
										</p>
									{% endif %}
								</div>
							</div>
						</div>

						{% if user.observations %}
							<h3>{{ 'lang.storefront.order.observations'|t }}</h3>
							<p>{{ user.observations|nl2br }}</p>
						{% endif %}

						{% if user.custom_field %}
							{% for custom_fields in user.custom_field %}
								<div class="well well-default {{ store.theme_options.well_default_shadow }}">
									{% set custom_field = custom_fields|json_decode %}
									<h3 class="margin-bottom-md">{{ custom_field.title }}</h3>
									{% if custom_field.data %}
										{% for data in custom_field.data %}
											<p><strong>{{ data.key }}</strong>: {{ data.value }}</p>
										{% endfor %}
									{% else %}
										<p><strong>{{ custom_field.key }}</strong>: {{ custom_field.value }}</p>
									{% endif %}
								</div>
							{% endfor %}
						{% endif %}

						<footer class="clearfix hidden-xs hidden-sm">
							<div class="pull-left steps hidden-xs">
								{{ 'lang.storefront.cart.confirm.step_three'|t }}
							</div>
							<div class="pull-right">
								<small class="text-muted-dark"><a href="{{ site_url('cart') }}">{{ 'lang.storefront.cart.data.cart_edit.button'|t }}</a> &nbsp; &bull; &nbsp; </small> <button class="btn btn-primary {{ store.theme_options.button_primary_shadow }}"><i class="fa fa-fw fa-check"></i> {{ 'lang.storefront.cart.confirm.confirm_order.button'|t }}</button>
							</div>
						</footer>

					</div>

					<div class="col-md-4 col-md-offset-0 col-lg-3 col-lg-offset-1">

						<div class="order-resume well well-default {{ store.theme_options.well_default_shadow }} margin-top">
							<h3 class="margin-bottom-sm margin-top-0 bordered">{{ 'lang.storefront.cart.order_summary.title'|t }}</h3>

							<dl class="dl-horizontal text-left margin-bottom-0">
								<dt class="bold">{{ 'lang.storefront.layout.subtotal.title'|t }}:</dt>
								<dd class="text-dark price">{{ cart.subtotal | money_with_sign }}</dd>

								{% if cart.coupon %}
									<dt>{{ 'lang.storefront.order.discount'|t }}</dt>
									<dd class="text-dark price">{{ cart.coupon.type == 'shipping' ? 'lang.storefront.cart.order_summary.free_shipping'|t : '- ' ~ cart.discount | money_with_sign }}</dd>
								{% endif %}

								<dt>{{ 'lang.storefront.cart.order_summary.shipping.title'|t }}</dt>
								<dd class="text-dark price">{{ cart.shipping_methods ? (user.shipping_method ? (cart.coupon.type == 'shipping' or cart.total_shipping == 0 ? 'lang.storefront.cart.order_summary.shipping_total.free'|t : cart.total_shipping | money_with_sign) : 'n/a') : cart.total_shipping | money_with_sign }}</dd>

								{% if cart.total_payment %}
									<div class="flex">
										<dt>{{ 'lang.storefront.cart.order_summary.total_payment'|t }} <span data-toggle="tooltip" data-placement="top" title="{{ user.payment_method.title }}"><i class="fa fa-question-circle"></i></span></dt>
										<dd class="text-dark price">{{ cart.total_payment | money_with_sign }}</dd>
									</div>
								{% endif %}

								{% if not store.taxes_included or cart.total_taxes == 0 %}
									<dt>{{ user.l10n.tax_name }}</dt>
									<dd class="text-dark price">{{ cart.total_taxes | money_with_sign }}</dd>
								{% endif %}
							</dl>

							<hr>

							<dl class="dl-horizontal text-left h3 margin-bottom-0">
                                <dt>{{ 'lang.storefront.order.total'|t }}</dt>
                                <dd class="bold price">{{ cart.total | money_with_sign }}</dd>
                            </dl>

                            {% if store.taxes_included and cart.total_taxes > 0 %}
                                <div class="text-right text-left-xs">
                                    <small class="text-muted">{{ 'lang.storefront.cart.order_summary.taxes_included'|t([user.l10n.tax_name, cart.total_taxes|money_with_sign]) }}</small>
                                </div>
                            {% endif %}

							{% if store.settings.cart.page_terms or store.settings.cart.page_privacy %}
								<hr>
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

							<p class="margin-top margin-bottom-0 text-center"><button class="btn btn-lg btn-primary {{ store.theme_options.button_primary_shadow }} btn-block"><i class="fa fa-fw fa-check"></i> {{ 'lang.storefront.cart.confirm.button'|t }}</button></p>

						</div>

					</div>

				</div>

			{{ form_close() }}

		{% else %}
			<p class="h2 light text-muted margin-top-lg">{{ 'lang.storefront.cart.no_products'|t }}</p>
		{% endif %}

	</div>

{% endblock %}
