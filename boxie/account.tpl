{#
Description: User account page
#}

{% macro order_table_list(order_data) %}
    {% if order_data %}
        <div class="table-responsive margin-top-sm">
            <table class="table well-featured table-striped table-hover">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>{{ 'lang.storefront.order.date'|t }}</th>
                        <th>{{ 'lang.storefront.order.status'|t }}</th>
                        <th class="text-center">{{ 'lang.storefront.order.paid'|t }}</th>
                        <th class="text-right">{{ 'lang.storefront.order.total'|t }}</th>
                        <th class="text-center">{{ 'lang.storefront.order.tracking'|t }}</th>
                    </tr>
                </thead>
                <tbody>
                    {% for order in order_data %}
                        <tr>
                            <td><a href="{{ site_url('account/orders?id=' ~ order.id)}}" style="text-decoration:underline" class="modal-order-detail link-inherit"><strong>#{{ order.id }}</strong></a></td>
                            <td>{{ order.created_at|format_datetime('long', 'none') }}</td>
                            <td>{{ order.status_description }}</td>
                            <td class="text-center">{{ order.paid ? icons('check', 'text-success') : icons('times') }}</td>
                            <td class="text-right text-nowrap">{{ order.total|money_with_sign(order.currency) }}</td>
                            <td class="text-center">{% if order.tracking_url %}<a href="{{ order.tracking_url }}" class="link-inherit" target="_blank">{{ icons('map-marker') }}</a>{% else %}-{% endif %}</td>
                        </tr>
                    {% endfor %}
                </tbody>
            </table>
        </div>
    {% else %}
        <p>{{ 'lang.storefront.account.order_data.no_orders'|t }}</p>
    {% endif %}

    <div class="col-12">
        <hr>
        {{ pagination("order_data") }}
    </div>
{% endmacro %}

{% macro account_navigation() %}
    <div class="list-group account-menu well-featured {{ store.theme_options.well_featured_shadow }}">
        <a href="{{ site_url('account/orders')}}" class="list-group-item {{ current_page == 'account-orders' ? 'active' }} link-inherit">{{ icons('shopping-bag') }} {{ 'lang.storefront.layout.orders.title'|t }}</a>
        <a href="{{ site_url('account/profile')}}" class="list-group-item {{ current_page == 'account-profile' ? 'active' }} link-inherit">{{ icons('user') }} {{ 'lang.storefront.layout.client.title'|t }}</a>
        <a href="{{ site_url('account/wishlist')}}" class="list-group-item {{ current_page == 'account-wishlist' ? 'active' }} link-inherit">{{ icons('heart') }} {{ 'lang.storefront.layout.wishlist.title'|t }}</a>
        <a href="{{ site_url('account/logout')}}" class="list-group-item link-inherit">{{ icons('log-out') }} {{ 'lang.storefront.layout.logout.title'|t }}</a>
    </div>
{% endmacro %}

{% import _self as account_macros %}
{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    <div class="account section">
        <div class="{{ layout_container }}">
            <h2 class="account-title title title_mb-lg">{{ 'lang.storefront.account.my_account'|t }}</h2>

            <div class="row">
                <div class="col-lg-3">
                    {{ account_macros.account_navigation() }}
                </div>

                <div class="col-lg-9">
                    <h1 class="margin-top-0 margin-bottom">{{ 'lang.storefront.layout.greetings'|t }} <strong>{{ user.name|first_word }}</strong>.</h1>

                    <h3 class="margin-bottom-xs margin-top-0 text-gray light">{{ 'lang.storefront.account.latest_orders'|t }}</h3>
                    {{ account_macros.order_table_list(user.orders[:5]) }}

                    <h3 class="margin-bottom-xs margin-top text-gray light">{{ 'lang.storefront.account.my_addresses'|t }}</h3>
                    <div class="row">
                        <div class="col-lg-6">
                            <h4>{{ 'lang.storefront.order.delivery.address'|t }}</h4>
                            <p>
                                {% if user.delivery.address %}
                                    {{ user.delivery.name }}<br>
                                    {{ user.delivery.address }} {{ user.delivery.address_extra }}<br>
                                    {{ user.delivery.zip_code }} {{ user.delivery.city }}<br>
                                    {{ user.delivery.country }}<br>
                                {% else %}
                                    {{ 'lang.storefront.order.delivery.no_address'|t }}<br>
                                {% endif %}
                                <a href="{{ site_url('account/profile') }}" class="link-inherit">{{ 'lang.storefront.order.edit'|t }}</a>
                            </p>
                        </div>
                        <div class="col-lg-6 margin-top-visible-sm">
                            <h4>{{ 'lang.storefront.order.billing.address'|t }}</h4>
                            <p>
                                {% if user.billing.address %}
                                    {{ user.billing.name }}<br>
                                    {{ user.billing.address }} {{ user.billing.address_extra }}<br>
                                    {{ user.billing.zip_code }} {{ user.billing.city }}<br>
                                    {{ user.billing.country }}<br>
                                {% else %}
                                    {{ 'lang.storefront.order.billing.no_address'|t }}<br>
                                {% endif %}
                                <a href="{{ site_url('account/profile') }}" class="link-inherit">{{ 'lang.storefront.order.edit'|t }}</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

{% endblock %}