{#
Description: Payment Page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="container">

		<h1 class="margin-bottom">Pagamento e Transporte</h1>

		<ol class="breadcrumb margin-bottom hidden-xs">
			<li><a href="{{ site_url() }}">Home</a></li>
			<li><a href="{{ site_url('cart') }}">Carrinho de Compras</a></li>
			<li><a href="{{ site_url('cart/data') }}">Dados de Envio</a></li>
			<li class="active">Pagamento e Transporte</li>
		</ol>

		{% if errors.form %}
			<div class="callout callout-danger">
				<h4>Erro</h4>
				{{ errors.form }}
			</div>
		{% endif %}

		{% if warnings.form %}
			<div class="callout callout-warning">
				<h4>Aviso</h4>
				{{ warnings.form }}
			</div>
		{% endif %}

		{% if success.form %}
			<div class="callout callout-success">
				<h4>Sucesso</h4>
				{{ success.form }}
			</div>
		{% endif %}

		{% if cart.items %}
			{{ form_open('cart/post/confirm', { 'class' : 'form', 'id' : 'form-payment' }) }}

				<div class="row">
					<div class="col-md-8 col-lg-8">

						{% if cart.shipping_methods %}
							<div class="shipping-methods">
								<h3 class="margin-top-0">Transporte</h3>
								<p class="margin-bottom text-light-gray">{{ user.delivery.country }}</p>

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
														<div class="price">{{ method.price == 0 or cart.coupon.type == 'shipping' ? 'Grátis' : method.price|money_with_sign }}</div>
													</div>
												</div>
											</label>
										</li>
									{% endfor %}
								</ul>
							</div>
						{% endif %}

						{% if cart.payments %}
							<h3 class="margin-bottom">Pagamento</h3>

							<div class="payment-methods">
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
														<div class="clearfix visible-xs-block"></div>
														<div class="list-radio-logo">
															{% if payment.logo %}
																<img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ payment.logo }}" alt="{{ payment.title }}" title="{{ payment.title }}" height="25" class="lazy">
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

					</div>

					<div class="col-md-4 col-md-offset-0 col-lg-3 col-lg-offset-1">
						<div class="order-resume well margin-bottom-0">
							<h3 class="margin-bottom-sm margin-top-0 bordered">Resumo</h3>

							<dl class="dl-horizontal text-left margin-bottom-0">
								<dt class="bold">Subtotal:</dt>
								<dd class="text-dark price">{{ cart.subtotal | money_with_sign }}</dd>

								{% if cart.coupon %}
									<dt>Desconto</dt>
									<dd class="text-dark price">{{ cart.coupon.type == 'shipping' ? 'Envio gratuito' : '- ' ~ cart.discount | money_with_sign }}</dd>
								{% endif %}

								<dt>Portes de envio</dt>
								<dd class="text-dark price">{{ cart.shipping_methods ? (user.shipping_method ? (cart.coupon.type == 'shipping' or cart.total_shipping == 0 ? 'Grátis' : cart.total_shipping | money_with_sign) : 'n/a') : cart.total_shipping | money_with_sign }}</dd>

								{% if not store.taxes_included or cart.total_taxes == 0 %}
									<dt>{{ user.l10n.tax_name }}</dt>
									<dd class="text-dark price">{{ cart.total_taxes | money_with_sign }}</dd>
								{% endif %}
							</dl>

							<hr>

							<dl class="dl-horizontal text-left h3 margin-bottom-0">
                                <dt>Total</dt>
                                <dd class="bold price">{{ cart.total | money_with_sign }}</dd>
                            </dl>

                            {% if store.taxes_included and cart.total_taxes > 0 %}
                                <div class="text-right text-left-xs">
                                    <small class="text-muted">Inclui {{ user.l10n.tax_name }} a {{ cart.total_taxes | money_with_sign }}</small>
                                </div>
                            {% endif %}

							{% if cart.coupon %}
								<hr>

								<div class="coupon-code">
									<label for="cupao">Cupão de desconto</label>
									<div class="coupon-code-label margin-top-xxs">
										<span class="label label-light-bg h5">
											<i class="fa fa-tags fa-fw" aria-hidden="true"></i>
											<span class="coupon-code-text">{{ cart.coupon.code }}</span>
											<a href="{{ site_url('cart/coupon/remove') }}" class="btn-close"><i class="fa fa-times fa-fw" aria-hidden="true"></i></a>
										</span>
									</div>
								</div>
							{% endif %}

							<button class="btn btn-lg btn-primary btn-block margin-top hidden-xs hidden-sm">Prosseguir <i class="fa fa-fw fa-arrow-right"></i></button>
						</div>

					</div>

				</div>

				<div class="row">
					<div class="col-md-8 col-lg-8">
						<footer class="clearfix">
							<div class="pull-left steps hidden-xs">
								Passo 2 de 3
							</div>
							<div class="pull-right">
								<small class="text-gray"><a href="{{ site_url('cart') }}">Editar carrinho</a> &nbsp; &bull; &nbsp; </small> <button class="btn btn-primary">Prosseguir <i class="fa fa-fw fa-arrow-right"></i></button>
							</div>
						</footer>
					</div>
				</div>

			{{ form_close() }}

		{% else %}
			<p class="h2 light text-light-grey margin-top-lg">Não existem produtos no carrinho</p>
		{% endif %}

	</div>

{% endblock %}
