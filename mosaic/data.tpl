{#
Description: Order data form page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">

		<section class="page">

			<p class="breadcrumbs">
				<a href="{{ site_url() }}"><i class="fa fa-home"></i></a> ›
				<a href="{{ site_url('cart') }}">Carrinho de Compras</a> ›
				Dados de Envio
			</p><br>

			<h1>Dados de Envio</h1>

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

			{{ form_open('cart/post/payment', {'class': 'form'}) }}

				<input type="hidden" name="user-auth-data" value="true">

				{% if not user.is_logged_in %}
					{% if store.settings.cart.users_registration == 'optional' %}
						<div class="well">
							Já tem uma conta? <a href="#signin" class="trigger-shopkit-auth-modal">Faça Login</a>.
						</div>
					{% elseif store.settings.cart.users_registration == 'required' %}
						<div class="well">
							Para prosseguir com a compra deverá fazer <a href="#signin" class="trigger-shopkit-auth-modal">login ou registar-se</a>.
						</div>
					{% endif %}
				{% endif %}

				{% if store.settings.cart.users_registration != 'required' or user.is_logged_in %}

					{% if user.is_logged_in %}
						{# If user is logged in, no need to show the form #}
						<div class="row-fluid">
							<div class="span12">
								<h4>Dados de cliente</h4>
								{{ user.email }}<br>
								{{ user.l10n.tax_id_abbr }}: {{ user.fiscal_id ? user.fiscal_id : 'n/a' }}<br>
								Empresa: {{ user.company ? user.company : 'n/a' }}
							</div>
						</div>
						<div class="row-fluid">
							<div class="span6">
								<h4 class="margin-top">Morada de envio</h4>
								{% if user.delivery.address %}
									<p>
										{{ user.delivery.name }}<br>
										{{ user.delivery.address }} {{ user.delivery.address_extra }}<br>
										{{ user.delivery.zip_code }} {{ user.delivery.city }}<br>
										{{ user.delivery.country }}
									</p>
									<p>
										{{ user.delivery.phone ? 'Telefone: ' ~ user.delivery.phone : '' }}
									</p>
								{% else %}
									<p>Não tem nenhuma morada de envio definida.</p>
								{% endif %}
								<a href="{{ site_url('account/profile') }}">Editar</a>
							</div>
							<div class="span6">
								<h4 class="margin-top">Morada de facturação</h4>
								{% if user.billing.address %}
									<p>
										{{ user.billing.name }}<br>
										{{ user.billing.address }} {{ user.billing.address_extra }}<br>
										{{ user.billing.zip_code }} {{ user.billing.city }}<br>
										{{ user.billing.country }}
									</p>
									<p>
										{{ user.billing.phone ? 'Telefone: ' ~ user.billing.phone : '' }}
									</p>
								{% else %}
									<p>Não tem nenhuma morada de facturação definida.</p>
								{% endif %}
								<a href="{{ site_url('account/profile') }}">Editar</a>
							</div>
						</div>
						<br>

					{% else %}
						<h4 class="margin-bottom">Dados de Cliente</h4>

						<div class="row-fluid">
							<div class="span12 margin-bottom-sm">
								<label for="email">E-mail <small class="muted">(*)</small></label>
								<input type="email" name="email" id="email" class="input-block-level" value="{{ user.email }}" required>

								{% if apps.newsletter %}
									<br>
									<label class="checkbox"><input type="checkbox" name="subscribe_newsletter" id="subscribe_newsletter" value="1" {% if user.subscribe_newsletter %} checked {% endif %}> {{ apps.newsletter.label }}</label>
								{% endif %}
							</div>
						</div>

						<div class="row-fluid">
							{% if store.settings.cart.field_company != 'hidden' %}
								<div class="span7">
									<label for="company">Empresa {{ store.settings.cart.field_company == 'required' ? '<small class="muted">(*)</small>' }}</label>
									<input type="text" name="company" id="company" class="input-block-level" value="{{ user.company }}" placeholder="{{ store.settings.cart.field_company == 'optional' ? 'Opcional' }}" {{ store.settings.cart.field_company == 'required' ? 'required' }}>
								</div>
							{% endif %}

							{% if store.settings.cart.field_fiscal_id != 'hidden' %}
								<div class="span5">
									<label for="fiscal_id">{{ user.l10n.tax_id_abbr }} {{ store.settings.cart.field_fiscal_id == 'required' ? '<small class="muted">(*)</small>' }}</label>
									<input type="text" name="fiscal_id" id="fiscal_id" class="input-block-level" value="{{ user.fiscal_id }}" placeholder="{{ store.settings.cart.field_fiscal_id == 'optional' ? 'Opcional' }}" {{ store.settings.cart.field_fiscal_id == 'required' ? 'required' }}>
								</div>
							{% endif %}
						</div>

						<h4 class="margin-bottom">Morada de envio</h4>

						<div class="delivery-info">
							<div class="row-fluid">
								<div class="span7">
									<label for="delivery_name">Nome <small class="muted">(*)</small></label>
									<input type="text" name="delivery_name" id="delivery_name" class="input-block-level" value="{{ user.delivery.name }}" required>
								</div>
							{% if store.settings.cart.field_delivery_phone != 'hidden' %}
								<div class="span5">
									<label for="delivery_phone">Telefone {{ store.settings.cart.field_delivery_phone == 'required' ? '<small class="muted">(*)</small>' }}</label>
									<input type="tel" name="delivery_phone" id="delivery_phone" class="input-block-level intl-validate" value="{{ user.delivery.phone }}" placeholder="{{ store.settings.cart.field_delivery_phone == 'optional' ? 'Opcional' }}" {{ store.settings.cart.field_delivery_phone == 'required' ? 'required' }}>
								</div>
							{% endif %}
							</div>

							<div class="row-fluid">
								<div class="span12">
									<label for="morada">Morada <small class="muted">(*)</small></label>
									<div class="row-fluid">
										<div class="span7">
											<input type="text" name="delivery_address" id="delivery_address" class="input-block-level" placeholder="Endereço" value="{{ user.delivery.address }}" data-places="route" required>
										</div>
										<div class="span5">
											<input type="text" name="delivery_address_extra" id="delivery_address_extra" class="input-block-level" placeholder="Nr., Andar, etc. (opcional)" value="{{ user.delivery.address_extra }}" autocomplete="off">
										</div>
									</div>
								</div>
							</div>

							<div class="row-fluid">
								<div class="span3">
									<label for="delivery_zip_code">Código Postal <small class="muted">(*)</small></label>
									<input type="text" name="delivery_zip_code" id="delivery_zip_code" class="input-block-level" value="{{ user.delivery.zip_code }}" data-places="postal_code" required>
								</div>

								<div class="span4">
									<label for="delivery_city">Localidade <small class="muted">(*)</small></label>
									<input type="text" name="delivery_city" id="delivery_city" class="input-block-level" value="{{ user.delivery.city }}" data-places="locality" required>
								</div>

								<div class="span5">
									<label for="delivery_country">País <small class="muted">(*)</small></label>
									<select name="delivery_country" id="delivery_country" class="input-block-level" required>
										<option value selected disabled>Selecionar país</option>
										{% for key, country in countries %}
											<option value="{{ key }}" {% if user.delivery.country_code == key %} selected {% endif %}>{{ country }}</option>
										{% endfor %}
									</select>
								</div>
							</div>
						</div>

						<h4 class="margin-bottom">Morada de facturação</h4>

						<div class="checkbox margin-bottom">
							<label>
								<input type="checkbox" name="billing_info_same_delivery" id="billing_info_same_delivery" value="1" {% if not user.billing.same_as_delivery is same as(false) %} checked {% endif %} data-target=".billing-info">
								A morada de facturação é igual à morada de envio
							</label>
						</div>

						<div class="{% if not user.billing.same_as_delivery is same as(false) %}hidden{% endif %} billing-info">
							<div class="row-fluid">
								<div class="span7">
									<label for="billing_name">Nome <small class="muted">(*)</small></label>
									<input type="text" name="billing_name" id="billing_name" class="input-block-level" value="{{ user.billing.name }}">
								</div>

								{% if store.settings.cart.field_billing_phone != 'hidden' %}
									<div class="span5">
										<label for="billing_phone">Telefone {{ store.settings.cart.field_billing_phone == 'required' ? '<small class="muted">(*)</small>' }}</label>
										<input type="tel" name="billing_phone" id="billing_phone" class="input-block-level intl-validate" value="{{ user.billing.phone }}" placeholder="{{ store.settings.cart.field_billing_phone == 'optional' ? 'Opcional' }}">
									</div>
								{% endif %}
							</div>

							<div class="row-fluid">
								<div class="span12">
									<label for="morada">Morada <small class="muted">(*)</small></label>
									<div class="row-fluid">
										<div class="span7">
											<input type="text" name="billing_address" id="billing_address" class="input-block-level" placeholder="Endereço" value="{{ user.billing.address }}" data-places="route">
										</div>
										<div class="span5">
											<input type="text" name="billing_address_extra" id="billing_address_extra" class="input-block-level" placeholder="Nr., Andar, etc. (opcional)" value="{{ user.billing.address_extra }}" autocomplete="off">
										</div>
									</div>
								</div>
							</div>

							<div class="row-fluid">
								<div class="span3">
									<label for="billing_zip_code">Código Postal <small class="muted">(*)</small></label>
									<input type="text" name="billing_zip_code" id="billing_zip_code" class="input-block-level" value="{{ user.billing.zip_code }}" data-places="postal_code">
								</div>

								<div class="span4">
									<label for="billing_city">Localidade <small class="muted">(*)</small></label>
									<input type="text" name="billing_city" id="billing_city" class="input-block-level" value="{{ user.billing.city }}" data-places="locality">
								</div>

								<div class="span5">
									<label for="billing_country">País <small class="muted">(*)</small></label>
									<select name="billing_country" id="billing_country" class="input-block-level">
										<option value selected disabled>Selecionar país</option>
										{% for key, country in countries %}
											<option value="{{ key }}" {% if user.billing.country_code == key %} selected {% endif %}>{{ country }}</option>
										{% endfor %}
									</select>
								</div>
							</div>
							<br>
						</div>

					{% endif %}

					<div class="row-fluid">
						<div class="span12">
							<label for="observations">Observações</label>
							<textarea cols="80" rows="4" class="input-block-level" id="observations" name="observations" placeholder="Preencha caso queira dar instruções acerca dos produtos ou encomenda">{{ user.observations }}</textarea>
						</div>
					</div>

				{% endif %}

				{% if cart.coupon %}
					<hr>

					<div class="coupon-code">
						<h4>Cupão de desconto</h4>

						<div class="coupon-code-label margin-top-xxs">
							<span class="label label-light-bg h5">
								<i class="fa fa-tags fa-fw" aria-hidden="true"></i>
								<span class="coupon-code-text">{{ cart.coupon.code }}</span>
								<a href="{{ site_url('cart/coupon/remove') }}" class="btn-close"><i class="fa fa-times fa-fw" aria-hidden="true"></i></a>
							</span>
						</div>
					</div>
				{% endif %}

				<hr>

				<button type="submit" class="button" style="width:200px">
					<i class="fa fa-chevron-right"></i>
					<span>Prosseguir</span>
				</button>

			{{ form_close() }}

		</section>

	</div>

{% endblock %}
