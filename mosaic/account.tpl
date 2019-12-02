{#
Description: User account page
#}

{% macro order_table_list(order_data) %}
	{% if order_data %}
		<div class="table-responsive">
			<table class="table table-striped table-hover margin-top-sm">
				<thead>
					<tr>
						<th>#</th>
						<th>Data</th>
						<th>Estado</th>
						<th class="text-center">Pago</th>
						<th class="text-right">Total</th>
						<th class="text-center">Tracking</th>
					</tr>
				</thead>
				<tbody>
					{% for order in order_data %}
						<tr>
							<td><a href="{{ site_url('account/orders?id=' ~ order.id)}}" style="text-decoration:underline" class="modal-order-detail"><strong>#{{ order.id }}</strong></a></td>
							<td>{{ order.created_at|date("j F Y") }}</td>
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
		<p>Não existem encomendas</p>
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
		<li class="account-heading"><h4><a href="{{ site_url('account') }}" class="link-inherit">A minha conta</a></h4></li>
		<li class="{{ current_page == 'account-orders' ? 'active' }}"><a href="{{ site_url('account/orders')}}"><i class="fa fa-fw fa-shopping-bag" aria-hidden="true"></i> Encomendas</a></li>
		<li class="{{ current_page == 'account-profile' ? 'active' }}"><a href="{{ site_url('account/profile')}}"><i class="fa fa-fw fa-user" aria-hidden="true"></i> Dados de cliente</a></li>
		<li class="{{ current_page == 'account-wishlist' ? 'active' }}"><a href="{{ site_url('account/wishlist')}}"><i class="fa fa-fw fa-heart" aria-hidden="true"></i> Wishlist</a></li>
		<li><a href="{{ site_url('account/logout')}}"><i class="fa fa-fw fa-sign-out" aria-hidden="true"></i> Sair</a></li>
	</ul>
{% endmacro %}

{% import _self as account_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">
		<div class="row-fluid">

			<div class="span12">

				<p class="breadcrumbs">
					<a href="{{ site_url() }}"><i class="fa fa-home"></i></a> ›
					A minha conta
				</p><br>

				<h1>Olá <strong>{{ user.name|first_word }}</strong>.</h1>

				<h3>Últimas encomendas</h3>
				{{ account_macros.order_table_list(user.orders[:5]) }}

				<h3>Os meus endereços</h3>
				<div class="row-fluid">
					<div class="span6">
						<h4>Morada de envio</h4>
						<p>
							{% if user.delivery.address %}
								{{ user.delivery.name }}<br>
								{{ user.delivery.address }} {{ user.delivery.address_extra }}<br>
								{{ user.delivery.zip_code }} {{ user.delivery.city }}<br>
								{{ user.delivery.country }}<br>
							{% else %}
								Não tem nenhuma morada de envio definida.<br>
							{% endif %}
							<a href="{{ site_url('account/profile') }}">Editar</a>
						</p>
					</div>
					<div class="span6">
						<h4>Morada de facturação</h4>
						<p>
							{% if user.billing.address %}
								{{ user.billing.name }}<br>
								{{ user.billing.address }} {{ user.billing.address_extra }}<br>
								{{ user.billing.zip_code }} {{ user.billing.city }}<br>
								{{ user.billing.country }}<br>
							{% else %}
								Não tem nenhuma morada de facturação definida.<br>
							{% endif %}
							<a href="{{ site_url('account/profile') }}">Editar</a>
						</p>
					</div>
				</div>
			</div>

		</div>
	</div>
{% endblock %}