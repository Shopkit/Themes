<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>{{ 'lang.storefront.order.order_with_id'|t([order.id]) }}</title>
        {% if store.favicon %}
            <link rel="shortcut icon" href="{{ store.favicon }}">
        {% endif %}
        <link href="https://fonts.googleapis.com/css?family=Lato:100,300,400,700,900,400italic" rel="stylesheet">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <link rel="stylesheet" href="{{ assets_url('assets/common/vendor/fontawesome/4.7/css/font-awesome.min.css') }}">
        <link rel="stylesheet" href="{{ assets_url('templates/assets/common/css/order-payment.css')}}">

        <script src="{{ assets_url('assets/common/vendor/modernizr/2.7.1/modernizr.min.js') }}"></script>
        <script src="{{ assets_url('assets/common/vendor/jquery/1.11.2/jquery.min.js') }}"></script>

        <script>var order = {{ json_encode(order) }};</script>

        {{ head_content }}

    </head>
    <body class="{{ css_class }}">
        <table>
            <tr>
                <td>
                    <table class="table-width-wrapper">
                        <tbody>
                            <tr>
                                <td class="table-hz-margin">&nbsp;</td>
                                <td class="table-width-inner">
                                    <table class="table-width-inner">
                                        <tr>
                                            <td class="table-vt-margin">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td class="logo text-center">
                                                {% if store.logo %}
                                                    <a href="{{ site_url() }}"><img src="{{ store.logo }}" alt="{{ store.name }}" title="{{ store.name }}" class="logo"/></a>
                                                {% else %}
                                                    <a href="{{ site_url() }}" class="logo">{{ store.name }}</a>
                                                {% endif %}
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="table-vt-margin">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <div class="order-content">
                                                {% if not events.payment_status %}

                                                    <div class="block">
                                                        <table class="font-size-lg">
                                                            <tr>
                                                                <td class="text-left" style="width:50%;vertical-align:middle;">#{{ order.id }}</td>
                                                                <td class="text-right" style="width:50%;vertical-align:middle;"><span class="text-nowrap">{{ order.updated_at|format_datetime('long','none') }}</span></td>
                                                            </tr>
                                                        </table>
                                                    </div>

                                                    <div class="block">

                                                        {% if order.products %}
                                                            <table class="table-order-products">

                                                                {% for product in order.products %}
                                                                    <tr>
                                                                        <td class="td-product-img"><img src="{{ product.image.square }}" alt="{{ product.title }}" class="order-product-img" /></td>
                                                                        <td style="width:20px;">&nbsp;</td>
                                                                        <td>
                                                                            <strong class="text-dark-gray">{{ product.title }}</strong>
                                                                            <br />{{ product.option }}&nbsp;
                                                                        </td>
                                                                        <td class="text-right">
                                                                            <span class="text-nowrap text-light-gray">{{ product.quantity }}x {{ product.price|money_with_sign(order.currency) }}</span><br />

                                                                            {% set product_subtotal = product.price * product.quantity %}
                                                                            <span class="text-nowrap text-dark-gray">{{ product_subtotal|money_with_sign(order.currency) }}</span>
                                                                        </td>
                                                                    </tr>
                                                                    <tr>
                                                                        <td colspan="4" style="height:30px;">&nbsp;

                                                                        </td>
                                                                    </tr>
                                                                {% endfor %}

                                                            </table>
                                                        {% endif %}
                                                        <table class="table-order-resume">
                                                            <tr>
                                                                <td class="text-left" style="height:20px;" colspan="2">&nbsp;</td>
                                                            </tr>
                                                            <tr>
                                                                <td class="text-left">{{ 'lang.storefront.layout.subtotal.title'|t }}</td>
                                                                <td class="text-right"><span class="text-nowrap subtotal">{{ order.subtotal|money_with_sign(order.currency) }}</span></td>
                                                            </tr>

                                                            {% if order.discount %}
																<tr>
																	<td class="text-left">{{ 'lang.storefront.order.discount'|t }}
																		{% if order.coupon %}
																			<br><span class="text-light-gray">{{ 'lang.storefront.order.discount.coupon'|t }} <small>({{ order.coupon.code }})</small></span>
																		{% endif %}
																		{% if order.rewards.redeemed %}
																			<br><span class="text-light-gray">{{ store.settings.rewards.plural_label }} <small>(-{{ order.rewards.total_redeemed|rewards_label }})</small></span>
																		{% endif %}
																	</td>
																	<td class="text-right">
																		<span class="no-wrap">{{ '- ' ~ order.discount|money_with_sign(order.currency) }}</span>
																		{% if order.coupon %}
																			<br><span class="no-wrap text-light-gray">{{ order.coupon.type == 'shipping' ? 'lang.storefront.cart.order_summary.free_shipping'|t : '- ' ~ order.coupon.discount|money_with_sign(order.currency) }}</span>
																		{% endif %}
																		{% if order.rewards.redeemed %}
																			<br><span class="no-wrap text-light-gray">{{ '- ' ~ order.rewards.discount|money_with_sign(order.currency) }}</span>
																		{% endif %}
																	</td>
																</tr>
															{% endif %}

                                                            <tr>
                                                                <td class="text-left">{{ 'lang.storefront.cart.order_summary.shipping.title'|t }}</td>
                                                                <td class="text-right"><span class="text-nowrap shipping">{{ order.coupon.type == 'shipping' ? 'lang.storefront.cart.order_summary.shipping_total.free'|t : order.shipping.value|money_with_sign(order.currency) }}</span></td>
                                                            </tr>

                                                            <tr class="{{ order.payment.value ? '' : 'hidden' }}">
                                                                <td class="text-left">{{ 'lang.storefront.cart.order_summary.total_payment'|t }} <small class="payment-title">({{ order.payment.title }})</small></td>
                                                                <td class="text-right"><span class="text-nowrap payment">{{ order.payment.value|money_with_sign(order.currency) }}</span></td>
                                                            </tr>

                                                            {% if order.total_tax > 0 %}
                                                                <tr>
                                                                    <td class="text-left">{{ order.l10n.tax_name }}</td>
                                                                    <td class="text-right"><span class="text-nowrap total_tax">{{ order.total_tax|money_with_sign(order.currency) }}</span></td>
                                                                </tr>
                                                            {% endif %}

                                                            <tr>
                                                                <td class="text-left text-dark"><strong>{{ 'lang.storefront.order.total'|t }}</strong></td>
                                                                <td class="text-right text-dark"><strong class="text-nowrap total">{{ order.total|money_with_sign(order.currency) }}</strong></td>
                                                            </tr>
                                                        </table>

                                                    </div>

                                                    <div class="block no-border">
                                                        {{ form_open( "order/post/payment/#{order.hash}", { 'class' : 'form', 'id' : 'form-payment' }) }}

                                                        <h3 class="block-title margin-bottom margin-top-0">{{ 'lang.storefront.order.payment.title'|t }}</h3>

                                                        {% if errors.form %}
                                                            <div class="callout callout-danger">
                                                                <h4>{{ 'lang.storefront.layout.events.form.error'|t }}</h4>
                                                                {{ errors.form }}
                                                            </div>
                                                        {% endif %}

                                                        <div class="payment-methods">
                                                            <ul class="list-group">
                                                                {% for payment in cart.payments %}
                                                                    {% if payment.active %}

                                                                        {% set hide_payment = get.payment and get.payment is not same as(payment.type) ? 'hide' %}

                                                                        <li class="list-group-item list-radio-block payment-method-{{ payment.type }} {{ hide_payment }}">
                                                                            <label for="{{ payment.type }}">
                                                                                <div class="list-radio-content">
                                                                                    <div class="list-radio-input">
                                                                                        <input type="radio" name="pagamento" id="{{ payment.type }}" value="{{ payment.type }}">
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
                                                                                                    <img src="{{ payment.logo }}" alt="{{ payment.title }}" title="{{ payment.title }}" height="25">
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
                                                                            {% if payment.type == 'credit_card' %}
                                                                                <div id="card-element"></div>
                                                                            {% endif %}
                                                                        </li>

                                                                    {% endif %}
                                                                {% endfor %}
                                                            </ul>

                                                            <p><a href="#" class="show-all-payments hide">{{ 'lang.storefront.order_payment.more_payment_methods'|t }}</a></p>
                                                        </div>

                                                        <div class="clearfix">
                                                            <div class="pull-right">
                                                                <button class="btn btn-submit">{{ 'lang.storefront.cart.data.proceed.button'|t }} <i class="fa fa-fw fa-arrow-right"></i></button>
                                                            </div>
                                                        </div>

                                                        {{ form_close() }}
                                                    </div>
                                                {% endif %}

                                                {% if events.payment_status %}
                                                    {% set show_payment_message = order.payment.type == 'multibanco' ? order.payment.data and order.payment.data.reference : events.payment_status.success is null %}

                                                    <div style="line-height: 140%; padding:30px 20px;">
                                                        <div class="text-center margin-bottom">
                                                            {% if events.payment_status.success is same as (true) %}
                                                                <i class="fa fa-check fa-4x text-success"></i>
                                                            {% elseif events.payment_status.success is same as (false) %}
                                                                <i class="fa fa-times fa-4x text-light-gray"></i>
                                                            {% else %}
                                                                <i class="fa fa-check fa-4x text-light-gray"></i>
                                                            {% endif %}

                                                            <h3 class="text-muted">{{ 'lang.storefront.order_payment.payment_changed.success'|t }}</h3>
                                                            <h3 class="light text-light-gray">#{{ order.id }}</h3>
                                                        </div>

                                                        {% if events.payment_status.message %}
                                                            <div class="callout callout-danger margin-left margin-right">
                                                                <h4>{{ 'lang.storefront.order_payment.status.error'|t }}</h4>
                                                                <p></p>
                                                                <p>{{ events.payment_status.message }}</p>
                                                            </div>
                                                        {% endif %}

                                                        <ul class="list-group margin-left margin-right">
                                                            <li class="list-group-item">
                                                                <span class="badge">{{ order.id }}</span>
                                                                {{ 'lang.storefront.cart.complete.order_number.label'|t }}:
                                                            </li>
                                                            <li class="list-group-item">
                                                                <span class="badge price">{{ order.total | money_with_sign }}</span>
                                                                {{ 'lang.storefront.order.total'|t }}:
                                                            </li>
                                                            <li class="list-group-item">
                                                                <span class="badge">{{ order.payment.title }}</span>
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

                                                                    {% elseif order.payment.type == 'paypal' and order.payment.data.url %}
                                                                        <div class="paypal-data margin-top-sm">
                                                                            <a href="{{ order.payment.data.url }}" target="_blank" class="btn btn-info btn-lg"><i class="fa fa-fw fa-paypal" aria-hidden="true"></i> {{ 'lang.storefront.order.payment.paypal'|t }}</a>
                                                                        </div>

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

                                                                    {% endif %}
                                                                </div>
                                                            </li>
                                                        </ul>

                                                        {% if show_payment_message %}
                                                            {% if cart.payments[order.payment.type].message %}
                                                                <div class="well payment-msg margin-left margin-right">
                                                                    {{ cart.payments[order.payment.type].message }}
                                                                </div>
                                                            {% endif %}
                                                        {% endif %}

                                                    </div>
                                                {% endif %}

                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td class="table-vt-margin">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td class="text-center text-gray" style="line-height:24px;">
                                                <strong>{{ store.name }}</strong><br />

                                                {% if store.show_email %}
                                                    <a href="mailto:{{ store.email }}">{{ store.email }}</a><br />
                                                {% endif %}

                                                {{ store.address|nl2br }}
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="height:30px;">&nbsp;</td>
                                        </tr>
                                        <tr>
                                            <td class="text-center text-light-gray font-size-xs">{{ 'lang.email.order.date'|t([order.created_at|format_datetime('long','long')]) }}</td>
                                        </tr>

                                        {% if store.show_branding %}
                                            <tr>
                                                <td style="height:30px;">&nbsp;</td>
                                            </tr>
                                            <tr>
                                                <td class="text-center">
                                                    <div style="display:inline-block; border-top: 1px solid #ddd; padding-left:30px; padding-right:30px; padding-top:30px;">
                                                        <a href="https://shopk.it/?utm_source={{ store.username }}&amp;utm_medium=email&amp;utm_campaign=Shopkit-Stores-Branding" title="Powered by Shopkit e-commerce" target="_blank" rel="nofollow"><img class="logo-footer" src="{{ assets_url('assets/frontend/img/logo-shopkit-black-transparent.png') }}" title="Powered by Shopkit e-commerce" height="25" style="border:0;height:25px;" border="0" alt="Powered by Shopkit e-commerce" /></a>
                                                    </div>
                                                </td>
                                            </tr>
                                        {% endif %}
                                        <tr>
                                            <td class="table-vt-margin">&nbsp;</td>
                                        </tr>
                                    </table>
                                </td>
                                <td class="table-hz-margin">&nbsp;</td>
                            </tr>
                        </tbody>
                    </table>

                </td>
            </tr>
        </table>

        <script>
            $(document).ready(function() {
                if ($('.payment-methods ul li').hasClass('hide')) {
                    $('a.show-all-payments').removeClass('hide');
                }

                $('#form-payment').submit(function() {
                    $('body').css({ 'cursor': 'wait' });
                    $(this).find('button').prop('disabled', true);
                });

                $(document).on('click', 'a.show-all-payments', function(event) {
                    $('.payment-methods ul li').removeClass('hide');
                    $(this).remove();

                    event.preventDefault();
                });
            });
        </script>

        {{ footer_content }}

    </body>
</html>
