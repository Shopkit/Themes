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
			{{ errors.form }}
		</div>
	{% endif %}

	{% if cart.items %}

		{{ form_open('cart/post/confirm', { 'class' : 'form' }) }}

			{% if cart.shipping_methods %}

				<div class="shipping-methods">
					<h4>Transporte <small>({{ user.delivery.country }})</small></h4>
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

			{% if cart.payments %}
				<div class="payment-methods">
					<h4>Pagamento</h4>
					<br>

					{% for payment in cart.payments %}
						{% if payment.active %}

							{% if user.payment %}
								{% set active = user.payment == payment.title ? true : false %}
							{% else %}
								{% set active = payment.default ? true : false %}
							{% endif %}

							<label class="radio"><input type="radio" name="pagamento" id="{{ payment.alias }}" value="{{ payment.title }}" {% if active %}checked{% endif %}> {{ payment.title }}
								{% if payment.value > 0 %}
									<small class="muted">(Acresce <strong>{{ payment.value | money_with_sign }}</strong> aos portes de envio)</small>
								{% endif %}
								{% if (payment.alias == 'pick_up')  %}
									<small class="muted">(Os portes de envio são <strong>grátis</strong>)</small>
								{% endif %}
							</label>

						{% endif %}
					{% endfor %}

				</div>
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