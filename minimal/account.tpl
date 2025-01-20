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
							<td class="text-center">{{ order.paid ? '<i class="fa fa-fw fa-check text-success" aria-hidden="true"></i>' : '<i class="fa fa-fw fa-times" aria-hidden="true"></i>' }}</td>
							<td class="text-right">{{ order.total|money_with_sign(order.currency) }}</td>
							<td class="text-center">{% if order.tracking_url %}<a href="{{ order.tracking_url }}" class="" target="_blank"><i class="fa fa-map-marker" aria-hidden="true"></i></a>{% else %}-{% endif %}</td>
						</tr>
					{% endfor %}
				</tbody>
			</table>
		</div>
	{% else %}
		<p>{{ 'lang.storefront.account.order_data.no_orders'|t }}</p>
	{% endif %}

	<div class="span12">
		<hr>
		{{ pagination("order_data") }}
	</div>
{% endmacro %}

{% macro account_navigation() %}
	<div class="list-group">
		<a href="{{ site_url('account/orders')}}" class="list-group-item {{ current_page == 'account-orders' ? 'active' }}"><i class="fa fa-fw fa-shopping-bag" aria-hidden="true"></i> {{ 'lang.storefront.layout.orders.title'|t }}</a>
		<a href="{{ site_url('account/profile')}}" class="list-group-item {{ current_page == 'account-profile' ? 'active' }}"><i class="fa fa-fw fa-user" aria-hidden="true"></i> {{ 'lang.storefront.layout.client.title'|t }}</a>
		<a href="{{ site_url('account/wishlist')}}" class="list-group-item {{ current_page == 'account-wishlist' ? 'active' }}"><i class="fa fa-fw fa-heart" aria-hidden="true"></i> {{ 'lang.storefront.layout.wishlist.title'|t }}</a>
		<a href="{{ site_url('account/logout')}}" class="list-group-item"><i class="fa fa-fw fa-sign-out" aria-hidden="true"></i> {{ 'lang.storefront.layout.logout.title'|t }}</a>
	</div>
{% endmacro %}

{% import _self as account_macros %}
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

				<h3 class="margin-bottom-xs margin-top-0 text-muted-dark light">{{ 'lang.storefront.account.latest_orders'|t }}</h3>
				{{ account_macros.order_table_list(user.orders[:5]) }}

				<h3 class="margin-bottom-xs margin-top text-muted-dark light">{{ 'lang.storefront.account.my_addresses'|t }}</h3>
				<div class="row">
					<div class="col-sm-6">
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
					<div class="col-sm-6">
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