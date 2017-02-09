{#
Description: Complete order page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">

		<section class="page">

			<h1>Encomenda registada</h1>
			<hr>

			<strong>Obrigado {{ user.name }},</strong><br>
			A sua encomenda foi registada com sucesso com o número: <strong>{{ order.id }}</strong><br><br>

			{% if order.msg_payment %}
				<div class="payment-msg">
					{{ order.msg_payment }}
				</div>
			{% endif %}

			<br><br>

			{% if order.payment == 'Multibanco' %}

				<br>

				{% if order.multibanco is defined  %}

					<div class="boxed multibanco-data">
						<h4>Dados para pagamento Multibanco</h4>
						<br>
						<p><strong>Entidade:</strong> <span class="muted">{{ order.multibanco.entity }}</span></p>
						<p><strong>Referência:</strong> <span class="muted">{{ order.multibanco.reference }}</span></p>
						<p><strong>Montante:</strong> <span class="muted">{{ order.multibanco.value | money_with_sign }}</span></p>
						<hr>
						<p><small>As referências multibanco são geradas pela <a target="_blank" href="https://www.easypay.pt/pt/aderir/shopkit">Easypay</a>.</small></p>
					</div>

				{% else %}

					<div class="alert alert-error">
						<h5>Erro</h5>
						<p>De momento não  é possível utilizar o método de pagamento Multibanco.</p>
					</div>

				{% endif %}

			{% endif %}

			{% if order.payment == 'Paypal' and order.paypal_url is defined %}
				<div class="paypal-data">
					<p><a href="{{ order.paypal_url  }}" target="_blank" class="btn btn-info btn-large"><i class="fa fa-fw fa-paypal" aria-hidden="true"></i> Pagar via Paypal</a></p>
				</div>
			{% endif %}

		</section>

	</div>

{% endblock %}