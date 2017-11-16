{#
Description: Shopping cart page
#}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb">
		<li><a href="/">Home</a><span class="divider">›</span></li>
		<li class="active">Carrinho de Compras</li>
	</ul>

	<h1>Carrinho de Compras</h1>

	<br>

	{% if cart.items %}

		{% if events.cart.no_stock %}
			<div class="alert">
				<h5>Aviso</h5>
				<p>Os seguintes produtos não foram atualizados por falta de stock:</p>
				<ul>
					{% for key in events.cart.no_stock %}
						<li>{{ cart.items[key].title }}</li>
					{% endfor %}
				</ul>
			</div>
		{% endif %}

		{{ form_open('cart/update') }}

			<div class="table-responsive">
				<table class="table table-bordered table-cart">
					<thead>
						<tr>
							<th>Produto</th>
							<th>Quantidade</th>
							<th class="text-right">Subtotal</th>
							<th class="text-center">Remover</th>
						</tr>
					</thead>

					<tbody>

					{% for item in cart.items %}
						<tr>
							<td>{% if item.image %}<img src="{{ item.image }}" width="22" height="22" class="hidden-phone"> {% endif %}{{ item.title }}</td>
							<td><div class="form-inline"><input class="input-micro" type="number" value="{{ item.qty }}" name="qtd[{{ item.item_id }}]" {% if item.stock_sold_single %} data-toggle="tooltip" data-placement="bottom" data-original-title="Só é possível comprar 1 unidade deste produto." title="Só é possível comprar 1 unidade deste produto." readonly {% endif %}> <button type="submit" class="btn btn-small">Alterar</button></div></td>
							<td class="price text-right">{{ item.subtotal | money_with_sign }}</td>
							<td class="text-center"><a href="{{ item.remove_link }}" class="btn btn-small"><i class="fa fa-trash"></i>&nbsp;<span class="hidden-phone">Remover</span></a></td>
						</tr>
					{% endfor %}

					</tbody>

					<tfoot>
						<tr>
							<td class="subtotal">Subtotal Encomenda</td>
							<td colspan="2" class="subtotal price text-right">{{ cart.subtotal | money_with_sign }}</td>
							<td class="subtotal">&nbsp;</td>
						</tr>
					</tfoot>
				</table>
			</div>

			<p><a class="btn btn-large" href="{{ site_url('cart/data') }}">Prosseguir ›</a></p>

		{{ form_close() }}

	{% else %}

		<div class="alert alert-info">
			Não existem produtos no carrinho.
		</div>

	{% endif %}

{% endblock %}