{#
Description: Confirm order page
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

    {% if cart.items %}
        {{ form_open('cart/complete', { 'role' : 'form' }) }}

            <div class="checkout section">
                <div class="{{ layout_container }}">
                    <h2 class="checkout-title title title_mb-lg">{{ 'lang.storefront.cart.confirm.title'|t }}</h2>

                    <div class="checkout-row">
                        <div class="checkout-col">

                            <div class="checkout-steps">
                                <div class="checkout-step active" data-toggle="tooltip" data-placement="top" title="{{ 'lang.storefront.cart.checkout.client.title'|t }}"><a href="{{ site_url('cart/data') }}">1</a></div>
                                <div class="checkout-step active" data-toggle="tooltip" data-placement="top" title="{{ 'lang.storefront.cart.payment.title'|t }}"><a href="{{ site_url('cart/payment') }}">2</a></div>
                                <div class="checkout-step active" data-toggle="tooltip" data-placement="top" title="{{ 'lang.storefront.cart.confirm.title'|t }}"><a href="{{ site_url('cart/confirm') }}">3</a></div>
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
                                <div class="{{ layout_container }}">
                                    <div class="callout callout-success {{ store.theme_options.well_success_shadow }}">
                                        <h4>{{ 'lang.storefront.layout.events.form.success'|t }}</h4>
                                        {{ success.form }}
                                    </div>
                                </div>
                            {% endif %}

                            <div class="{{ layout_container }}">
                                {{ generic_macros.cart_notice() }}
                            </div>

                            <div class="checkout-container well-featured {{ store.theme_options.well_featured_shadow }}">

                                <div class="row">
                                    <div class="col">
                                        <div class="checkout-category">{{ 'lang.storefront.macros.products.title'|t }}</div>
                                        <div class="cart-list">
                                            {% for item in cart.items %}
                                                <div class="cart-item" data-product="{{ item.product_id }}" data-product-option="{{ item.options|keys[0] }}">
                                                    <a class="cart-preview" href="{{ item.product_url }}">
                                                        <img class="cart-pic lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ item.image }}" alt="{{ item.image.alt ? item.image.alt : item.title|e }}" title="{{ item.title|e }}">
                                                    </a>
                                                    <div class="cart-details">
                                                        <div class="row">
                                                            <div class="cart-details-info">
                                                                <a class="cart-product margin-bottom-0" href="{{ item.product_url }}">{{ item.title }}</a>

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
                                                            </div>
                                                            <div class="cart-price">
                                                                <div class="cart-actual">{{ item.subtotal | money_with_sign }}</div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            {% endfor %}
                                        </div>
                                    </div>
                                </div>

                                <div class="row margin-top">
                                    <div class="col-sm-6">
                                        <div class="checkout-category margin-bottom-sm">{{ 'lang.storefront.order.payment.title'|t }}</div>
                                        <p>{{ user.payment_method.title }}</p>
                                    </div>
                                    <div class="col-sm-6">
                                        {% if user.shipping_method %}
                                            <div class="checkout-category margin-bottom-sm">{{ 'lang.storefront.order.shipment'|t }}</div>
                                            <p>{{ user.shipping_method.title }}</p>
                                        {% endif %}
                                    </div>
                                </div>

                                <div class="row margin-top">
                                    <div class="col-sm-6">
                                        <div class="checkout-category margin-bottom-sm">{{ 'lang.storefront.cart.checkout.client.title'|t }}</div>
                                        <p>
                                            {{ user.email }}<br>
                                            {% if store.settings.cart.field_fiscal_id != 'hidden' %}
                                                {{ user.l10n.tax_id_abbr }}: {{ user.fiscal_id ? user.fiscal_id : 'n/a' }}<br>
                                            {% endif %}
                                            {% if store.settings.cart.field_company != 'hidden' %}
                                                {{ 'lang.storefront.order.client.company'|t }}: {{ user.company ? user.company : 'n/a' }}
                                            {% endif %}
                                        </p>
                                    </div>
                                </div>

                                <div class="confirm-data margin-top">
                                    <div class="row">
                                        {% if not cart.is_digital %}
                                            <div class="col-sm-6">
                                                <div class="checkout-category margin-bottom-sm">{{ 'lang.storefront.order.delivery.address'|t }}</div>
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
                                        <div class="col-sm-6">
                                            <div class="checkout-category margin-bottom-sm">{{ 'lang.storefront.order.billing.address'|t }}</div>
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
                                    <div class="checkout-category margin-top margin-bottom-sm">{{ 'lang.storefront.order.observations'|t }}</div>
                                    <p>{{ user.observations|nl2br }}</p>
                                {% endif %}

                                {% if user.custom_field %}
                                    {% for custom_fields_key, custom_fields in user.custom_field %}
                                        <div class="well well-default {{ store.theme_options.well_default_shadow }} margin-top margin-bottom-0">
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

                                    {% if cart.discount %}
                                        <div class="basket-total margin-bottom-xs">
                                            <div class="basket-text"><a class="link-inherit" data-toggle="collapse" href="#discount-detail" role="button" aria-expanded="true" aria-controls="discount-detail">{{ 'lang.storefront.order.discount'|t }} {{ icons('angle-down') }}</a></div>
                                            <div class="basket-text">{{ '- ' ~ cart.discount | money_with_sign }}</div>
                                        </div>
                                        <div class="collapse show text-muted" id="discount-detail">
                                            {% if cart.coupon %}
                                                <div class="basket-total {{ cart.rewards ? 'margin-bottom-xxs' }}">
                                                    <div class="basket-text margin-left-xs normal">{{ 'lang.storefront.order.discount.coupon'|t }}</div>
                                                    <div class="basket-text normal">{{ cart.coupon.type == 'shipping' ? 'lang.storefront.cart.order_summary.free_shipping'|t : '- ' ~ cart.coupon.discount | money_with_sign }}</div>
                                                </div>
                                            {% endif %}
                                            {% if cart.rewards %}
                                                <div class="basket-total">
                                                    <div class="basket-text margin-left-xs normal">{{ store.settings.rewards.plural_label ?: 'lang.storefront.account.rewards.plural.label'|t }}</div>
                                                    <div class="basket-text normal">{{ '- ' ~ cart.rewards.discount | money_with_sign }}</div>
                                                </div>
                                            {% endif %}
                                        </div>
                                    {% endif %}

                                    <div class="basket-total margin-top-sm">
                                        <div class="basket-text">{{ 'lang.storefront.cart.order_summary.shipping.title'|t }}</div>
                                        <div class="basket-text">{{ cart.shipping_methods ? (user.shipping_method ? (cart.coupon.type == 'shipping' or cart.total_shipping == 0 ? 'lang.storefront.cart.order_summary.shipping_total.free'|t : cart.total_shipping | money_with_sign) : 'n/a') : cart.total_shipping | money_with_sign }}</div>
                                    </div>

                                    {% if cart.total_payment %}
                                        <div class="basket-total">
                                            <div class="basket-text">{{ 'lang.storefront.cart.order_summary.total_payment'|t }} <span data-toggle="tooltip" data-placement="top" title="{{ user.payment_method.title }}">{{ icons('question-circle') }}</span></div>
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
                                </div>

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

                                <button class="basket-button btn btn-primary {{ store.theme_options.button_primary_shadow }} btn-block">{{ 'lang.storefront.cart.confirm.button'|t }}</button>
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
