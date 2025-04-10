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
							<td class="text-right">{{ order.total|money_with_sign(order.currency) }}</td>
							<td class="text-center">{% if order.tracking_url %}<a href="{{ order.tracking_url }}" class="" target="_blank">{{ icons('map-marker') }}</a>{% else %}-{% endif %}</td>
						</tr>
					{% endfor %}
				</tbody>
			</table>
		</div>
	{% else %}
		<p>{{ 'lang.storefront.account.order_data.no_orders'|t }}</p>
	{% endif %}
	<div class="row-fluid">
		<div class="span12">
			<hr>
			{{ pagination("order_data") }}
		</div>
	</div>
{% endmacro %}

{% macro account_navigation() %}
	<ul class="nav">
		<li class="account-heading"><h4><a href="{{ site_url('account') }}" class="link-inherit">{{ 'lang.storefront.account.my_account'|t }}</a></h4></li>
		<li class="{{ current_page == 'account-orders' ? 'active' }}"><a href="{{ site_url('account/orders')}}">{{ icons('shopping-bag') }} {{ 'lang.storefront.layout.orders.title'|t }}</a></li>
		<li class="{{ current_page == 'account-profile' ? 'active' }}"><a href="{{ site_url('account/profile')}}">{{ icons('user') }} {{ 'lang.storefront.layout.client.title'|t }}</a></li>
		<li class="{{ current_page == 'account-wishlist' ? 'active' }}"><a href="{{ site_url('account/wishlist')}}">{{ icons('heart') }} {{ 'lang.storefront.layout.wishlist.title'|t }}</a></li>
		<li><a href="{{ site_url('account/logout')}}">{{ icons('sign-out') }} {{ 'lang.storefront.layout.logout.title'|t }}</a></li>
	</ul>
{% endmacro %}

{% import _self as account_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">
		<div class="row-fluid">

			<div class="span12">

				<p class="breadcrumbs">
					<a href="{{ site_url() }}">{{ icons('home') }}</a> ›
					{{ 'lang.storefront.account.my_account'|t }}
				</p><br>

				<h1>{{ 'lang.storefront.layout.greetings'|t }} <strong>{{ user.name|first_word }}</strong>.</h1>

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
			</div>

		</div>
	</div>
{% endblock %}