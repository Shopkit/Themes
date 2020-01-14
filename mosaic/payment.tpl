{#
Description: Shopping cart page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">

		<section class="page">

			<p class="breadcrumbs">
				<a href="{{ site_url() }}"><i class="fa fa-home"></i></a> ›
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
					{{ errors.form }}
				</div>
			{% endif %}

			{% if cart.items %}

			{{ form_open('cart/post/confirm', { 'class' : 'form', 'id' : 'form-payment' }) }}

				{% if cart.shipping_methods %}

					<div class="shipping-methods">
						<h4>Transporte <small>({{ user.delivery.country }})</small></h4>
						<br>
						<ul class="list-group">

							{% for method in cart.shipping_methods %}
								<li class="list-group-item list-radio-block {% if user.shipping_method.id == method.id or (loop.index == 1 and not user.shipping_method.id) %}list-group-item-active{% endif %}">
									<label for="shipping_method_{{ method.id }}">
										<div class="list-radio-content">
											<div class="list-radio-input">
												<input type="radio" name="envio" id="shipping_method_{{ method.id }}" value="{{ method.id }}" {% if loop.index == 1 or user.shipping_method.id == method.id %}checked{% endif %}>
											</div>
											<div class="list-radio-description">
												<div class="shipping-method">
													<h4>{{ method.title }}</h4>
													{% if method.description %}
														<p>{{ method.description }}</p>
													{% endif %}
												</div>
											</div>
											<div class="list-radio-price">
												<div class="price">{{ method.price == 0 ? 'Grátis' : method.price|money_with_sign }}</div>
											</div>
										</div>
									</label>
								</li>
							{% endfor %}

						</ul>
					</div>

				{% endif %}

				{% if cart.payments %}
					<div class="payment-methods">
						<h4>Pagamento</h4>
						<br>
						<ul class="list-group">

							{% for payment in cart.payments %}
								{% if payment.active %}

									{% if user.payment_method %}
										{% set active = user.payment_method.alias == payment.alias ? true : false %}
									{% else %}
										{% set active = payment.default ? true : false %}
									{% endif %}

									<li class="list-group-item list-radio-block payment-method-{{ payment.alias }} {% if active %}list-group-item-active{% endif %}">
										<label for="{{ payment.alias }}">
											<div class="list-radio-content">
												<div class="list-radio-input">
													<input type="radio" name="pagamento" id="{{ payment.alias }}" value="{{ payment.alias }}" {% if active %}checked{% endif %}>
												</div>
												<div class="list-radio-description">
													<div class="shipping-method">
														<h4>{{ payment.title }}</h4>
														<p>{{ payment.description }}</p>
													</div>
												</div>
												<div class="clearfix visible-phone"></div>
												<div class="list-radio-logo">
													{% if payment.logo %}
														<img src="{{ payment.logo }}" alt="{{ payment.title }}" title="{{ payment.title }}" height="25">
													{% endif %}
												</div>
											</div>
										</label>
										{% if payment.alias == 'credit_card' %}
											<div id="card-element"></div>
										{% endif %}

										{% if payment.alias == 'pick_up' and store.locations %}
											<div id="pickup-locations" class="well">
												<div class="form-group">
													<label for="pick_up_location">Localizações</label>
													<select name="pick_up_location" id="pick_up_location" class="form-control input-block-level">
														<option value="" disabled {% if not user.pick_up_location %}selected{% endif %}>Selecione uma opção</option>

														{% for location in store.locations %}
															{% set selected = false %}

															{% if user.pick_up_location %}
																{% set selected = user.pick_up_location.id == location.id ? true : false %}
															{% endif %}

															<option value="{{ location.id }}" {% if selected %}selected{% endif %}>{{ location.name }} - {{ location.city }}, {{ location.country }}</option>
														{% endfor %}
													</select>
												</div>
											</div>
										{% endif %}
									</li>

								{% endif %}
							{% endfor %}

						</ul>
					</div>
				{% endif %}

				<hr>

				<h4>Cupão de desconto</h4>
				<br>

				<input type="text" value="{{ user.coupon }}" class="span4" id="cupao" name="cupao" placeholder="Se tiver um cupão de desconto, coloque-o aqui">

				<hr>

				<button type="submit" class="button" style="width:175px">
					<span>Prosseguir</span>
					<i class="fa fa-chevron-right"></i>
				</button>

			{{ form_close() }}

		{% else %}

			<p>Não existem produtos no carrinho.</p>

		{% endif %}

		</section>

	</div>

{% endblock %}