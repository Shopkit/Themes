{#
Description: Payment Page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="container">

		<h1 class="margin-bottom">Pagamento e Transporte</h1>

		<ol class="breadcrumb margin-bottom hidden-xs">
			<li><a href="/">Home</a></li>
			<li><a href="{{ site_url('cart') }}">Carrinho de Compras</a></li>
			<li><a href="{{ site_url('cart/data') }}">Dados de Envio</a></li>
			<li class="active">Pagamento e Transporte</li>
		</ol>

		{% if errors.form %}
			<div class="callout callout-danger">
				<h4>Erro</h4>
				<p>{{ errors.form }}</p>
			</div>
		{% endif %}

		{% if cart.items %}
			{{ form_open('cart/post/confirm', { 'role' : 'form' }) }}

				<div class="row">
					<div class="col-md-8 col-lg-8">

						{% if cart.shipping_methods %}
							<div class="shipping-methods">
								<h3 class="margin-top-0">Transporte</h3>
								<p class="margin-bottom text-light-gray">{{ user.delivery.country }}</p>

								<div class="row">

									{% for method in cart.shipping_methods %}
										<div class="col-sm-6">
											<div class="wrapper-radio-block">
												<div class="well radio-block {% if user.shipping_method.id == method.id or (loop.index == 1 and not user.shipping_method.id) %}active{% endif %}">

													<div class="content">
														<div class="input">
															<input type="radio" name="envio" id="envio_{{ method.id }}" value="{{ method.id }}" {% if loop.index == 1 or user.shipping_method.id == method.id %}checked{% endif %}>
														</div>

														<div class="inner-content">
															<div class="shipping-method">

																<h4><label for="envio_{{ method.id }}">{{ method.title }}</label></h4> <span class="text-light-gray">&mdash;</span>

																<div class="price">
																	{{ method.price | money_with_sign }}
																</div>

																{% if method.description %}
																	<p>{{ method.description }}</p>
																{% endif %}

															</div>
														</div>
													</div>

												</div>
											</div>
										</div>
										{% if loop.index0 % 2 == 1 %}
											<div class="clearfix hidden-xs"></div>
										{% endif %}
									{% endfor %}

								</div>
							</div>
						{% endif %}

						{% if cart.payments %}
							<h3 class="margin-bottom">Pagamento</h3>

							<div class="payment-methods">
								<div class="row">

									{% for payment in cart.payments %}
										{% if payment.active %}

	                                        {% if user.payment %}
	                                            {% set active = user.payment == payment.title ? true : false %}
	                                        {% else %}
	                                            {% set active = payment.default ? true : false %}
	                                        {% endif %}

											<div class="col-sm-4 col-md-6 col-lg-4">
												<div class="wrapper-radio-block">
													<div class="well radio-block {% if active %}active{% endif %}">
														<div class="content">
															<div class="input">
																<input type="radio" name="pagamento" id="{{ payment.alias }}" value="{{ payment.title }}" {% if active %}checked{% endif %}>
															</div>
															<div class="inner-content">
																<div class="{{ payment.alias }} payment-type">
																	{% if payment.alias == 'multibanco' %}
																		<p><img src="/templates/assets/common/icons/payments/multibanco-color.png" height="45" alt="{{ payment.title }}" title="{{ payment.title }}"></p>
																	{% elseif payment.alias == 'paypal' %}
																		<img src="/templates/assets/common/icons/payments/paypal-color.png" height="35" alt="{{ payment.title }}" title="{{ payment.title }}">
																		<p><img src="/templates/assets/common/icons/payments/paypal-financial-color.png" height="15" alt="Cartões de crédito aceites" title="Visa, Mastercard, American Express"></p>
																	{% elseif payment.alias == 'bank_transfer' %}
																		<h4><label for="{{ payment.alias }}">Transferência</label></h4>
																		<p>Transferência bancária ou interbancária.</p>
																	{% elseif payment.alias == 'pick_up' %}
																		<h4><label for="{{ payment.alias }}">Instalações</label></h4>
																		<p>Levantamento nas instalações. Portes grátis.</p>
																	{% elseif payment.alias == 'on_delivery' %}
																		<h4><label for="{{ payment.alias }}">À Cobrança</label></h4>
																		<p>{% if payment.value > 0 %}
																				Acresce {{ payment.value | money_with_sign }} aos portes de envio
																			{% else %}
																				Envio e pagamento contra reembolso.
																			{% endif %}
																		</p>
																	{% endif %}
																</div>
															</div>
														</div>
													</div>
												</div>
											</div>

										{% endif %}
									{% endfor %}

								</div>
							</div>
						{% endif %}

						<hr>

						<div class="row">
							<div class="col-sm-6">
								<div class="margin-top">
									<label for="cupao">Cupão de desconto</label>
									<input type="text" value="{{ user.coupon }}"  class="form-control" id="cupao" name="cupao" placeholder="Se tiver um cupão de desconto, coloque-o aqui">
								</div>
							</div>
						</div>

						<footer class="clearfix">
							<div class="pull-left steps hidden-xs">
								Passo 2 de 3
							</div>
							<div class="pull-right">
								<small class="text-gray"><a href="{{ site_url('cart') }}">Editar carrinho</a> &nbsp; &bull; &nbsp; </small> <button class="btn btn-primary">Prosseguir <i class="fa fa-fw fa-arrow-right"></i></button>
							</div>
						</footer>

					</div>

					<div class="col-md-4 col-md-offset-0 col-lg-3 col-lg-offset-1 hidden-xs hidden-sm">
						<div class="well">
							<h3 class="margin-bottom-sm bordered">Resumo</h3>
							<dl class="dl-horizontal text-left">
								{% for item in cart.items %}
									<dt title="{{ item.title }}"><small class="normal text-gray">{{ item.qty }}x</small> &nbsp;{{ item.title }}</dt>
									<dd class="text-dark price">{{ item.subtotal | money_with_sign }}</dd>
								{% endfor %}
							</dl>

							<hr>

							<dl class="dl-horizontal text-left h4 margin-bottom-0">
								<dt>Subtotal:</dt>
								<dd class="text-dark bold price">{{ cart.subtotal | money_with_sign }}</dd>
							</dl>
						</div>

					</div>

				</div>

			{{ form_close() }}

		{% else %}
			<p class="h2 light text-light-grey margin-top-lg">Não existem produtos no carrinho</p>
		{% endif %}

	</div>

{% endblock %}