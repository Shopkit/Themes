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

	<div class="span12">
		<hr>
		{{ pagination("order_data") }}
	</div>
{% endmacro %}

{% macro account_navigation() %}
	<div class="list-group">
		<a href="{{ site_url('account/orders')}}" class="list-group-item {{ current_page == 'account-orders' ? 'active' }}"><i class="fa fa-fw fa-shopping-bag" aria-hidden="true"></i> Encomendas</a>
		<a href="{{ site_url('account/profile')}}" class="list-group-item {{ current_page == 'account-profile' ? 'active' }}"><i class="fa fa-fw fa-user" aria-hidden="true"></i> Dados de cliente</a>
		<a href="{{ site_url('account/wishlist')}}" class="list-group-item {{ current_page == 'account-wishlist' ? 'active' }}"><i class="fa fa-fw fa-heart" aria-hidden="true"></i> Wishlist</a>
		<a href="{{ site_url('account/logout')}}" class="list-group-item"><i class="fa fa-fw fa-sign-out" aria-hidden="true"></i> Sair</a>
	</div>
{% endmacro %}

{% import _self as account_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="container">
		<div class="row">
			<div class="col-sm-3">
				<div class="panel panel-default margin-bottom">
					<div class="panel-heading">
						<a href="{{ site_url('account') }}" class="link-inherit">A minha conta</a>
					</div>

					{{ account_macros.account_navigation() }}

				</div>
			</div>

			<div class="col-sm-8 col-sm-offset-1">
				<h1 class="margin-top-0 margin-bottom">Olá <strong>{{ user.name|first_word }}</strong>.</h1>

				<h3 class="margin-bottom-xs margin-top-0 text-gray light">Últimas encomendas</h3>
				{{ account_macros.order_table_list(user.orders[:5]) }}

				<h3 class="margin-bottom-xs margin-top text-gray light">Os meus endereços</h3>
				<div class="row">
					<div class="col-sm-6">
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
					<div class="col-sm-6">
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