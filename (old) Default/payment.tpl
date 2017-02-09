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

	{% if errors.form %}
		<div class="alert alert-error">
			<button type="button" class="close" data-dismiss="alert">×</button>
			<h5>Erro</h5>
			<p>{{ errors.form }}</p>
		</div>
	{% endif %}

	{% if cart.items %}

		{{ form_open('cart/post/confirm', { 'class' : 'form' }) }}

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
								<strong class="price">{{ method.price | money_with_sign }}</strong>
								<br><small class="muted"><em>{{ method.description }}</em></small>
							</div>
						</label>
					{% endfor %}

					<hr>
				</div>

			{% endif %}

			<div class="payment-methods">
				<h4>Pagamento</h4>
				<br>

				{% if cart.payments.multibanco.active %}
					<label class="radio"><input type="radio" name="pagamento" id="multibanco" value="Multibanco" {% if cart.payments.multibanco.default or user.payment == 'Multibanco' %}checked{% endif %}> Multibanco</label>
				{% endif %}

				{% if cart.payments.paypal.active %}
					<label class="radio"><input type="radio" name="pagamento" id="paypal" value="Paypal" {% if cart.payments.paypal.default or user.payment == 'Paypal' %}checked{% endif %}> Paypal</label>
				{% endif %}

				{% if cart.payments.bank_transfer.active %}
					<label class="radio"><input type="radio" name="pagamento" id="transferencia_bancaria" value="Transferência Bancária" {% if cart.payments.bank_transfer.default or user.payment == 'Transferência Bancária' %}checked{% endif %}> Transferência Bancária</label>
				{% endif %}

				{% if cart.payments.pick_up.active %}
					<label class="radio"><input type="radio" name="pagamento" id="levantamento" value="Levantamento nas instalações" {% if cart.payments.pick_up.default or user.payment == 'Levantamento nas instalações' %}checked{% endif %}> Levantamento nas instalações <small class="muted">(Os portes de envio são <strong>grátis</strong>)</small></label>
				{% endif %}

				{% if cart.payments.on_delivery.active %}
					<label class="radio"><input type="radio" name="pagamento" id="cobranca" value="À Cobrança" {% if cart.payments.on_delivery.default or user.payment == 'À Cobrança' %}checked{% endif %}> À Cobrança
						{% if cart.payments.on_delivery.value > 0 %}
							<small class="muted">(Acresce <strong>{{ cart.payments.on_delivery.value | money_with_sign }}</strong> aos portes de envio)</small>
						{% endif %}
					</label>
				{% endif %}
			</div>

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