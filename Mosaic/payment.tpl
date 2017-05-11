{#
Description: Shopping cart page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">

		<section class="page">

			<p class="breadcrumbs">
				<a href="/"><i class="fa fa-home"></i></a> ›
				<a href="{{ site_url('cart') }}">Carrinho de Compras</a> › 
				<a href="{{ site_url('cart/data') }}">Dados de Envio</a> › 
				Pagamento e Transporte
			</p><br>

			<h1>Pagamento e Transporte</h1>

			<hr>

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

				<input type="text" value="{{ user.coupon }}" class="span4" id="cupao" name="cupao" placeholder="Se tiver um cupão de desconto, coloque-o aqui">

				<hr>

				<button type="submit" class="button" style="width:175px">
					<span>Rever Encomenda</span>
					<i class="fa fa-chevron-right"></i>
				</button>

			{{ form_close() }}

		{% else %}

			<p>Não existem produtos no carrinho.</p>

		{% endif %}

		</section>

	</div>

{% endblock %}