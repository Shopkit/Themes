{#
Description: Complete order page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">

		<section class="page">

			<h1>Encomenda registada</h1>
			<hr>

			<strong>Obrigado {{ user.delivery.name }},</strong><br>
			A sua encomenda foi registada com sucesso com o número: <strong>{{ order.id }}</strong><br><br>

			 {% if order.payment.message %}
				<div class="payment-msg">
					{{ order.payment.message }}
				</div>
			{% endif %}

			<br>

			{% if order.payment.type == 'multibanco' %}

				{% if order.payment.data and order.payment.data.reference %}

					<div class="boxed multibanco-data">
						<h4>Dados para pagamento Multibanco</h4>
						<br>
						<p><strong>Entidade:</strong> <span class="muted">{{ order.payment.data.entity }}</span></p>
						<p><strong>Referência:</strong> <span class="muted">{{ order.payment.data.reference }}</span></p>
						<p><strong>Montante:</strong> <span class="muted">{{ order.payment.data.value | money_with_sign }}</span></p>
					</div>

				{% else %}

					<div class="alert alert-error">
						<h5>Erro</h5>
						<p>De momento não  é possível utilizar o método de pagamento Multibanco.</p>
					</div>

				{% endif %}

			{% endif %}

			{% if order.payment.type == 'paypal' and order.payment.data.url %}
				<div class="paypal-data">
					<p><a href="{{ order.payment.data.url }}" target="_blank" class="btn btn-info btn-large"><i class="fa fa-fw fa-paypal" aria-hidden="true"></i> Pagar via Paypal</a></p>
				</div>
			{% endif %}

		</section>

	</div>

{% endblock %}