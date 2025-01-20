{#
Description: Order data form page
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

    {{ form_open('cart/post/payment', {'role': 'form'}) }}

        <input type="hidden" name="user-auth-data" value="true">

        <div class="checkout section">
            <div class="{{ layout_container }}">

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

                <h2 class="checkout-title title title_mb-lg">{{ 'lang.storefront.cart.checkout.title'|t }}</h2>

                <div class="checkout-row">
                    <div class="checkout-col">

                        <div class="checkout-steps">
                            <div class="checkout-step active" data-toggle="tooltip" data-placement="top" title="{{ 'lang.storefront.cart.checkout.client.title'|t }}"><a href="{{ site_url('cart/data') }}">1</a></div>
                            <div class="checkout-step" data-toggle="tooltip" data-placement="top" title="{{ 'lang.storefront.cart.payment.title'|t }}">2</div>
                            <div class="checkout-step" data-toggle="tooltip" data-placement="top" title="{{ 'lang.storefront.cart.confirm.title'|t }}">3</div>
                        </div>

                        <div class="checkout-container well-featured {{ store.theme_options.well_featured_shadow }}">
                            <div class="checkout-item">
                                <div class="checkout-category">{{ 'lang.storefront.cart.checkout.client.title'|t }}</div>

                                {% if not user.is_logged_in %}
                                    {% if store.settings.cart.users_registration == 'optional' %}
                                        <div class="well well-default {{ store.theme_options.well_default_shadow }} margin-bottom">
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
                                        <div class="row">
                                            <div class="col-sm-6">
                                                <h3>{{ 'lang.storefront.cart.checkout.client.title'|t }}</h3>
                                                {{ user.email }}<br>
                                                {{ user.l10n.tax_id_abbr }}: {{ user.fiscal_id ? user.fiscal_id : 'n/a' }}<br>
                                                {{ 'lang.storefront.order.client.company'|t }}: {{ user.company ? user.company : 'n/a' }}
                                            </div>
                                        </div>

                                        <div class="row">
                                            <div class="col-sm-6 margin-top">
                                                <h3>{{ 'lang.storefront.order.delivery.address'|t }}</h3>
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
                                                <a href="{{ site_url('account/profile') }}" class="text-underline">{{ 'lang.storefront.order.edit'|t }}</a>
                                            </div>
                                            <div class="col-sm-6 margin-top">
                                                <h3>{{ 'lang.storefront.order.billing.address'|t }}</h3>
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
                                                <a href="{{ site_url('account/profile') }}" class="text-underline">{{ 'lang.storefront.order.edit'|t }}</a>
                                            </div>
                                        </div>

                                    {% else %}

                                        <div class="checkout-fieldset">
                                            <div class="form-group {{ apps.newsletter ? 'margin-bottom-xs' : 'margin-bottom-sm' }}">
                                                <label for="email">{{ 'lang.storefront.form.email.label'|t }}</label>
                                                <input class="form-control" type="email" name="email" id="email" value="{{ user.email }}" required>
                                            </div>

                                            {% if apps.newsletter %}
                                                <div class="form-group margin-bottom-md">
                                                    <div class="checkbox">
                                                        <label>
                                                            <input type="checkbox" name="subscribe_newsletter" id="subscribe_newsletter" value="1" {% if user.subscribe_newsletter %} checked {% endif %}>
                                                            {{ apps.newsletter.label }}
                                                        </label>
                                                    </div>
                                                </div>
                                            {% endif %}

                                            <div class="row">
                                                {% if store.settings.cart.field_company != 'hidden' %}
                                                    <div class="col-sm-8 margin-bottom-sm">
                                                        <div class="form-group">
                                                            <label for="company">{{ 'lang.storefront.order.client.company'|t }} {{ store.settings.cart.field_company == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
                                                            <input type="text" name="company" id="company" class="form-control" value="{{ user.company }}" placeholder="{{ store.settings.cart.field_company == 'optional' ? 'lang.storefront.form.optional.placeholder'|t }}" {{ store.settings.cart.field_company == 'required' ? 'required' }}>
                                                        </div>
                                                    </div>
                                                {% endif %}

                                                {% if store.settings.cart.field_fiscal_id != 'hidden' %}
                                                    <div class="col-sm-4 margin-bottom-sm">
                                                        <div class="form-group">
                                                            <label for="fiscal_id">{{ user.l10n.tax_id_abbr }} {{ store.settings.cart.field_fiscal_id == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
                                                            <input type="text" name="fiscal_id" id="fiscal_id" class="form-control" value="{{ user.fiscal_id }}" placeholder="{{ store.settings.cart.field_fiscal_id == 'optional' ? 'lang.storefront.form.optional.placeholder'|t }}" {{ store.settings.cart.field_fiscal_id == 'required' ? 'required' }}>
                                                        </div>
                                                    </div>
                                                {% endif %}
                                            </div>

                                            {% if not cart.is_digital %}
                                                <h2 class="title_mb-md margin-top-sm">{{ 'lang.storefront.order.delivery.address'|t }}</h2>

                                                <div class="delivery-info">
                                                    <div class="row">
                                                        <div class="col-sm-8 margin-bottom-sm">
                                                            <div class="form-group">
                                                                <label for="delivery_name">{{ 'lang.storefront.form.name.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                                                <input type="text" name="delivery_name" id="delivery_name" class="form-control" value="{{ user.delivery.name }}" required>
                                                            </div>
                                                        </div>
                                                        {% if store.settings.cart.field_delivery_phone != 'hidden' %}
                                                            <div class="col-sm-4 margin-bottom-sm">
                                                                <div class="form-group">
                                                                    <label for="delivery_phone">{{ 'lang.storefront.form.phone.label'|t }} {{ store.settings.cart.field_delivery_phone == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
                                                                    <input type="tel" name="delivery_phone" id="delivery_phone" class="form-control intl-validate" value="{{ user.delivery.phone }}" placeholder="{{ store.settings.cart.field_delivery_phone == 'optional' ? 'lang.storefront.form.optional.placeholder'|t }}">
                                                                </div>
                                                            </div>
                                                        {% endif %}
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-sm-12">
                                                            <div class="form-group">
                                                                <label for="delivery_address">{{ 'lang.storefront.form.address.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                                                <div class="row">
                                                                    <div class="col-sm-8 margin-bottom-sm">
                                                                        <input type="text" id="delivery_address" class="form-control" placeholder="{{ 'lang.storefront.form.address.label'|t }}" name="delivery_address" value="{{ user.delivery.address }}" data-places="route" required>
                                                                    </div>
                                                                    <div class="col-sm-4 margin-bottom-sm">
                                                                        <input type="text" class="form-control" placeholder="{{ 'lang.storefront.form.address.extra.placeholder'|t }}" name="delivery_address_extra" id="delivery_address_extra" value="{{ user.delivery.address_extra }}" autocomplete="off">
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="row">
                                                        <div class="col-sm-6 margin-bottom-sm">
                                                            <div class="form-group">
                                                                <label for="delivery_zip_code">{{ 'lang.storefront.form.zip_code.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                                                <input type="text" name="delivery_zip_code" id="delivery_zip_code" class="form-control" value="{{ user.delivery.zip_code }}" data-places="postal_code" required>
                                                            </div>
                                                        </div>
                                                        <div class="col-sm-6 margin-bottom-sm">
                                                            <div class="form-group">
                                                                <label for="delivery_city">{{ 'lang.storefront.form.city.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                                                <input type="text" name="delivery_city" id="delivery_city" class="form-control" value="{{ user.delivery.city }}" data-places="locality" required>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div class="row">
                                                        <div class="col margin-bottom-sm">
                                                            <div class="form-group">
                                                                <label for="delivery_country">{{ 'lang.storefront.form.country.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                                                <select name="delivery_country" id="delivery_country" class="form-control" required>
                                                                    <option value selected disabled>{{ 'lang.storefront.form.country.select.default'|t }}</option>
                                                                    {% for key, country in countries %}
                                                                        <option value="{{ key }}" {% if user.delivery.country_code == key %} selected {% endif %}>{{ country }}</option>
                                                                    {% endfor %}
                                                                </select>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            {% endif %}

                                            <h2 class="title_mb-md margin-top-sm">{{ 'lang.storefront.order.billing.address'|t }}</h3>
                                            {% if not cart.is_digital %}
                                                <div class="checkbox">
                                                    <label>
                                                        <input type="checkbox" name="billing_info_same_delivery" id="billing_info_same_delivery" value="1" {% if not user.billing.same_as_delivery is same as(false) %} checked {% endif %} data-target=".billing-info">
                                                        {{ 'lang.storefront.order.billing_info_same_delivery'|t }}
                                                    </label>
                                                </div>
                                            {% endif %}
                                            <div class="{% if not cart.is_digital and not user.billing.same_as_delivery is same as(false) %}d-none{% endif %} billing-info margin-top">
                                                <div class="row">
                                                    <div class="col-sm-8 margin-bottom-sm">
                                                        <div class="form-group">
                                                            <label for="billing_name">{{ 'lang.storefront.form.name.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                                            <input type="text" name="billing_name" id="billing_name" class="form-control" value="{{ user.billing.name }}">
                                                        </div>
                                                    </div>
                                                    {% if store.settings.cart.field_billing_phone != 'hidden' %}
                                                        <div class="col-sm-4 margin-bottom-sm">
                                                            <div class="form-group">
                                                                <label for="billing_phone">{{ 'lang.storefront.form.phone.label'|t }} {{ store.settings.cart.field_billing_phone == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
                                                                <input type="tel" name="billing_phone" id="billing_phone" class="form-control intl-validate" value="{{ user.billing.phone }}" placeholder="{{ store.settings.cart.field_billing_phone == 'optional' ? 'lang.storefront.form.optional.placeholder'|t }}">
                                                            </div>
                                                        </div>
                                                    {% endif %}
                                                </div>

                                                <div class="row">
                                                    <div class="col-sm-12">
                                                        <div class="form-group">
                                                            <label for="billing_address">{{ 'lang.storefront.form.address.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                                            <div class="row">
                                                                <div class="col-sm-8 margin-bottom-sm">
                                                                    <input type="text" id="billing_address" class="form-control" placeholder="{{ 'lang.storefront.form.address.label'|t }}" name="billing_address" value="{{ user.billing.address }}" data-places="route">
                                                                </div>
                                                                <div class="col-sm-4 margin-bottom-sm">
                                                                    <input type="text" class="form-control" placeholder="{{ 'lang.storefront.form.address.extra.placeholder'|t }}" name="billing_address_extra" id="billing_address_extra" value="{{ user.billing.address_extra }}">
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="row">
                                                    <div class="col-sm-6 margin-bottom-sm">
                                                        <div class="form-group">
                                                            <label for="billing_zip_code">{{ 'lang.storefront.form.zip_code.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                                            <input type="text" name="billing_zip_code" id="billing_zip_code" class="form-control" value="{{ user.billing.zip_code }}" data-places="postal_code">
                                                        </div>
                                                    </div>
                                                    <div class="col-sm-6 margin-bottom-sm">
                                                        <div class="form-group">
                                                            <label for="billing_city">{{ 'lang.storefront.form.city.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                                            <input type="text" name="billing_city" id="billing_city" class="form-control" value="{{ user.billing.city }}" data-places="locality">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="row">
                                                    <div class="col margin-bottom-sm">
                                                        <div class="form-group">
                                                            <label for="billing_country">{{ 'lang.storefront.form.country.label'|t }} <small class="text-light-gray normal">(*)</small></label>
                                                            <select name="billing_country" id="billing_country" class="form-control">
                                                                <option value selected disabled>{{ 'lang.storefront.form.country.select.default'|t }}</option>
                                                                {% for key, country in countries %}
                                                                    <option value="{{ key }}" {% if user.billing.country_code == key %} selected {% endif %}>{{ country }}</option>
                                                                {% endfor %}
                                                            </select>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>

                                        </div>

                                    {% endif %}

                                    <div class="row">
                                        <div class="col-sm-12">
                                            <div class="form-group margin-top">
                                                <label for="observations">{{ 'lang.storefront.order.observations'|t }} <small class="text-light-gray normal">({{ 'lang.storefront.form.optional.placeholder'|t }})</small></label>
                                                <textarea cols="80" rows="4" class="form-control" id="observations" name="observations" placeholder="{{ 'lang.storefront.cart.data.observations.placeholder'|t }}">{{ user.observations }}</textarea>
                                            </div>
                                        </div>
                                    </div>

                                {% endif %}

                            </div>
                        </div>

                    </div>

                    <div class="checkout-col">

                        <div class="basket basket-checkout well-featured {{ store.theme_options.well_featured_shadow }}">
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

                                <div class="basket-total">
                                    {% set no_shipping_text = 'lang.storefront.cart.order_summary.shipping.calculating.text'|t ~ ' <span data-toggle="tooltip" data-placement="top" title="' ~ 'lang.storefront.cart.order_summary.shipping.calculating.tooltip'|t ~ '"><i class="fa fa-question-circle"></i></span>' %}
                                    <div class="basket-text">{{ 'lang.storefront.cart.order_summary.shipping.title'|t }}</div>
                                    <div class="basket-text total-shipping">{{ cart.shipping_methods ? (user.shipping_method ? (cart.coupon.type == 'shipping' or cart.total_shipping == 0 ? 'lang.storefront.cart.order_summary.shipping_total.free'|t : cart.total_shipping | money_with_sign) : no_shipping_text) : cart.total_shipping | money_with_sign }}</div>
                                </div>

                                {% if cart.total_payment %}
                                    <div class="basket-total">
                                        <div class="basket-text">{{ 'lang.storefront.cart.order_summary.total_payment'|t }} <span data-toggle="tooltip" data-placement="top" title="{{ user.payment_method.title }}"><i class="fa fa-question-circle"></i></span></div>
                                        <div class="basket-text">{{ cart.total_payment | money_with_sign }}</div>
                                    </div>
                                {% endif %}

                                {% if not store.taxes_included or cart.total_taxes == 0 %}
                                    <div class="basket-total">
                                        <div class="basket-text">{{ user.l10n.tax_name }}</div>
                                        <div class="basket-text">{{ cart.total_taxes | money_with_sign }}</div>
                                    </div>
                                {% endif %}

                                <hr>

                                <div class="basket-total">
                                    <div class="basket-text">{{ 'lang.storefront.order.total'|t }}</div>
                                    <div class="basket-text">{{ cart.total | money_with_sign }}</div>
                                </div>
                                {% if store.taxes_included and cart.total_taxes > 0 %}
                                    <div class="tax-included text-right small">
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

{% endblock %}
