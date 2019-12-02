{#
Description: Complete order page
#}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb">
		<li><a href="{{ site_url() }}">Home</a><span class="divider">›</span></li>
		<li class="active">Encomenda registada</li>
	</ul>

	<h1>Encomenda registada</h1>
	<br>

	<p><strong>Obrigado {{ user.delivery.name }},</strong></p>
	<p>A sua encomenda foi registada com sucesso com o número: <strong>{{ order.id }}</strong></p>

	{% if order.payment.message %}
		<div class="payment-msg">
			<p>{{ order.payment.message }}</p>
		</div>
	{% endif %}

	{% if order.payment.type == 'multibanco' %}

		<br>

		{% if order.payment.data and order.payment.data.reference %}

			<div class="well multibanco-data">
				<h4>Dados para pagamento Multibanco</h4>
				<br>
				<p><strong>Entidade:</strong> <span class="muted">{{ order.payment.data.entity }}</span></p>
				<p><strong>Referência:</strong> <span class="muted">{{ order.payment.data.reference }}</span></p>
				<p><strong>Montante:</strong> <span class="muted">{{ order.payment.data.value | money_with_sign }}</span></p>
			</div>

		{% else %}

			<div class="alert alert-error">
				<button type="button" class="close" data-dismiss="alert">×</button>
				<h5>Erro</h5>
				<p>De momento não é possível utilizar o método de pagamento Multibanco.</p>
			</div>

		{% endif %}

	{% endif %}

	{% if order.payment.type == 'paypal' and order.payment.data.url %}
		<div class="paypal-data">
			<p style="margin-top:15px"><a href="{{ order.payment.data.url }}" target="_blank" class="btn btn-info btn-large"><i class="fa fa-fw fa-paypal" aria-hidden="true"></i> Pagar via Paypal</a></p>
		</div>
	{% endif %}

{% endblock %}