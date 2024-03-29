{#
Description: Confirm order page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">

		<section class="page">

			<p class="breadcrumbs">
				<a href="{{ site_url() }}"><i class="fa fa-home"></i></a> ›
				<a href="{{ site_url('cart') }}">Carrinho de Compras</a> ›
				<a href="{{ site_url('cart/data') }}">Dados de Envio</a> ›
				<a href="{{ site_url('cart/payment') }}">Pagamento e Transporte</a> ›
				Confirmação
			</p><br>

			<h1>Confirmação</h1>

			<hr>

			{% if errors.form %}
				<div class="alert alert-error">
					<button type="button" class="close" data-dismiss="alert">×</button>
					<h5>Erro</h5>
					{{ errors.form }}
				</div>
			{% endif %}

			{% if warnings.form %}
				<div class="alert alert-warning">
					<button type="button" class="close" data-dismiss="alert">×</button>
					<h5>Aviso</h5>
					{{ warnings.form }}
				</div>
			{% endif %}

			{% if success.form %}
				<div class="alert alert-success">
					<button type="button" class="close" data-dismiss="alert">×</button>
					<h5>Sucesso</h5>
					{{ success.form }}
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
									<td><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ item.image }}" width="22" height="22" class="lazy"> {{ item.title }}</td>
									<td class="text-right">{{ item.qty }}</td>
									<td class="text-right">{{ item.subtotal | money_with_sign }}</td>
								</tr>
							{% endfor %}
						</tbody>

						<tfoot>
							<tr>
								<td>Subtotal</td>
								<td align="right" class="bold text-right" colspan="2" style="border-left: 0;">{{ cart.subtotal | money_with_sign }}</td>
							</tr>

							{% if cart.coupon %}
								<tr>
									<td class="discount">Desconto</td>
									<td align="right" class="discount text-right" colspan="2" style="border-left: 0;">{{ cart.coupon.type == 'shipping' ? 'Envio gratuito' : '- ' ~ cart.discount | money_with_sign }}</td>
								</tr>
							{% endif %}

							<tr>
								<td>Portes de Envio</td>
								<td align="right" class="text-right" colspan="2" style="border-left: 0;">{{ cart.shipping_methods ? (user.shipping_method ? (cart.coupon.type == 'shipping' or cart.total_shipping == 0 ? 'Grátis' : cart.total_shipping | money_with_sign) : 'n/a') : cart.total_shipping | money_with_sign }}</td>
							</tr>

							{% if not store.taxes_included or cart.total_taxes == 0 %}
								<tr>
									<td>Taxa / Imposto (<abbr title="Imposto sobre o valor acrescentado">{{ user.l10n.tax_name }}</abbr>)</td>
									<td align="right" class="price text-right" colspan="2">{{ cart.total_taxes | money_with_sign }}</td>
								</tr>
							{% endif %}

							<tr>
								<td class="subtotal" valign="middle" style="vertical-align: middle;font-size:16px;">Total Encomenda</td>
								<td colspan="2" class="subtotal price text-right" style="font-size:16px;border-left: 0;">
									{{ cart.total | money_with_sign }}

									{% if store.taxes_included and cart.total_taxes > 0 %}
										<div style="color:#999;font-weight: normal;font-size: 10px;margin-top:5px;">Inclui {{ user.l10n.tax_name }} a {{ cart.total_taxes | money_with_sign }}</div>
									{% endif %}
								</td>
							</tr>
						</tfoot>
					</table>

					<div class="row-fluid">
						<div class="span6">
							<h4>Pagamento</h4>
							{{ user.payment_method.title }}
						</div>

						{% if user.shipping_method %}
							<div class="span6">
								<h4>Transporte</h4>
								{{ user.shipping_method.title }}
						</div>
						{% endif %}
					</div>

					<div class="row-fluid">
						<div class="span4">
							<h4 class="margin-top">Dados de cliente</h4>
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
						<div class="row-fluid">
							<div class="span6">
								<h4 class="margin-top">Morada de envio</h4>
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

							<div class="span6">
								<h4 class="margin-top">Morada de facturação</h4>
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
						<h4>Observações</h4>
						<p>{{ user.observations|nl2br }}</p>
					{% endif %}

					<hr>

					{% if user.custom_field %}
						{% for custom_fields in user.custom_field %}
							{% set custom_field = custom_fields|json_decode %}
							<h4>{{ custom_field.title }}</h4>
							{% if custom_field.data %}
								{% for data in custom_field.data %}
									<p><strong>{{ data.key }}</strong>: {{ data.value }}</p>
								{% endfor %}
							{% else %}
								<p><strong>{{ custom_field.key }}</strong>: {{ custom_field.value }}</p>
							{% endif %}
							{{ loop.last ? '' : '<hr>' }}
						{% endfor %}
						<hr>
					{% endif %}

					{% if store.settings.cart.page_terms or store.settings.cart.page_privacy %}
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
						<hr>
					{% endif %}

					<button type="submit" class="button" style="width:200px">
						<i class="fa fa-chevron-right"></i>
						<span>Confirmar Encomenda</span>
					</button> &nbsp; &bull; &nbsp; <a href="{{ site_url('cart') }}">Editar Carrinho</a>

				{{ form_close() }}

			{% else %}

				<p>Não existem produtos no carrinho.</p>

			{% endif %}

		</section>

	</div>

{% endblock %}
