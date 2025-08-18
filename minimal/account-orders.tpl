{#
Description: Orders account page
#}

{% import 'account.tpl' as account_macros %}
{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="{{ layout_container }}">
		<div class="row">
			<div class="col-sm-3">
				<div class="panel well-featured {{ store.theme_options.well_featured_shadow }} panel-default margin-bottom">
					<div class="panel-heading">
						<a href="{{ site_url('account') }}" class="link-inherit">{{ 'lang.storefront.account.my_account'|t }}</a>
					</div>

					{{ account_macros.account_navigation() }}

				</div>
			</div>

			<div class="col-sm-8 col-sm-offset-1">
				<h1 class="margin-top-0 margin-bottom">{{ 'lang.storefront.layout.greetings'|t }} <strong>{{ user.name|first_word }}</strong>.</h1>
				{% if user.order_detail %}
					{# Template for order detail #}

					{% if store.settings.rewards.reviews and store.settings.rewards.message_reviews %}
						<div class="callout callout-info">
							<i class="icon margin-right-xxs">{{ icons('trophy') }}</i>
							{{ store.settings.rewards.message_reviews|rewards_message(store.settings.rewards.reviews_ratio) }}
						</div>
					{% endif %}

					<h3 class="margin-bottom-sm margin-top-0 text-muted-dark light">{{ 'lang.storefront.order.label'|t }} #{{ user.order_detail.id }}</h3>

					{% if user.order_detail.tracking_url %}<a href="{{ user.order_detail.tracking_url }}" target="_blank" class="btn btn-default {{ store.theme_options.button_default_shadow }}">{{ icons('map-marker') }} {{ 'lang.storefront.order.tracking.button'|t }}</a> &nbsp; {% endif %}
					{% if user.order_detail.invoice_url %}<a href="{{ user.order_detail.invoice_url }}" target="_blank" class="btn btn-default {{ store.theme_options.button_default_shadow }}">{{ icons('file-text') }} {{ 'lang.storefront.order.invoice'|t }}</a>{% endif %}

					<div class="list-group list-group-horizontal margin-top margin-bottom-0 order-status order-status-{{ user.order_detail.status_alias }} {{ user.order_detail.paid ? 'order-paid' : 'order-not-paid' }}">
						<div class="row">
							<div class="col-sm-2 list-group-item">
								<h4>{{ 'lang.storefront.order.paid'|t }}</h4>
								<span class="order-status-payment">{{ user.order_detail.paid ? icons('check', 'text-success') : icons('times') }}</span>
							</div>
							<div class="col-sm-4 list-group-item">
								<h4>{{ 'lang.storefront.order.status'|t }}</h4>
								<span class="order-status-description">{{  user.order_detail.status_description }}</span>
							</div>
							<div class="col-sm-3 list-group-item">
								<h4>{{ 'lang.storefront.order.date'|t }}</h4>
								<span class="order-status-date">{{  user.order_detail.created_at|format_datetime('long', 'none') }}</span>
							</div>
							<div class="col-sm-3 list-group-item">
								<h4>{{ 'lang.storefront.order.total'|t }}</h4>
								<span class="order-status-total">{{  user.order_detail.total|money_with_sign(user.order_detail.currency) }}</span>
							</div>
						</div>
					</div>
					<p class="margin-bottom margin-top-xxs"><a href="{{ site_url('contact?p=') ~ 'lang.storefront.order.order_with_id'|t([user.order_detail.id])|url_encode }}" class="text-underline" target="_blank"><small>{{ 'lang.storefront.account.orders.order_detail.contact'|t }}</small></a></p>

					{% if user.order_detail.client_note %}
						<div class="well well-default {{ store.theme_options.well_default_shadow }}">
							<h4 class="margin-bottom-xxs">{{ 'lang.storefront.account.orders.order_detail.client_note'|t([store.name]) }}</h4>
							{{ user.order_detail.client_note|nl2br }}
						</div>
					{% endif %}

					{% if user.order_detail.observations %}
						<div class="well well-default {{ store.theme_options.well_default_shadow }}">
							<h4 class="margin-bottom-xxs">{{ 'lang.storefront.order.observations'|t }}</h4>
							<p>{{ user.order_detail.observations|nl2br }}</p>
						</div>
					{% endif %}

					<div class="row margin-bottom">
						<div class="col-sm-6">
							<h4 class="margin-bottom-xxs">{{ 'lang.storefront.order.payment.title'|t }}</h4>
							<p>{{ user.order_detail.payment.title }}</p>

							{% if not user.order_detail.paid and user.order_detail.status_alias != 'canceled' %}
								<h5 class="margin-bottom-xxs bold">{{ 'lang.storefront.order.payment_data'|t }}</h5>
								<div class="row">
									<div class="col-sm-9">
										<p>{{ user.order_detail.payment.data_html }}</p>
									</div>
								</div>

								{% if user.order_detail.payment.type != 'on_delivery' and user.order_detail.payment.type != 'pick_up' %}
									<p><small><a href="{{ site_url('order/payment/' ~ user.order_detail.hash) }}" class="text-underline">{{ 'lang.storefront.order.change_payment_method'|t }}</a></small></p>
								{% endif %}
							{% endif %}
						</div>
						<div class="col-sm-6">
							{% if user.order_detail.payment.type == 'pick_up' and user.order_detail.payment.data %}
								<h4 class="margin-bottom-xxs">{{ 'lang.storefront.order.pick_up_address'|t }}</h4>
								<p>
									{{ user.order_detail.payment.data.name }}<br>
									{{ user.order_detail.payment.data.address }} {{ user.order_detail.payment.data.address_extra }}<br>
									{{ user.order_detail.payment.data.zip_code }} {{ user.order_detail.payment.data.city }}<br>
									{{ user.order_detail.payment.data.country }}
								</p>
							{% else %}
								<h4 class="margin-bottom-xxs">{{ 'lang.storefront.order.shipment'|t }}</h4>
								<p>{{ user.order_detail.shipment_method|default('n/a') }}</p>
							{% endif %}
						</div>
					</div>

					<div class="row margin-bottom">
						<div class="col-sm-6">
							<h4 class="margin-bottom-xxs">{{ 'lang.storefront.layout.client.title'|t }}</h4>
							<a href="mailto:{{ user.order_detail.client.email }}" class="text-underline">{{ user.order_detail.client.email }}</a><br>
							<strong>{{ user.order_detail.l10n.tax_id_abbr }}:</strong> {{ user.order_detail.client.fiscal_id ? user.order_detail.client.fiscal_id : 'n/a' }}<br>
							<strong>{{ 'lang.storefront.order.client.company'|t }}:</strong> {{ user.order_detail.client.company ? user.order_detail.client.company : 'n/a' }}
						</div>
					</div>

					<div class="row margin-bottom">
						<div class="col-sm-6">
							<h4 class="margin-bottom-xxs">{{ 'lang.storefront.order.delivery.address'|t }}</h4>
							<p>
								{{ user.order_detail.client.delivery.name }}<br>
								{{ user.order_detail.client.delivery.address }} {{ user.order_detail.client.delivery.address_extra }}<br>
								{{ user.order_detail.client.delivery.zip_code }} {{ user.order_detail.client.delivery.city }}<br>
								{{ user.order_detail.client.delivery.country }}
							</p>
							<p>
								{{ user.order_detail.client.delivery.phone ? 'lang.storefront.form.phone.label'|t ~ ': ' ~ user.order_detail.client.delivery.phone : '' }}
							</p>
						</div>
						<div class="visible-xs margin-bottom"></div>
						<div class="col-sm-6">
							<h4 class="margin-bottom-xxs">{{ 'lang.storefront.order.billing.address'|t }}</h4>
							<p>
								{{ user.order_detail.client.billing.name }}<br>
								{{ user.order_detail.client.billing.address }} {{ user.order_detail.client.billing.address_extra }}<br>
								{{ user.order_detail.client.billing.zip_code }} {{ user.order_detail.client.billing.city }}<br>
								{{ user.order_detail.client.billing.country }}
							</p>
							<p>
								{{ user.order_detail.client.billing.phone ? 'lang.storefront.form.phone.label'|t ~ ': ' ~ user.order_detail.client.billing.phone ~ '<br>' : '' }}
							</p>
						</div>
					</div>

					{% if user.order_detail.products %}
						<div class="table-responsive">
							<table class="table table-cart">
								<tbody>
									{% for product in user.order_detail.products|filter(product => product.is_product) %}
										<tr>
											<td class="cart-img">
												<a href="{{ product.url }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image.square }}" alt="{{ product.title|e_attr }}" title="{{ product.title|e_attr }}" class="border-radius lazy"></a>
											</td>
											<td>
												<h4 class="normal margin-top-0 margin-bottom-xs"><a href="{{ product.url }}">{{ product.title }}</a></h4>
												<small class="text-muted">{{ product.option }}</small>

												{% if product.extras %}
                                                    {% set extras_slug = (product.option ~ '-' ~ product.extras|column('value')|join(','))|slug %}
                                                    <div class="items-extra-wrapper">
                                                        <a href="#item-extra-{{ product.id ~ '-' ~ extras_slug }}" class=" margin-top-xxs inline-block small text-default" data-toggle="collapse" href="#item-extra-{{ product.id ~ '-' ~ extras_slug }}">{{ product.extras|length }} {{ product.extras|length > 1 ? 'lang.storefront.product.extra_options.plural.label'|t : 'lang.storefront.product.extra_options.singular.label'|t }} <span class="text-muted">({{ product.subtotal_extras > 0 ? product.subtotal_extras | money_with_sign : 'lang.storefront.cart.order_summary.shipping_total.free'|t }})</span> {{ icons('angle-down') }}</a>

                                                        <ul class="list-group extra-options collapse in margin-bottom-0 margin-top-xs" id="item-extra-{{ product.id ~ '-' ~ extras_slug }}">
                                                            {% for key, extra in product.extras %}
                                                                <li class="list-group-item">
                                                                    <div class="list-group-item-header">
                                                                        <h6 class="margin-0 semi-bold">{{ extra.title }}</h6>
                                                                        <span class="badge badge-transparent normal"><span class="text-muted">{{ extra.quantity }}x</span> {{ extra.price ?  extra.price | money_with_sign : 'lang.storefront.cart.order_summary.shipping_total.free'|t }}</span>
                                                                    </div>
                                                                    <div class="text-truncate small margin-top-xxs" style="max-width: 200px; min-width: 100%" data-toggle="tooltip" title="{{ extra.value }}">{{ extra.value }}</div>
                                                                </li>
                                                            {% endfor %}
                                                        </ul>
                                                    </div>
                                                {% endif %}

												{% if product.files %}
                                                    {% if product.files_settings %}
                                                        {% set days = product.files_settings.allowed_days ? 'now'|date_modify('+'~ product.files_settings.allowed_days ~' days')|format_datetime('short', 'none') : 'lang.storefront.account.orders.order.files.not_expire'|t %}
                                                    {% endif %}
                                                    <div class="digital-files-wrapper">
                                                        <ul class="list-group digital-files collapse in margin-bottom-0 margin-top-xs">
                                                            <li class="list-group-item label-light-bg">
                                                                <div class="list-group-item-header">
                                                                    <h6 class="margin-0 semi-bold">{{ 'lang.storefront.account.orders.order.files.title'|t }}&nbsp;<span class="small text-muted">{{ 'lang.storefront.account.orders.order.files.expire'|t }}: {{ days }}</span></h6>
                                                                </div>
                                                            </li>

                                                            {% for key, digital_file in product.files %}
                                                                {% set downloads = product.files_settings.allowed_downloads ? product.files_settings.allowed_downloads : '∞' %}
                                                                {% set button_label = digital_file.size ? 'lang.storefront.account.orders.order.files.download'|t : 'lang.storefront.account.orders.order.files.open'|t %}
                                                                {% set file_size_info = digital_file.size ? digital_file.size : '' %}
                                                                {% set file_extra_info = '&nbsp;<span class="small text-muted">('~ file_size_info ~ (file_size_info ? ' | ' : '') ~ 'lang.storefront.account.orders.order.files.open'|t ~ ': ' ~ digital_file.downloads ~ '/'~ downloads ~')</span>' %}
                                                                {% set file_ext_info = digital_file.ext ? '<span class="label label-default">'~ digital_file.ext ~'</span>&nbsp;' : '' %}
                                                                <li class="list-group-item">
                                                                    <div class="text-truncate small" style="max-width: 200px; min-width: 100%">
                                                                        <h6 class="margin-0 semi-bold inline-block"><span class="file-info">{{ file_ext_info ~ digital_file.title }}</span>{{ file_extra_info }}</h6>
                                                                        <a class="pull-right btn btn-sm btn-primary {{ store.theme_options.button_primary_shadow }} btn-download" href="{{ digital_file.url }}" target="_blank">{{ button_label }}</a>
                                                                    </div>
                                                                </li>
                                                            {% endfor %}
                                                        </ul>
                                                    </div>
                                                {% endif %}
											</td>
											<td class="text-right">
												<p class="text-muted">{{ product.quantity }}x {{ product.price|money_with_sign(user.order_detail.currency) }}</p>
												{% set product_subtotal = (product.price * product.quantity) + product.price_extras %}
												<p class="">{{ product_subtotal|money_with_sign(user.order_detail.currency) }}</p>
											</td>
										</tr>
									{% endfor %}
								</tbody>
								<tfoot class="no-padding">
									<tr>
										<td colspan="2">{{ 'lang.storefront.order.shipping.title'|t }}</td>
										<td class="text-right">{{ user.order_detail.shipping.value|money_with_sign(user.order_detail.currency) }}</td>
									</tr>

									{% if user.order_detail.total_tax > 0 %}
										<tr>
											<td colspan="2">{{ user.order_detail.l10n.tax_name }}</td>
											<td class="text-right">{{ user.order_detail.total_tax|money_with_sign(user.order_detail.currency) }}</td>
										</tr>
									{% endif %}

									{% if user.order_detail.discount %}
										<tr>
                                            <td colspan="2">{{ 'lang.storefront.order.discount'|t }}
                                                {% if user.order_detail.coupon %}
                                                    <br><span class="text-muted">{{ 'lang.storefront.order.discount.coupon'|t }} <small>({{ user.order_detail.coupon.code }})</small></span>
                                                {% endif %}
                                                {% if user.order_detail.rewards.redeemed %}
                                                    <br><span class="text-muted">{{ store.settings.rewards.plural_label }} <small>(-{{ user.order_detail.rewards.total_redeemed|rewards_label }})</small></span>
                                                {% endif %}
                                            </td>
                                            <td class="text-right">
                                                <span class="no-wrap">{{ '- ' ~ user.order_detail.discount|money_with_sign(order.currency) }}</span>
                                                {% if user.order_detail.coupon %}
                                                    <br><span class="no-wrap text-muted">{{ '- ' ~ user.order_detail.coupon.discount|money_with_sign(order.currency) }}</span>
                                                {% endif %}
                                                {% if user.order_detail.rewards.redeemed %}
                                                    <br><span class="no-wrap text-muted">{{ '- ' ~ user.order_detail.rewards.discount|money_with_sign(order.currency) }}</span>
                                                {% endif %}
                                            </td>
										</tr>
									{% endif %}

									<tr>
										<td colspan="2"><strong>{{ 'lang.storefront.order.total'|t }}</strong></td>
										<td class="text-right"><strong>{{ user.order_detail.total|money_with_sign(user.order_detail.currency) }}</strong></td>
									</tr>
								</tfoot>
							</table>
						</div>
					{% endif %}

					{% if user.order_detail.custom_field %}
						<div class="well well-default {{ store.theme_options.well_default_shadow }}">
							{% for custom_field in user.order_detail.custom_field %}
								<h4 class="margin-bottom-xxs">{{ custom_field.title }}</h4>
								{% if custom_field.data %}
									{% for data in custom_field.data %}
										<p><strong>{{ data.key }}</strong>: {{ data.value }}</p>
									{% endfor %}
								{% else %}
									<p><strong>{{ custom_field.key }}</strong>: {{ custom_field.value }}</p>
								{% endif %}
								{{ loop.last ? '' : '<hr>' }}
							{% endfor %}
						</div>
					{% endif %}

				{% else %}
					{# Template for order list #}
					<h3 class="margin-bottom-xs margin-top-0 text-muted-dark light">{{ 'lang.storefront.layout.orders.title'|t }}</h3>
					{{ account_macros.order_table_list(user.orders) }}
				{% endif %}
			</div>
		</div>
	</div>

{% endblock %}