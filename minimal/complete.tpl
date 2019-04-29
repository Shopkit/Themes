{#
Description: Complete order page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="container">

		<div class="text-center margin-bottom">
			<i class="fa fa-check fa-5x text-success"></i>
			<h2 class="text-muted">A sua encomenda foi registada com sucesso</h2>
			<h3 class="light text-light-gray">#{{ order.id }}</h3>
		</div>

		<div class="row">
			<div class="col-sm-10 col-sm-offset-1 col-md-8 col-md-offset-2 col-lg-6 col-lg-offset-3">

				 {% if order.payment.message %}
					<div class="well payment-msg">
						{{ order.payment.message }}
					</div>
				{% endif %}

				{% if order.payment.type == 'multibanco' %}

					{% if order.payment.data %}
						<div class="text-center">
							<div class="well inline-block multibanco-data">
								<img src="{{ assets_url('templates/assets/common/icons/payments/multibanco-color.png') }}" height="45" alt="Multibanco" title="Multibanco" class="margin-bottom-md">

								<p class="text-nowrap">
									<strong>Entidade:</strong> <span class="text-muted">{{ order.payment.data.entity }}</span>
								</p>
								<p class="text-nowrap">
									<strong>Referência:</strong>
									<span class="text-muted">
										<span style="padding: 0 2px">{{ order.payment.data.reference|slice(0, 3) }}</span>
										<span style="padding: 0 2px">{{ order.payment.data.reference|slice(3, 3) }}</span>
										<span style="padding: 0 2px">{{ order.payment.data.reference|slice(6, 3) }}</span>
									</span>
								</p>
								<p class="text-nowrap">
									<strong>Montante:</strong> <span class="text-muted price">{{ order.payment.data.value | money_with_sign }}</span>
								</p>
							</div>
						</div>
					{% else %}
						<div class="callout callout-danger">
							<h4>Erro</h4>
							<p></p>
							<p>De momento não  é possível utilizar o método de pagamento Multibanco.</p>
						</div>
					{% endif %}

				{% endif %}

				{% if order.payment.type == 'paypal' and order.payment.data.url %}
					<div class="paypal-data">
						<p class="text-center"><a href="{{ order.payment.data.url }}" target="_blank" class="btn btn-info btn-lg"><i class="fa fa-fw fa-paypal" aria-hidden="true"></i> Pagar via Paypal</a></p>
					</div>
				{% endif %}

			</div>
		</div>

	</div>

{% endblock %}