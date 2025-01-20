{#
Description: Payment Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    <div class="breadcrumbs hidden-xs">
        <div class="{{ layout_container }}">
            <ul class="breadcrumbs-list">
                <li class="breadcrumbs-item">
                    <a class="breadcrumbs-link" href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a>
                </li>
                <li class="breadcrumbs-item">
                    <a class="breadcrumbs-link" href="{{ site_url('cart') }}">{{ 'lang.storefront.cart.title'|t }}</a>
                </li>
                <li class="breadcrumbs-item">{{ 'lang.storefront.cart.checkout.title'|t }}</li>
            </ul>
        </div>
    </div>

    {% if errors.form %}
        <div class="{{ layout_container }}">
            <div class="callout callout-danger {{ store.theme_options.well_danger_shadow }}">
                <h4>{{ 'lang.storefront.layout.events.form.error'|t }}</h4>
                {{ errors.form }}
            </div>
        </div>
    {% endif %}

    {% if warnings.form %}
        <div class="{{ layout_container }}">
            <div class="callout callout-warning {{ store.theme_options.well_warning_shadow }}">
                <h4>{{ 'lang.storefront.layout.events.form.warning'|t }}</h4>
                {{ warnings.form }}
            </div>
        </div>
    {% endif %}

    {% if success.form %}
        <div class="callout callout-success {{ store.theme_options.well_success_shadow }}">
            <h4>{{ 'lang.storefront.layout.events.form.success'|t }}</h4>
            {{ success.form }}
        </div>
    {% endif %}

    <div class="{{ layout_container }}">
        {{ generic_macros.cart_notice() }}
    </div>

    {% if cart.items %}

        {{ form_open('cart/post/confirm', { 'class' : 'form', 'id' : 'form-payment' }) }}

            <div class="checkout section">
                <div class="{{ layout_container }}">
                    <h2 class="checkout-title title title_mb-lg">{{ 'lang.storefront.cart.payment.title'|t }}</h2>

                    <div class="checkout-row">
                        <div class="checkout-col">

                            <div class="checkout-steps">
                                <div class="checkout-step active" data-toggle="tooltip" data-placement="top" title="{{ 'lang.storefront.cart.checkout.client.title'|t }}"><a href="{{ site_url('cart/data') }}">1</a></div>
                                <div class="checkout-step active" data-toggle="tooltip" data-placement="top" title="{{ 'lang.storefront.cart.payment.title'|t }}"><a href="{{ site_url('cart/payment') }}">2</a></div>
                                <div class="checkout-step" data-toggle="tooltip" data-placement="top" title="{{ 'lang.storefront.cart.confirm.title'|t }}">3</div>
                            </div>

                            <div class="checkout-container well-featured {{ store.theme_options.well_featured_shadow }}">
                                {% if cart.shipping_methods %}
                                    <div class="checkout-item shipping-methods">
                                        <div class="checkout-category">{{ 'lang.storefront.order.shipment'|t }}</div>
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
                                    <div class="checkou-item payment-methods">
                                        <div class="checkout-category">{{ 'lang.storefront.order.payment.title'|t }}</div>
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

                                                        {% if payment.alias == 'credit_card'  %}
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
                            </div>

                        </div>

                        <div class="checkout-col">

                            <div class="basket basket-checkout order-resume well-featured {{ store.theme_options.well_featured_shadow }}">
                                <div class="basket-category">{{ 'lang.storefront.cart.order_summary.title'|t }}</div>
                                <div class="basket-resume">
                                    <div class="basket-total">
                                        <div class="basket-text">{{ 'lang.storefront.layout.subtotal.title'|t }}</div>
                                        <div class="basket-text">{{ cart.subtotal | money_with_sign }}</div>
                                    </div>

                                    {% if cart.coupon %}
                                        <div class="basket-total">
                                            <div class="basket-text">{{ 'lang.storefront.order.discount'|t }}</div>
                                            <div class="basket-text">{{ cart.coupon.type == 'shipping' ? 'lang.storefront.cart.order_summary.free_shipping'|t : '- ' ~ cart.discount | money_with_sign }}</div>
                                        </div>
                                    {% endif %}

                                    <div class="basket-total shipping">
                                        {% set no_shipping_text = 'lang.storefront.cart.order_summary.shipping.calculating.text'|t ~ ' <span data-toggle="tooltip" data-placement="top" title="' ~ 'lang.storefront.cart.order_summary.shipping.calculating.tooltip'|t ~ '"><i class="fa fa-question-circle"></i></span>' %}
                                        <div class="basket-text">{{ 'lang.storefront.cart.order_summary.shipping.title'|t }}</div>
                                        <div class="basket-text shipping-value total-shipping">{{ cart.shipping_methods ? (user.shipping_method ? (cart.coupon.type == 'shipping' or cart.total_shipping == 0 ? 'lang.storefront.cart.order_summary.shipping_total.free'|t : cart.total_shipping | money_with_sign) : no_shipping_text) : cart.total_shipping | money_with_sign }}</div>
                                    </div>

                                    <div class="basket-total payment-tax {{ not cart.total_payment ? 'hidden' }}">
                                        <div class="basket-text">{{ 'lang.storefront.cart.order_summary.total_payment'|t }} <span data-toggle="tooltip" data-placement="top" title="{{ user.payment_method.title }}"><i class="fa fa-question-circle"></i></span></div>
                                        <div class="basket-text payment-tax-value">{{ cart.total_payment | money_with_sign }}</div>
                                    </div>

                                    {% if not store.taxes_included or cart.total_taxes == 0 %}
                                        <div class="basket-total total-taxes">
                                            <div class="basket-text">{{ user.l10n.tax_name }}</div>
                                            <div class="basket-text total-taxes-value">{{ cart.total_taxes | money_with_sign }}</div>
                                        </div>
                                    {% endif %}

                                    <hr>

                                    <div class="basket-total total">
                                        <div class="basket-text">{{ 'lang.storefront.order.total'|t }}</div>
                                        <div class="basket-text total-value">{{ cart.total | money_with_sign }}</div>
                                    </div>
                                    {% if store.taxes_included and cart.total_taxes > 0 %}
                                        <div class="tax-included total-taxes text-right small">
                                            <small class="text-muted">{{ 'lang.storefront.cart.order_summary.taxes_included'|t([user.l10n.tax_name, cart.total_taxes|money_with_sign]) }}</small>
                                        </div>
                                    {% endif %}

                                    {% if cart.coupon %}
                                        <hr>

                                        <div class="coupon-code margin-top margin-bottom">
                                            <label for="cupao">{{ 'lang.storefront.cart.order_summary.coupon_code.title'|t }}</label>

                                            <div class="coupon-code-label margin-top-xxs">
                                                <span class="badge badge-light-bg h5">
                                                    <i class="fa fa-tags fa-fw" aria-hidden="true"></i>
                                                    <span class="coupon-code-text">{{ cart.coupon.code }}</span>
                                                    <a href="{{ site_url('cart/coupon/remove') }}" class="btn-close"><i class="fa fa-times fa-fw" aria-hidden="true"></i></a>
                                                </span>
                                            </div>
                                        </div>

                                    {% endif %}

                                    <hr>
                                </div>

                                <button class="basket-button btn btn-primary {{ store.theme_options.button_primary_shadow }} btn-block">{{ 'lang.storefront.layout.button.checkout'|t }} <i data-feather="arrow-right"></i></button>
                            </div>

                        </div>

                    </div>
                </div>
            </div>

        {{ form_close() }}

    {% else %}
        <div class="checkout section">
            <div class="{{ layout_container }}">
                <div class="checkout-row">
                    <div class="checkout-col">
                        <p class="h2 light text-light-grey margin-top-lg">{{ 'lang.storefront.cart.no_products'|t }}</p>
                    </div>
                </div>
            </div>
        </div>
    {% endif %}

{% endblock %}

