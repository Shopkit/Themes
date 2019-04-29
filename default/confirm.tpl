{#
Description: Confirm order page
#}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb">
		<li><a href="/">Home</a><span class="divider">›</span></li>
		<li><a href="{{ site_url('cart') }}">Carrinho de Compras</a><span class="divider">›</span></li>
		<li><a href="{{ site_url('cart/data') }}">Dados de Envio</a><span class="divider">›</span></li>
		<li><a href="{{ site_url('cart/payment') }}">Pagamento e Transporte</a><span class="divider">›</span></li>
		<li class="active">Confirmação</li>
	</ul>

	<h1>Confirmação</h1>
	<br>

	{% if errors.form %}
		<div class="alert alert-error">
			<button type="button" class="close" data-dismiss="alert">×</button>
			<h5>Erro</h5>
			{{ errors.form }}
		</div>
	{% endif %}

	{% if cart.items %}

		{{ form_open('cart/complete', { 'class' : 'form' }) }}

			<table class="table table-bordered table-cart">
				<thead>
					<tr>
						<th>Título</th>
						<th class="text-right">Quantidade</th>
						<th class="text-right">Subtotal</th>
					</tr>
				</thead>

				<tbody>
					{% for item in cart.items %}
						<tr>
							<td><img src="{{ item.image }}" width="22" height="22"> {{ item.title }}</td>
							<td class="text-right">{{ item.qty }}</td>
							<td class="text-right">{{ item.subtotal | money_with_sign }}</td>
						</tr>
					{% endfor %}
				</tbody>

				<tfoot>
					<tr>
						<td>Subtotal</td>
						<td align="right" class=" bold text-right" colspan="2" style="border-left: 0;">{{ cart.subtotal | money_with_sign }}</td>
					</tr>
					<tr>
						<td>Portes de Envio</td>
						<td align="right" class=" text-right" colspan="2" style="border-left: 0;">{{ cart.total_shipping | money_with_sign }}</td>
					</tr>

					{% if cart.coupon %}
						<tr>
							<td class="discount">Desconto</td>
							<td align="right" class="discount text-right" colspan="2" style="border-left: 0;">- {{ cart.discount | money_with_sign }}</td>
						</tr>
					{% endif %}

					{% if store.taxes_included == false and cart.taxes > 0 %}
						<tr>
							<td>Taxa / Imposto (<abbr title="Imposto sobre o valor acrescentado">IVA</abbr>)</td>
							<td align="right" class=" price text-right" colspan="2">{{ cart.taxes | money_with_sign }}</td>
						</tr>
					{% endif %}

					<tr>
						<td class="subtotal" valign="middle" style="vertical-align: middle;font-size:16px;">Total Encomenda</td>
						<td colspan="2" class="subtotal price text-right" style="font-size:16px;border-left: 0;">
							{{ cart.total | money_with_sign }}

							{% if store.taxes_included %}
								<div style="color:#999;font-weight: normal;font-size: 10px;margin-top:5px;">Inclui IVA a {{ cart.total_taxes | money_with_sign }}</div>
							{% endif %}
						</td>
					</tr>
				</tfoot>
			</table>

			<div class="row">
				<div class="span4">
					<h4>Pagamento</h4>
					<p>{{ user.payment_method.title }}</p>
				</div>

				{% if user.shipping_method %}
					<div class="span4 offset1">
						<h4>Transporte</h4>
						<p>{{ user.shipping_method.title }}</p>
					</div>
				{% endif %}
			</div>

			<div class="row">
				<div class="span4">
					<h4>Dados de cliente</h4>
					{{ user.email }}<br>
					NIF: {{ user.fiscal_id ? user.fiscal_id : 'n/a' }}<br>
					Empresa: {{ user.company ? user.company : 'n/a' }}
				</div>
			</div>

			<div class="confirm-data">
				<div class="row">
					<div class="span4">
						<h4>Morada de envio</h4>
						<p>
							{{ user.delivery.name }}<br>
							{{ user.delivery.address }} {{ user.delivery.address_extra }}<br>
							{{ user.delivery.zip_code }} {{ user.delivery.city }}<br>
							{{ user.delivery.country }}
						</p>
						<p>
							{{ user.delivery.phone ? 'Telefone: ' ~ user.delivery.phone : '' }}
						</p>
					</div>

					<div class="span4 offset1">
						<h4>Morada de facturação</h4>
						<p>
							{{ user.billing.name }}<br>
							{{ user.billing.address }} {{ user.billing.address_extra }}<br>
							{{ user.billing.zip_code }} {{ user.billing.city }}<br>
							{{ user.billing.country }}
						</p>
						<p>
							{{ user.billing.phone ? 'Telefone: ' ~ user.billing.phone : '' }}
						</p>
					</div>
				</div>
			</div>

			{% if user.observations %}
				<h4>Observações</h4>
				<p>{{ user.observations|nl2br }}</p>
			{% endif %}

			<hr>

			{% if user.custom_field %}
				{% for custom_fields in user.custom_field %}
					{% set custom_field = custom_fields|json_decode %}
					<h4>{{ custom_field.title }}</h4>
					<p><strong>{{ custom_field.key }}</strong>: {{ custom_field.value }}</p>
					{{ loop.last ? '' : '<hr>' }}
				{% endfor %}
				<hr>
			{% endif %}

			{% if not user.is_logged_in and (store.settings.cart.page_terms or store.settings.cart.page_privacy) %}
				<div class="checkbox">
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
				<hr>
			{% endif %}

			<button type="submit" class="btn btn-large">Confirmar Encomenda ›</button> &nbsp; &bull; &nbsp; <a href="{{ site_url('cart') }}">Editar Carrinho</a>

		{{ form_close() }}

	{% else %}

		<p class="text">Não existem produtos no carrinho.</p>

	{% endif %}

{% endblock %}