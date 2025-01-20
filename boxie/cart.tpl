{#
Description: Shopping cart page
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
                <li class="breadcrumbs-item">{{ 'lang.storefront.cart.title'|t }}</li>
            </ul>
        </div>
    </div>

    <div class="cart section">
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

            <div class="cart-head">
                <div class="cart-box">
                    <h2 class="cart-title title">{{ 'lang.storefront.cart.title'|t }}</h2>
                </div>
            </div>

            {% if cart.items %}

                {{ form_open('cart/post/data') }}

                    <div class="cart-row">
                        <div class="column">
                            <div class="cart-col">
                                <div class="cart-list">
                                    {% for item in cart.items %}
                                        <div class="cart-item well-featured {{ store.theme_options.well_featured_shadow }}" data-product="{{ item.product_id }}" data-product-option="{{ item.options|keys[0] }}">
                                            <a class="cart-preview" href="{{ item.product_url }}">
                                                <img class="cart-pic lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ item.image }}" alt="{{ item.title|e }}" title="{{ item.title|e }}">
                                            </a>
                                            <div class="cart-details">
                                                <div class="row">
                                                    <div class="cart-details-info margin-bottom-xs">
                                                        <a class="cart-product margin-bottom-0" href="{{ item.product_url }}">{{ item.title }}</a>

                                                        <div class="unit-price text-muted small">{{ 'lang.storefront.cart.product.unit_price.label'|t }} <span class="semi-bold">{{ item.price | money_with_sign }}</span></div>

                                                        {% if item.extras %}
                                                            <div class="items-extra-wrapper">
                                                                <a href="#item-extra-{{ item.item_id }}" class=" margin-top-xxs inline-block small" data-toggle="collapse" href="#item-extra-{{ item.item_id }}">{{ item.extras|length }} {{ item.extras|length > 1 ? 'lang.storefront.product.extra_options.plural.label'|t : 'lang.storefront.product.extra_options.singular.label'|t }} <span class="text-muted">({{ item.subtotal_extras > 0 ? item.subtotal_extras | money_with_sign : 'lang.storefront.cart.order_summary.shipping_total.free'|t }})</span> <i class="fa fa-fw fa-angle-down" aria-hidden="true"></i></a>

                                                                <ul class="list-group extra-options collapse margin-bottom-0 margin-top-xs" id="item-extra-{{ item.item_id }}">
                                                                    {% for key, extra in item.extras %}
                                                                        <li class="list-group-item">
                                                                            <div class="list-group-item-header">
                                                                                <h6 class="margin-0 semi-bold">{{ extra.title }}</h6>
                                                                                <span class="badge badge-transparent normal"><span class="text-muted">{{ extra.qty }}x</span> {{ extra.price ?  extra.price | money_with_sign : 'lang.storefront.cart.order_summary.shipping_total.free'|t }}</span>
                                                                            </div>
                                                                            <div class="text-truncate small margin-top-xxs" style="max-width: 200px; min-width: 100%" data-toggle="tooltip" title="{{ extra.value }}">{{ extra.value }}</div>
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
                                                <div class="row">
                                                    <div class="cart-control">
                                                        <div class="cart-counter counter js-counter">
                                                            <button class="counter-btn counter-btn_minus js-counter-minus" type="button">
                                                                <i data-feather="chevron-left"></i>
                                                            </button>

                                                            <input class="counter-input input-qtd js-counter-input" type="text" value="{{ item.qty }}" size="3" name="qtd[{{ item.item_id }}]" id="qty-{{ item.item_id }}" {% if item.stock_sold_single %} data-toggle="tooltip" data-placement="top" title="{{ 'lang.storefront.cart.product_limit.tooltip'|t }}" readonly {% endif %}>

                                                            <button class="counter-btn counter-btn_plus js-counter-plus" type="button">
                                                                <i data-feather="chevron-right"></i>
                                                            </button>
                                                        </div>

                                                        <a href="{{ item.remove_link }}" class="cart-remove cart-remove-product-url">
                                                            <i data-feather="trash-2"></i>
                                                        </a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    {% endfor %}
                                </div>
                            </div>
                        </div>

                        <div class="column">
                            <div class="cart-col cart-receipt-container">
                                <div class="cart-receipt well-featured {{ store.theme_options.well_featured_shadow }}">
                                    <div class="cart-category">{{ 'lang.storefront.cart.order_summary.title'|t }}</div>
                                    <div class="cart-wrap">
                                        <div class="cart-line">
                                            <div class="cart-text">{{ 'lang.storefront.layout.subtotal.title'|t }}</div>
                                            <div class="cart-text">{{ cart.subtotal | money_with_sign }}</div>
                                        </div>

                                        {% if cart.coupon %}
                                            <div class="cart-line">
                                                <div class="cart-text">{{ 'lang.storefront.order.discount'|t }}</div>
                                                <div class="cart-text price">{{ cart.coupon.type == 'shipping' ? 'lang.storefront.cart.order_summary.free_shipping'|t : '- ' ~ cart.discount | money_with_sign }}</div>
                                            </div>
                                        {% endif %}

                                        <div class="cart-line">
                                            {% set no_shipping_text = 'lang.storefront.cart.order_summary.shipping.calculating.text'|t ~ ' <span data-toggle="tooltip" data-placement="top" title="' ~ 'lang.storefront.cart.order_summary.shipping.calculating.tooltip'|t ~ '"><i class="fa fa-question-circle"></i></span>' %}
                                            <div class="cart-text">{{ 'lang.storefront.cart.order_summary.shipping.title'|t }}</div>
                                            <div class="cart-text total-shipping">{{ cart.shipping_methods ? (user.shipping_method ? (cart.coupon.type == 'shipping' or cart.total_shipping == 0 ? 'lang.storefront.cart.order_summary.shipping_total.free'|t : cart.total_shipping | money_with_sign) : no_shipping_text) : cart.total_shipping | money_with_sign }}</div>
                                        </div>

                                        {% if cart.total_payment %}
                                            <div class="cart-line">
                                                <div class="cart-text">{{ 'lang.storefront.cart.order_summary.total_payment'|t }} <span data-toggle="tooltip" data-placement="top" title="{{ user.payment_method.title }}"><i class="fa fa-question-circle"></i></span></div>
                                                <div class="cart-text">{{ cart.total_payment | money_with_sign }}</div>
                                            </div>
                                        {% endif %}

                                        {% if not store.taxes_included or cart.total_taxes == 0 %}
                                            <div class="cart-line">
                                                <div class="cart-text">{{ user.l10n.tax_name }}</div>
                                                <div class="cart-text">{{ cart.total_taxes | money_with_sign }}</div>
                                            </div>
                                        {% endif %}

                                        <hr>

                                        <div class="cart-line margin-bottom-0">
                                            <div class="cart-text">{{ 'lang.storefront.order.total'|t }}</div>
                                            <div class="cart-text">{{ cart.total | money_with_sign }}</div>
                                        </div>
                                        {% if store.taxes_included and cart.total_taxes > 0 %}
                                            <div class="tax-included text-right small">
                                                <small class="text-muted">{{ 'lang.storefront.cart.order_summary.taxes_included'|t([user.l10n.tax_name, cart.total_taxes|money_with_sign]) }}</small>
                                            </div>
                                        {% endif %}

                                        <hr>

                                        <div class="coupon-code margin-top margin-bottom">
                                            <label for="cupao">{{ 'lang.storefront.cart.order_summary.coupon_code.title'|t }}</label>

                                            <div class="coupon-code-input {{ not cart.coupon ? '' : 'hidden' }}">
                                                <input type="text" value="{{ cart.coupon.code }}" class="form-control" id="cupao" name="cupao" placeholder="{{ 'lang.storefront.cart.order_summary.coupon_code.placeholder'|t }}">
                                                <button type="submit" formaction="{{ site_url('cart/coupon/add') }}" class="cart-btn btn btn-default {{ store.theme_options.button_default_shadow }} link-inherit margin-top-xs">{{ 'lang.storefront.cart.order_summary.coupon_code.button'|t }}</button>
                                            </div>

                                            <div class="coupon-code-label margin-top-xxs {{ cart.coupon ? cart.coupon.code : 'hidden' }}">
                                                <span class="badge badge-light-bg h5">
                                                    <i class="fa fa-tags fa-fw" aria-hidden="true"></i>
                                                    <span class="coupon-code-text">{{ cart.coupon.code }}</span>
                                                    <a href="{{ site_url('cart/coupon/remove') }}" class="btn-close"><i class="fa fa-times fa-fw" aria-hidden="true"></i></a>
                                                </span>
                                            </div>
                                        </div>

                                        <hr>

                                    </div>

                                    <button type="submit" formaction="{{ site_url('cart/post/update') }}" class="cart-btn btn btn-default {{ store.theme_options.button_default_shadow }} link-inherit margin-right-xs">{{ 'lang.storefront.cart.update.button'|t }}</button>
                                    <button type="submit" formaction="{{ site_url('cart/post/data') }}" class="cart-btn btn btn-primary {{ store.theme_options.button_primary_shadow }}">{{ 'lang.storefront.cart.checkout.title'|t }}</button>
                                </div>

                                <div id="payment-method-messaging-element"></div>
                            </div>

                            <div class="cart-col margin-top">
                                <div class="well well-default {{ store.theme_options.well_default_shadow }} text-center">
                                    <h3 class="cart-category margin-bottom-md">{{ 'lang.storefront.cart.questions.title'|t }}</h3>
                                    <p class="">{{ 'lang.storefront.cart.questions.text'|t([site_url('contact')]) }}</p>
                                </div>
                            </div>
                        </div>

                    </div>

                {{ form_close() }}

                {% if store.settings.cart.related_products_intelligent %}
                    <div class="related-products margin-top-lg hidden" data-load="related-products" data-href="{{ site_url('related-products') }}" data-products="{{ cart.items|column('product_id')|json_encode }}" data-num-products="6" data-products-per-row="3" data-css-class-wrapper="cart-related-products products-list" data-type="intelligent">
                        <h2 class="products-title title title_mb-lg">{{ 'lang.storefront.cart.related_products.title'|t }}</h2>
                        <div class="slider-container">
                            <div class="related-products-placement product-list-no-hover"></div>
                        </div>
                    </div>
                {% endif %}

            {% else %}

                <div class="cart-row">
                    <div class="cart-col">
                        <div class="cart-no-products">
                            <div class="cart-text">
                                <h3>{{ 'lang.storefront.cart.no_products'|t }}</h3>
                                <p>{{ 'lang.storefront.cart.no_products.discover'|t([site_url('new'), site_url('sales')]) }}</p>
                            </div>
                        </div>
                    </div>
                </div>

            {% endif %}

        </div>
    </div>

{% endblock %}
