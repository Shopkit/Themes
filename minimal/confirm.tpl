{#
Description: Confirm order page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="container">

		<h1 class="margin-bottom">Confirmação</h1>

		<ol class="breadcrumb margin-bottom hidden-xs">
			<li><a href="{{ site_url() }}">Home</a></li>
			<li><a href="{{ site_url('cart') }}">Carrinho de Compras</a></li>
			<li><a href="{{ site_url('cart/data') }}">Dados de Envio</a></li>
			<li><a href="{{ site_url('cart/payment') }}">Pagamento e Transporte</a></li>
			<li class="active">Confirmação</li>
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
			{{ form_open('cart/complete', { 'role' : 'form' }) }}
				<div class="row">
					<div class="col-md-8 col-lg-8">

						<h3 class="margin-top-0">Produtos</h3>

						<div class="table-responsive table-cart-responsive">
							<table class="table table-cart table-confirm margin-bottom-0">
								<thead>
									<tr>
										<th colspan="2">Produto</th>
										<th class="text-right">Quantidade</th>
										<th class="text-right">Subtotal</th>
									</tr>
								</thead>

								<tbody>

									{% for item in cart.items %}
										<tr>
											<td class="cart-img">
												<a href="{{ item.product_url }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ item.image }}" alt="{{ item.title|e_attr }}" title="{{ item.title|e_attr }}" class="border-radius lazy"></a>
											</td>
											<td>
												<h4><a href="{{ item.product_url }}">{{ item.title }}</a></h4>
											</td>
											<td class="text-right">
												{{ item.qty }}
											</td>
											<td class="text-right price">
												{{ item.subtotal | money_with_sign }}
											</td>
										</tr>
									{% endfor %}

								</tbody>
							</table>
						</div>

						<div class="row">
							<div class="col-sm-6">
								<h3>Pagamento</h3>
								<p>{{ user.payment_method.title }}</p>
							</div>
							<div class="visible-xs margin-bottom"></div>
							<div class="col-sm-6">
								{% if user.shipping_method %}
									<h3>Transporte</h3>
									<p>{{ user.shipping_method.title }}</p>
								{% endif %}
							</div>
						</div>

						<div class="row">
							<div class="col-sm-6">
								<h3>Dados de cliente</h3>
								{{ user.email }}<br>
								{% if store.settings.cart.field_fiscal_id != 'hidden' %}
									{{ user.l10n.tax_id_abbr }}: {{ user.fiscal_id ? user.fiscal_id : 'n/a' }}<br>
								{% endif %}
								{% if store.settings.cart.field_company != 'hidden' %}
									Empresa: {{ user.company ? user.company : 'n/a' }}
								{% endif %}
							</div>
						</div>

						<div class="confirm-data">
							<div class="row">
								<div class="col-sm-6">
									<h3>Morada de envio</h3>
									<p>
										{{ user.delivery.name }}<br>
										{{ user.delivery.address }} {{ user.delivery.address_extra }}<br>
										{{ user.delivery.zip_code }} {{ user.delivery.city }}<br>
										{{ user.delivery.country }}
									</p>
									{% if store.settings.cart.field_delivery_phone != 'hidden' %}
										<p>
											{{ user.delivery.phone ? 'Telefone: ' ~ user.delivery.phone : '' }}
										</p>
									{% endif %}
								</div>
								<div class="visible-xs margin-bottom"></div>
								<div class="col-sm-6">
									<h3>Morada de facturação</h3>
									<p>
										{{ user.billing.name }}<br>
										{{ user.billing.address }} {{ user.billing.address_extra }}<br>
										{{ user.billing.zip_code }} {{ user.billing.city }}<br>
										{{ user.billing.country }}
									</p>
									{% if store.settings.cart.field_billing_phone != 'hidden' %}
										<p>
											{{ user.billing.phone ? 'Telefone: ' ~ user.billing.phone : '' }}
										</p>
									{% endif %}
								</div>
							</div>
						</div>

						{% if user.observations %}
							<h3>Observações</h3>
							<p>{{ user.observations|nl2br }}</p>
						{% endif %}

						{% if user.custom_field %}
							{% for custom_fields in user.custom_field %}
								<div class="well">
									{% set custom_field = custom_fields|json_decode %}
									<h3 class="margin-bottom-md">{{ custom_field.title }}</h3>
									{% if custom_field.data %}
										{% for data in custom_field.data %}
											<p><strong>{{ data.key }}</strong>: {{ data.value }}</p>
										{% endfor %}
									{% else %}
										<p><strong>{{ custom_field.key }}</strong>: {{ custom_field.value }}</p>
									{% endif %}
								</div>
							{% endfor %}
						{% endif %}

						<footer class="clearfix hidden-xs hidden-sm">
							<div class="pull-left steps hidden-xs">
								Passo 3 de 3
							</div>
							<div class="pull-right">
								<small class="text-gray"><a href="{{ site_url('cart') }}">Editar carrinho</a> &nbsp; &bull; &nbsp; </small> <button class="btn btn-primary"><i class="fa fa-fw fa-check"></i> Confirmar encomenda</button>
							</div>
						</footer>

					</div>

					<div class="col-md-4 col-md-offset-0 col-lg-3 col-lg-offset-1">

						<div class="order-resume well margin-top">
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

							{% if store.settings.cart.page_terms or store.settings.cart.page_privacy %}
								<hr>
								<div class="accept_terms checkbox">
									<label>
										<input type="checkbox" name="accept_terms" id="accept_terms" value="1" required>
										Li e concordo com
										{% if store.settings.cart.page_terms %}
											os <a href="{{ store.settings.cart.page_terms.url }}" target="_blank">termos e condições</a>
										{% endif %}

										{% if store.settings.cart.page_terms and store.settings.cart.page_privacy %}e com{% endif %}

										{% if store.settings.cart.page_privacy %}
											a <a href="{{ store.settings.cart.page_privacy.url }}" target="_blank">política de privacidade</a>
										{% endif %}
									</label>
								</div>
							{% endif %}

							<p class="margin-top margin-bottom-0 text-center"><button class="btn btn-lg btn-primary btn-block"><i class="fa fa-fw fa-check"></i> Confirmar</button></p>

						</div>

					</div>

				</div>

			{{ form_close() }}

		{% else %}
			<p class="h2 light text-light-grey margin-top-lg">Não existem produtos no carrinho</p>
		{% endif %}

	</div>

{% endblock %}
