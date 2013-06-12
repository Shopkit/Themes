{# 
Description: Payment Page
#}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb">
		<li><a href="/">Home</a><span class="divider">›</span></li>
		<li><a href="{{ site_url('cart') }}">Carrinho de Compras</a><span class="divider">›</span></li>
		<li class="active">Pagamento</li>
	</ul>
	
	<h1>Pagamento</h1>		
	<br>
	
	{% if errors.form %}
		<div class="alert alert-error">
			<button type="button" class="close" data-dismiss="alert">×</button>
			<h5>Erro</h5>
			<p>{{ errors.form }}</p>
		</div>
	{% endif %}
	
	{% if cart.items %}

	{{ form_open('cart/data', { 'class' : 'form' }) }}

		<table class="table table-bordered table-cart">
			<thead>
				<tr>
					<th>Título</th>
					<th>Quantidade</th>
					<th>Preço Uni.</th>
					<th>SubTotal</th>
				</tr>
			</thead>

			<tbody>

				{% for item in cart.items %} 
					<tr>
						<td><img src="{{ item.image }}" width="22" height="22"> {{ item.title }}</td>
						<td class="text-right">{{ item.qty }}</td>
						<td class="price text-right">{{ item.price | money_with_sign }}</td>
						<td class="price text-right">{{ item.total | money_with_sign }}</td>
					</tr>
				{% endfor %}

			</tbody>

			<tfoot>
				{% if cart.discount %}
					<tr>
						<td class="discount">Desconto</td>
						<td align="right" class="discount price text-right" colspan="4">- {{ cart.discount | money_with_sign }}</td>
					</tr>
				{% endif %}
				<tr>
					<td class="discount">Taxa (<abbr title="Imposto sobre o valor acrescentado">IVA</abbr>)</td>
					<td align="right" class="discount price text-right" colspan="4">{{ cart.taxes | money_with_sign }}</td>
				</tr>

				<tr>
					<td class="discount">Portes de Envio</td>
					<td align="right" class="discount price text-right" colspan="4">{{ cart.total_shipping | money_with_sign }}</td>
				</tr>
				
				<tr>
					<td class="subtotal">Subtotal Encomenda</td>
					<td colspan="4" class="subtotal price text-right">{{ cart.total | money_with_sign }}</td>
				</tr>
			</tfoot>
		</table>

		<hr>

		<h4>Método de Pagamento</h4>
		<br>

		{% if payment.bank_transfer %}
			<label class="radio"><input type="radio" name="pagamento" id="transferencia_bancaria" value="Transferência Bancária" {% if user.payment == 'Transferência Bancária' or user.payment == '' %}checked{% endif %}> Transferência Bancária</label>
		{% endif %}

		{% if payment.multibanco %}
			<label class="radio"><input type="radio" name="pagamento" id="multibanco" value="Multibanco" {% if user.payment == 'Multibanco' or user.payment == '' %}checked{% endif %}> Multibanco</label>
		{% endif %}

		{% if payment.on_delivery %}
			<label class="radio"><input type="radio" name="pagamento" id="cobranca" value="À Cobrança" {% if user.payment == 'À Cobrança' or user.payment == '' %}checked{% endif %}> À Cobrança <small class="muted">(Acresce {{ payment.on_delivery_value | money_with_sign }} aos portes de envio)</small></label>
		{% endif %}

		{% if payment.pick_up %}
			<label class="radio"><input type="radio" name="pagamento" id="levantamento" value="Levantamento nas instalações" {% if (user.payment == 'Levantamento nas instalações' or user.payment == '') %}checked{% endif %}> Levantamento nas instalações <small class="muted">(Os portes de envio são grátis)</small></label>
		{% endif %}

		{% if payment.paypal %}
			<label class="radio"><input type="radio" name="pagamento" id="paypal" value="Paypal" {% if (user.payment == 'Paypal' or user.payment == '') %}checked{% endif %}> Paypal</label>
		{% endif %}

		<hr>

		<h4>Cupão de desconto</h4>
		<br>

		<input type="text" value="{{ user.coupon }}"  class="input-xlarge" id="cupao" name="cupao" placeholder="Se tiver um cupão de desconto, coloque-o aqui">

		<hr>

		<button type="submit" class="btn btn-large">Prosseguir ›</button>

	{{ form_close() }}

	{% else %}

		<div class="alert alert-info">
			Não existem produtos no carrinho.
		</div>

	{% endif %}

{% endblock %}