{# 
Description: Complete order page
#}

{% extends 'base.tpl' %}

{% block content %}
	
	<ul class="breadcrumb">
		<li><a href="/">Home</a><span class="divider">›</span></li>
		<li class="active">Encomenda registada</li>
	</ul>
	
	<h1>Encomenda registada</h1>		
	<br>
	
	<p><strong>Obrigado {{ user.name }},</strong></p>
	<p>A sua encomenda foi registada com sucesso com o número: <strong>{{ order.id }}</strong></p>
	<p>{{ order.msg_payment }}</p>
	
	{% if order.payment == 'Multibanco' %}
		
		<br>
		
		{% if order.multibanco is defined  %}
		
			<div class="well">
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
				<button type="button" class="close" data-dismiss="alert">×</button>
				<h5>Erro</h5>
				<p>De momento não  é possível utilizar o método de pagamento Multibanco.</p>
			</div>
		
		{% endif %}
		
	{% endif %}
	
	{% if order.payment == 'Paypal' %}
	
		{{ form_open('https://www.paypal.com/cgi-bin/webscr', { 'id' : 'form-paypal' }) }}
		
			<input type="hidden" name="cmd" value="_cart">
			<input type="hidden" name="business" value="{{ store.paypal_email }}">
			<input type="hidden" name="currency_code" value="{{ store.currency }}">
			<input type="hidden" name="return" value="{{ site_url('loja/pagamentos/paypal_sucesso') }}">
			<input type="hidden" name="notify_url" value="{{ site_url('loja/pagamentos/ipn/' ~ order.hash) }}">
			<input type="hidden" name="upload" value="1">
			<input type="hidden" name="invoice" value="{{ order.id }}">
			<input type="hidden" name="shipping_1" value="{{ order.total_shipping }}">
			<input type="hidden" name="tax_cart" value="{{ order.taxes }}">
			
			{% if order.discount %}
				<input type="hidden" name="discount_amount_cart" value="{{ order.discount }}">
			{% endif %}
			
			{% if store.logo %}
				<input type="hidden" name="image_url" value="{{ store.logo }}">
			{% endif %}
			
			{% for item in order.products %}
		        <input type="hidden" name="item_name_{{ loop.index }}" value="{{ item.title }}">
		        <input type="hidden" name="item_number_{{ loop.index }}" value="{{ item.reference }}">
				<input type="hidden" name="amount_{{ loop.index }}" value="{{ item.price }}">
				<input type="hidden" name="quantity_{{ loop.index }}" value="{{ item.qty }}">
		    {% endfor %}
			
			<hr>
			
			<button type="submit" class="btn btn-large">Efectuar pagamento Paypal</button>
			
		{{ form_close() }}
		
		<script>document.getElementById('form-paypal').submit();</script>
	
	{% endif %}
		
{% endblock %}