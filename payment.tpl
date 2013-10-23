{# 
Description: Payment Page
#}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb">
		<li><a href="/">Home</a><span class="divider">›</span></li>
		<li><a href="{{ site_url('cart') }}">Carrinho de Compras</a><span class="divider">›</span></li>
		<li><a href="{{ site_url('cart/data') }}">Dados de Envio</a><span class="divider">›</span></li>
		<li class="active">Pagamento e Transporte</li>
	</ul>
	
	<h1>Pagamento e Transporte</h1>		
	<br>

	{% if cart.free_shipping == true %}
		<div class="alert alert-info">
			<h5>Informação</h5>
			<p>Os portes de envio para esta encomenda são grátis.</p>
		</div>
	{% endif %}

	
	
	{% if errors.form %}
		<div class="alert alert-error">
			<button type="button" class="close" data-dismiss="alert">×</button>
			<h5>Erro</h5>
			<p>{{ errors.form }}</p>
		</div>
	{% endif %}
	
	{% if cart.items %}

		{{ form_open('cart/post/confirm', { 'class' : 'form' }) }}

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
					<tr>
						<td class="subtotal">Subtotal Encomenda</td>
						<td colspan="4" class="subtotal price text-right">{{ cart.subtotal | money_with_sign }}</td>
					</tr>
				</tfoot>
			</table> 

			<br>

			{% if cart.shipping_methods %}
				
				<div class="shipping-methods">
					<h4>Transporte <small>({{ user.country }})</small></h4>
					<br>
					
					{% for method in cart.shipping_methods %} 
						<label class="radio clearfix" style="margin-bottom:10px;">
							<div class="pull-left">
								<input type="radio" name="envio" id="envio_{{ method.id }}" value="{{ method.id }}" {% if loop.index == 1 or user.shipping_method.id == method.id %}checked{% endif %}> 
							</div>
							<div class="pull-left">
								{{ method.title }} &ndash; 
								
								{% if cart.free_shipping == true %}
									<strong class="price"><del>{{ method.price | money_with_sign }}</del></strong> &nbsp; <strong class="price">{{ 0 | money_with_sign }}</strong>
								{% else %}
									<strong class="price">{{ method.price | money_with_sign }}</strong>
								{% endif %}

								<br><small class="muted"><em>{{ method.description }}</em></small>
							</div>
						</label>
					{% endfor %}
					
					<hr>
				</div>

			{% endif %}

			<h4>Pagamento</h4>
			<br>

			{% if payment.paypal %}
				<label class="radio"><input type="radio" name="pagamento" id="paypal" value="Paypal" {% if (user.payment == 'Paypal' or user.payment == '') %}checked{% endif %}> Paypal</label>
			{% endif %}

			{% if payment.pick_up %}
				<label class="radio"><input type="radio" name="pagamento" id="levantamento" value="Levantamento nas instalações" {% if (user.payment == 'Levantamento nas instalações' or user.payment == '') %}checked{% endif %}> Levantamento nas instalações <small class="muted">(Os portes de envio são <strong>grátis</strong>)</small></label>
			{% endif %}

			{% if payment.on_delivery %}
				<label class="radio"><input type="radio" name="pagamento" id="cobranca" value="À Cobrança" {% if user.payment == 'À Cobrança' or user.payment == '' %}checked{% endif %}> À Cobrança 
					{% if payment.on_delivery_value > 0 %}
						<small class="muted">(Acresce <strong>{{ payment.on_delivery_value | money_with_sign }}</strong> aos portes de envio)</small>
					{% endif %}
				</label>
			{% endif %}

			{% if payment.bank_transfer %}
				<label class="radio"><input type="radio" name="pagamento" id="transferencia_bancaria" value="Transferência Bancária" {% if user.payment == 'Transferência Bancária' or user.payment == '' %}checked{% endif %}> Transferência Bancária</label>
			{% endif %}

			{% if payment.multibanco %}
				<label class="radio"><input type="radio" name="pagamento" id="multibanco" value="Multibanco" {% if user.payment == 'Multibanco' or user.payment == '' %}checked{% endif %}> Multibanco</label>
			{% endif %}

			<hr>

			<h4>Cupão de desconto</h4>
			<br>

			<input type="text" value="{{ user.coupon }}"  class="input-xlarge" id="cupao" name="cupao" placeholder="Se tiver um cupão de desconto, coloque-o aqui">

			<hr>

			<button type="submit" class="btn btn-large">Rever Encomenda ›</button>

		{{ form_close() }}

	{% else %}

		<div class="alert alert-info">
			Não existem produtos no carrinho.
		</div>

	{% endif %}

{% endblock %}