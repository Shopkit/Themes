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

				{% if order.msg_payment %}
					<div class="well">
						{{ order.msg_payment }}
					</div>
				{% endif %}

				{% if order.payment == 'Multibanco' %}

					{% if order.multibanco is defined  %}
						<div class="text-center">
							<div class="well inline-block">
								<img src="{{ assets_url('templates/assets/common/icons/payments/multibanco-color.png') }}" height="45" alt="Multibanco" title="Multibanco" class="margin-bottom-md">

								<p class="text-nowrap">
									<strong>Entidade:</strong> <span class="text-muted">{{ order.multibanco.entity }}</span>
								</p>
								<p class="text-nowrap">
									<strong>Referência:</strong> 
									<span class="text-muted">
										<span style="padding: 0 2px">{{ order.multibanco.reference|slice(0, 3) }}</span>
										<span style="padding: 0 2px">{{ order.multibanco.reference|slice(3, 3) }}</span>
										<span style="padding: 0 2px">{{ order.multibanco.reference|slice(6, 3) }}</span>
									</span>
								</p>
								<p class="text-nowrap">
									<strong>Montante:</strong> <span class="text-muted price">{{ order.multibanco.value | money_with_sign }}</span>
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

				{% if order.payment == 'Paypal' and order.paypal_url is defined %}
					<p class="text-center"><a href="{{ order.paypal_url  }}" target="_blank" class="btn btn-info btn-lg"><i class="fa fa-fw fa-paypal" aria-hidden="true"></i> Pagar via Paypal</a></p>
				{% endif %}

			</div>
		</div>

	</div>

{% endblock %}