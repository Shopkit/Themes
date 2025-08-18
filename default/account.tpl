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
                            <td><a href="{{ site_url('account/orders?id=' ~ order.id)}}" style="text-decoration:underline" class="modal-order-detail"><strong>#{{ order.id }}</strong></a></td>
                            <td>{{ order.created_at|format_datetime('long', 'none') }}</td>
                            <td>{{ order.status_description }}</td>
                            <td class="text-center">{{ order.paid ? icons('check', 'text-success') : icons('times') }}</td>
                            <td class="text-right nowrap">{{ order.total|money_with_sign(order.currency) }}</td>
                            <td class="text-center">{% if order.tracking_url %}<a href="{{ order.tracking_url }}" target="_blank">{{ icons('map-marker') }}</a>{% else %}-{% endif %}</td>
                        </tr>
                    {% endfor %}
                </tbody>
            </table>
        </div>
    {% else %}
        <p>{{ 'lang.storefront.account.order_data.no_orders'|t }}</p>
    {% endif %}

    <hr>
    {{ pagination("order_data") }}

{% endmacro %}

{% import _self as account_macros %}
{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    <ul class="breadcrumb well-default">
        <li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
        <li class="active">{{ 'lang.storefront.account.my_account'|t }}</li>
    </ul>

    <h1>{{ 'lang.storefront.layout.greetings'|t }} <strong>{{ user.name|first_word }}</strong>.</h1>

    <br>

    {% if store.settings.rewards.active and store.settings.rewards.message_account and user.rewards %}
        <div class="alert alert-info">
            <h4><i>{{ icons('trophy') }}</i> {{ rewards_label }}</h4>
            {{ store.settings.rewards.message_account|rewards_message(user.rewards) }}
            {{ store.settings.rewards.message_saved_account and user.rewards_savings > 0 ? '<br>' ~ store.settings.rewards.message_saved_account|rewards_message(user.rewards, user.rewards_savings) : '' }}
        </div>
    {% endif %}

    <h3>{{ 'lang.storefront.account.latest_orders'|t }}</h3>
    {{ account_macros.order_table_list(user.orders[:5]) }}

    <h3>{{ 'lang.storefront.account.my_addresses'|t }}</h3>
    <div class="row-fluid">
        <div class="span6">
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
                <a href="{{ site_url('account/profile') }}">{{ 'lang.storefront.order.edit'|t }}</a>
            </p>
        </div>
        <div class="span6">
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
                <a href="{{ site_url('account/profile') }}">{{ 'lang.storefront.order.edit'|t }}</a>
            </p>
        </div>
    </div>

{% endblock %}