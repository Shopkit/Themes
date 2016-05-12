{#
Description: Confirm order page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="container">

		<h1 class="margin-bottom">Confirmação</h1>

		<ol class="breadcrumb margin-bottom hidden-xs">
			<li><a href="/">Home</a></li>
			<li><a href="{{ site_url('cart') }}">Carrinho de Compras</a></li>
			<li><a href="{{ site_url('cart/data') }}">Dados de Envio</a></li>
			<li><a href="{{ site_url('cart/payment') }}">Pagamento e Transporte</a></li>
			<li class="active">Confirmação</li>
		</ol>

		{% if errors.form %}
			<div class="callout callout-danger">
				<h4>Erro</h4>
				<p>{{ errors.form }}</p>
			</div>
		{% endif %}

		{% if cart.items %}
			{{ form_open('cart/complete', { 'role' : 'form' }) }}
				<div class="row">
					<div class="col-md-8 col-lg-8">

						<h3 class="margin-top-0">Produtos</h3>

						<div class="table-responsive">
							<table class="table table-cart table-confirm">
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
												<a href="{{ item.product_url }}"><img src="{{ item.image }}" alt="{{ item.title }}" title="{{ item.title }}" class="border-radius"></a>
											</td>
											<td>
												<h4><a href="{{ item.product_url }}">{{ item.title }}</a></h4>
											</td>
											<td class="text-right">
												{{ item.qty }}
											</td>
											<td class="text-right">
												{{ item.subtotal | money_with_sign }}
											</td>
										</tr>
									{% endfor %}

								</tbody>
							</table>
						</div>

						<div class="well">
							<div class="row">
								<div class="col-sm-6">
									<h3>Pagamento</h3>
									<p>{{ user.payment }}</p>
								</div>
								<div class="visible-xs margin-bottom"></div>
								<div class="col-sm-6">
									{% if user.shipping_method %}
										<h3>Transporte</h3>
										<p>{{ user.shipping_method.title }}</p>
									{% endif %}
								</div>
							</div>
						</div>

						<div class="well">

							<h3 class="margin-bottom-md">Dados de Envio</h3>

							<div class="confirm-data">

								<div class="row margin-bottom-sm">
									<div class="col-sm-6">
										<p><strong>Nome</strong><br>{{ user.name }}</p>
									</div>
									<div class="col-sm-6">
										<p><strong>Morada</strong><br>{{ user.address|nl2br }}</p>
									</div>
								</div>

								<div class="row margin-bottom-sm">
									<div class="col-sm-6">
										<p><strong>E-mail</strong><br>{{ user.email }}</p>
									</div>
									<div class="col-sm-6">
										<p><strong>Código Postal</strong><br>{{ user.zip_code }}</p>
									</div>
								</div>

								<div class="row margin-bottom-sm">
									<div class="col-sm-6">
										<p><strong>Nr. Contribuinte</strong><br>{{ user.tax_id ?: 'n/a' }}</p>
									</div>
									<div class="col-sm-6">
										<p><strong>Localidade</strong><br>{{ user.city }}</p>
									</div>
								</div>

								<div class="row margin-bottom-sm">
									<div class="col-sm-6">
										<p><strong>Telefone</strong><br>{{ user.phone ?: 'n/a' }}</p>
									</div>
									<div class="col-sm-6">
										<p><strong>País</strong><br>{{ user.country ?: 'n/a' }}</p>
									</div>
								</div>

								<p class="margin-bottom-0"><strong>Observações</strong><br>{{ user.notes ?: 'n/a' }}</p>
							</div>
						</div>

						{% if user.custom_field %}
						    <div class="well">
						        {% for custom_fields in user.custom_field %}
						            {% set custom_field = custom_fields|json_decode %}
						            <h3 class="margin-bottom-md">{{ custom_field.title }}</h3>
						            <p><strong>{{ custom_field.key }}</strong>: {{ custom_field.value }}</p>
						            {{ loop.last ? '' : '<hr>' }}
						        {% endfor %}
						    </div>
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

						<div class="well">
							<h3 class="margin-bottom-sm bordered">Encomenda</h3>

							<dl class="dl-horizontal text-left">
								{% if store.taxes_included == false and cart.taxes > 0 %}
									<dt>IVA</dt>
									<dd class="text-dark price">{{ cart.taxes | money_with_sign }}</dd>
								{% endif %}

								<dt>Portes de envio</dt>
								<dd class="text-dark price">{{ cart.total_shipping | money_with_sign }}</dd>

								{% if cart.discount %}
									<dt>Desconto</dt>
									<dd class="text-dark price">- {{ cart.discount | money_with_sign }}</dd>
								{% endif %}
							</dl>

							<hr>

							<dl class="dl-horizontal text-left h3 margin-bottom">
								<dt>Total:</dt>
								<dd class="text-dark bold price">{{ cart.total | money_with_sign }}</dd>
							</dl>

							<p class="margin-bottom-0 text-center"><button class="btn btn-lg btn-primary btn-block"><i class="fa fa-fw fa-check"></i> Confirmar</button></p>

						</div>



					</div>

				</div>

			{{ form_close() }}

		{% else %}
			<p class="h2 light text-light-grey margin-top-lg">Não existem produtos no carrinho</p>
		{% endif %}

	</div>

{% endblock %}