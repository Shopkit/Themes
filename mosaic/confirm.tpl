{#
Description: Confirm order page
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
				<a href="{{ site_url('cart/payment') }}">{{ 'lang.storefront.cart.payment.title'|t }}</a> ›
				{{ 'lang.storefront.cart.confirm.title'|t }}
			</p><br>

			<h1>{{ 'lang.storefront.cart.confirm.title'|t }}</h1>

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

				{{ form_open('cart/complete', { 'class' : 'form' }) }}

					<table class="table table-bordered table-cart margin-bottom-md well-featured {{ store.theme_options.well_featured_shadow }}">
						<thead>
							<tr>
								<th>{{ 'lang.storefront.layout.title'|t }}</th>
								<th class="text-right">{{ 'lang.storefront.layout.product.quantity'|t }}</th>
								<th class="text-right">{{ 'lang.storefront.layout.subtotal.title'|t }}</th>
							</tr>
						</thead>

						<tbody>
							{% for item in cart.items %}
								<tr>
									<td>
										<img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ item.image }}" width="22" height="22" class="lazy">

										{{ item.title }}

										<div class="unit-price text-muted small">{{ 'lang.storefront.cart.product.unit_price.label'|t }} <span class="semi-bold">{{ item.price | money_with_sign }}</span></div>

										{% if item.extras %}
											<div class="items-extra-wrapper">
												<a href="#item-extra-{{ item.item_id }}" class=" margin-top-xxs inline-block small text-default" data-toggle="collapse" href="#item-extra-{{ item.item_id }}">{{ item.extras|length }} {{ item.extras|length > 1 ? 'lang.storefront.product.extra_options.plural.label'|t : 'lang.storefront.product.extra_options.singular.label'|t }} <span class="text-muted">({{ item.subtotal_extras > 0 ? item.subtotal_extras | money_with_sign : 'lang.storefront.cart.order_summary.shipping_total.free'|t }})</span> {{ icons('angle-down') }}</a>

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
									<td class="text-right">{{ item.qty }}</td>
									<td class="text-right">{{ item.subtotal | money_with_sign }}</td>
								</tr>
							{% endfor %}
						</tbody>

						<tfoot>
							<tr>
								<td>{{ 'lang.storefront.layout.subtotal.title'|t }}</td>
								<td align="right" class="bold text-right" colspan="2" style="border-left: 0;">{{ cart.subtotal | money_with_sign }}</td>
							</tr>

							{% if cart.discount %}
								<tr>
									<td colspan="2">
										{{ 'lang.storefront.order.discount'|t }}
										{% if cart.coupon %}
											<br><span class="text-muted margin-left-xs">{{ 'lang.storefront.order.discount.coupon'|t }}</span>
										{% endif %}
										{% if cart.rewards %}
											<br><span class="text-muted margin-left-xs">{{ store.settings.rewards.plural_label ?: 'lang.storefront.account.rewards.plural.label'|t }}</span>
										{% endif %}
									</td>
									<td class="text-right" style="border-left: 0;">
										<span class="no-wrap">{{ '- ' ~ cart.discount | money_with_sign }}</span>
										{% if cart.coupon %}
											<br><span class="no-wrap text-muted">{{ cart.coupon.type == 'shipping' ? 'lang.storefront.cart.order_summary.free_shipping'|t : '- ' ~ cart.coupon.discount | money_with_sign }}</span>
										{% endif %}
										{% if cart.rewards %}
											<br><span class="no-wrap text-muted">{{ '- ' ~ cart.rewards.discount | money_with_sign }}</span>
										{% endif %}
									</td>
								</tr>
							{% endif %}

							<tr>
								<td>{{ 'lang.storefront.cart.order_summary.shipping.title'|t }}</td>
								<td align="right" class="text-right" colspan="2" style="border-left: 0;">{{ cart.shipping_methods ? (user.shipping_method ? (cart.coupon.type == 'shipping' or cart.total_shipping == 0 ? 'lang.storefront.cart.order_summary.shipping_total.free'|t : cart.total_shipping | money_with_sign) : 'n/a') : cart.total_shipping | money_with_sign }}</td>
							</tr>

							{% if cart.total_payment %}
								<tr>
									<td>{{ 'lang.storefront.cart.order_summary.total_payment'|t }} <span data-toggle="tooltip" data-placement="top" title="{{ user.payment_method.title }}">{{ icons('question-circle') }}</span></td>
									<td align="right" class="text-right" colspan="2" style="border-left: 0;">{{ cart.total_payment | money_with_sign }}</td>
								</tr>
							{% endif %}

							{% if not store.taxes_included or cart.total_taxes == 0 %}
								<tr>
									<td>{{ user.l10n.tax_name }}</td>
									<td align="right" class="price text-right" colspan="2">{{ cart.total_taxes | money_with_sign }}</td>
								</tr>
							{% endif %}

							<tr>
								<td class="subtotal" valign="middle" style="vertical-align: middle;font-size:16px;">{{ 'lang.storefront.order.total'|t }}</td>
								<td colspan="2" class="subtotal price text-right" style="font-size:16px;border-left: 0;">
									{{ cart.total | money_with_sign }}

									{% if store.taxes_included and cart.total_taxes > 0 %}
										<div style="color:#999;font-weight: normal;font-size: 10px;margin-top:5px;">{{ 'lang.storefront.cart.order_summary.taxes_included'|t([user.l10n.tax_name, cart.total_taxes|money_with_sign]) }}</div>
									{% endif %}
								</td>
							</tr>
						</tfoot>
					</table>

					<div class="row-fluid">
						<div class="span6">
							<h4>{{ 'lang.storefront.order.payment.title'|t }}</h4>
							{{ user.payment_method.title }}
						</div>

						{% if user.shipping_method %}
							<div class="span6">
								<h4>{{ 'lang.storefront.order.shipment'|t }}</h4>
								{{ user.shipping_method.title }}
						</div>
						{% endif %}
					</div>

					<div class="row-fluid">
						<div class="span4">
							<h4 class="margin-top">{{ 'lang.storefront.cart.checkout.client.title'|t }}</h4>
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
						<div class="row-fluid">
							{% if not cart.is_digital %}
								<div class="span6">
									<h4 class="margin-top">{{ 'lang.storefront.order.delivery.address'|t }}</h4>
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
							{% endif %}

							<div class="span6">
								<h4 class="margin-top">{{ 'lang.storefront.order.billing.address'|t }}</h4>
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
						<h4>{{ 'lang.storefront.order.observations'|t }}</h4>
						<p>{{ user.observations|nl2br }}</p>
					{% endif %}

					<hr>

					{% if user.custom_field %}
						{% for custom_fields in user.custom_field %}
							{% set custom_field = custom_fields|json_decode %}
							<h4>{{ custom_field.title }}</h4>
							{% if custom_field.data %}
								{% for data in custom_field.data %}
									<p><strong>{{ data.key }}</strong>: {{ data.value }}</p>
								{% endfor %}
							{% else %}
								<p><strong>{{ custom_field.key }}</strong>: {{ custom_field.value }}</p>
							{% endif %}
							{{ loop.last ? '' : '<hr>' }}
						{% endfor %}
						<hr>
					{% endif %}

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
						<hr>
					{% endif %}

					<button type="submit" class="button btn-primary {{ store.theme_options.button_primary_shadow }}" style="width:200px">
						{{ icons('angle-right') }}
						<span>{{ 'lang.storefront.cart.confirm.confirm_order.button'|t }}</span>
					</button> &nbsp; &bull; &nbsp; <a href="{{ site_url('cart') }}">{{ 'lang.storefront.cart.data.cart_edit.button'|t }}</a>

				{{ form_close() }}

			{% else %}

				<p>{{ 'lang.storefront.cart.no_products'|t }}.</p>

			{% endif %}

		</section>

	</div>

{% endblock %}
