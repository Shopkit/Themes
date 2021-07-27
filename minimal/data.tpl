{#
Description: Order data form page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="container">

		<h1 class="margin-bottom">Dados de Envio</h1>

		<ol class="breadcrumb margin-bottom hidden-xs">
			<li><a href="{{ site_url() }}">Home</a></li>
			<li><a href="{{ site_url('cart') }}">Carrinho de Compras</a></li>
			<li class="active">Dados de Envio</li>
		</ol>

		{% if errors.form %}
			<div class="callout callout-danger">
				<h4>Erro</h4>
				{{ errors.form }}
			</div>
		{% endif %}

		{{ form_open('cart/post/payment', {'role': 'form'}) }}

			<input type="hidden" name="user-auth-data" value="true">

			<div class="row">
				<div class="col-md-8 col-lg-8">

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
							<div class="row">
								<div class="col-sm-6">
									<h3>Dados de cliente</h3>
									{{ user.email }}<br>
									{{ user.l10n.tax_id_abbr }}: {{ user.fiscal_id ? user.fiscal_id : 'n/a' }}<br>
									Empresa: {{ user.company ? user.company : 'n/a' }}
								</div>
							</div>

							<div class="row">
								<div class="col-sm-6">
									<h3>Morada de envio</h3>
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
								<div class="col-sm-6">
									<h3>Morada de facturação</h3>
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
						{% else %}

							<h3 class="margin-bottom text-gray light">Dados de cliente</h3>

							<div class="row">
								<div class="col-sm-12">
									<div class="form-group">
										<label for="email">E-mail <small class="text-light-gray normal">(*)</small></label>
										<input type="email" name="email" id="email" class="form-control" value="{{ user.email }}" required>
									</div>

									{% if apps.newsletter %}
										<div class="form-group">
											<div class="checkbox">
												<label>
													<input type="checkbox" name="subscribe_newsletter" id="subscribe_newsletter" value="1" {% if user.subscribe_newsletter %} checked {% endif %}>
													{{ apps.newsletter.label }}
												</label>
											</div>
										</div>
									{% endif %}
								</div>
							</div>
							<div class="row">
								{% if store.settings.cart.field_company != 'hidden' %}
									<div class="col-sm-8">
										<div class="form-group">
											<label for="company">Empresa {{ store.settings.cart.field_company == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
											<input type="text" name="company" id="company" class="form-control" value="{{ user.company }}" placeholder="{{ store.settings.cart.field_company == 'optional' ? 'Opcional' }}" {{ store.settings.cart.field_company == 'required' ? 'required' }}>
										</div>
									</div>
								{% endif %}

								{% if store.settings.cart.field_fiscal_id != 'hidden' %}
									<div class="col-sm-4">
										<div class="form-group">
											<label for="fiscal_id">{{ user.l10n.tax_id_abbr }} {{ store.settings.cart.field_fiscal_id == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
											<input type="text" name="fiscal_id" id="fiscal_id" class="form-control" value="{{ user.fiscal_id }}" placeholder="{{ store.settings.cart.field_fiscal_id == 'optional' ? 'Opcional' }}" {{ store.settings.cart.field_fiscal_id == 'required' ? 'required' }}>
										</div>
									</div>
								{% endif %}
							</div>

							<h3 class="margin-bottom text-gray light">Morada de envio</h3>

							<div class="delivery-info">
								<div class="row">
									<div class="col-sm-8">
										<div class="form-group">
											<label for="delivery_name">Nome <small class="text-light-gray normal">(*)</small></label>
											<input type="text" name="delivery_name" id="delivery_name" class="form-control" value="{{ user.delivery.name }}">
										</div>
									</div>
									{% if store.settings.cart.field_delivery_phone != 'hidden' %}
										<div class="col-sm-4">
											<div class="form-group">
												<label for="delivery_phone">Telefone {{ store.settings.cart.field_delivery_phone == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
												<input type="tel" name="delivery_phone" id="delivery_phone" class="form-control intl-validate" value="{{ user.delivery.phone }}" placeholder="{{ store.settings.cart.field_delivery_phone == 'optional' ? 'Opcional' }}">
											</div>
										</div>
									{% endif %}
								</div>

								<div class="row">
									<div class="col-sm-12">
										<div class="form-group">
											<label for="delivery_address">Morada <small class="text-light-gray normal">(*)</small></label>
											<div class="row">
												<div class="col-sm-8">
													<input type="text" id="delivery_address" class="form-control" placeholder="Endereço" name="delivery_address" value="{{ user.delivery.address }}" data-places="route" required>
												</div>
												<div class="col-sm-4">
													<input type="text" class="form-control" placeholder="Nr., Andar, etc. (opcional)" name="delivery_address_extra" id="delivery_address_extra" value="{{ user.delivery.address_extra }}" autocomplete="off">
												</div>
											</div>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-sm-3">
										<div class="form-group">
											<label for="delivery_zip_code">Código Postal <small class="text-light-gray normal">(*)</small></label>
											<input type="text" name="delivery_zip_code" id="delivery_zip_code" class="form-control" value="{{ user.delivery.zip_code }}" data-places="postal_code" required>
										</div>
									</div>
									<div class="col-sm-5">
										<div class="form-group">
											<label for="delivery_city">Localidade <small class="text-light-gray normal">(*)</small></label>
											<input type="text" name="delivery_city" id="delivery_city" class="form-control" value="{{ user.delivery.city }}" data-places="locality" required>
										</div>
									</div>
									<div class="col-sm-4">
										<div class="form-group">
											<label for="delivery_country">País <small class="text-light-gray normal">(*)</small></label>
											<select name="delivery_country" id="delivery_country" class="form-control" required>
												<option value selected disabled>Selecionar país</option>
												{% for key, country in countries %}
													<option value="{{ key }}" {% if user.delivery.country_code == key %} selected {% endif %}>{{ country }}</option>
												{% endfor %}
											</select>
										</div>
									</div>
								</div>
							</div>

							<h3 class="margin-bottom text-gray light">Morada de facturação</h3>
							<div class="checkbox">
								<label>
									<input type="checkbox" name="billing_info_same_delivery" id="billing_info_same_delivery" value="1" {% if not user.billing.same_as_delivery is same as(false) %} checked {% endif %} data-target=".billing-info">
									A morada de facturação é igual à morada de envio
								</label>
							</div>
							<div class="{% if not user.billing.same_as_delivery is same as(false) %}hidden{% endif %} billing-info">
								<div class="row">
									<div class="col-sm-8">
										<div class="form-group">
											<label for="billing_name">Nome <small class="text-light-gray normal">(*)</small></label>
											<input type="text" name="billing_name" id="billing_name" class="form-control" value="{{ user.billing.name }}">
										</div>
									</div>
									{% if store.settings.cart.field_billing_phone != 'hidden' %}
										<div class="col-sm-4">
											<div class="form-group">
												<label for="billing_phone">Telefone {{ store.settings.cart.field_billing_phone == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
												<input type="tel" name="billing_phone" id="billing_phone" class="form-control intl-validate" value="{{ user.billing.phone }}" placeholder="{{ store.settings.cart.field_billing_phone == 'optional' ? 'Opcional' }}">
											</div>
										</div>
									{% endif %}
								</div>

								<div class="row">
									<div class="col-sm-12">
										<div class="form-group">
											<label for="billing_address">Morada <small class="text-light-gray normal">(*)</small></label>
											<div class="row">
												<div class="col-sm-8">
													<input type="text" id="billing_address" class="form-control" placeholder="Endereço" name="billing_address" value="{{ user.billing.address }}" data-places="route">
												</div>
												<div class="col-sm-4">
													<input type="text" class="form-control" placeholder="Nr., Andar, etc. (opcional)" name="billing_address_extra" id="billing_address_extra" value="{{ user.billing.address_extra }}">
												</div>
											</div>
										</div>
									</div>
								</div>

								<div class="row">
									<div class="col-sm-3">
										<div class="form-group">
											<label for="billing_zip_code">Código Postal <small class="text-light-gray normal">(*)</small></label>
											<input type="text" name="billing_zip_code" id="billing_zip_code" class="form-control" value="{{ user.billing.zip_code }}" data-places="postal_code">
										</div>
									</div>
									<div class="col-sm-5">
										<div class="form-group">
											<label for="billing_city">Localidade <small class="text-light-gray normal">(*)</small></label>
											<input type="text" name="billing_city" id="billing_city" class="form-control" value="{{ user.billing.city }}" data-places="locality">
										</div>
									</div>
									<div class="col-sm-4">
										<div class="form-group">
											<label for="billing_country">País <small class="text-light-gray normal">(*)</small></label>
											<select name="billing_country" id="billing_country" class="form-control">
												<option value selected disabled>Selecionar país</option>
												{% for key, country in countries %}
													<option value="{{ key }}" {% if user.billing.country_code == key %} selected {% endif %}>{{ country }}</option>
												{% endfor %}
											</select>
										</div>
									</div>
								</div>
							</div>

						{% endif %}

						<div class="row">
							<div class="col-sm-12">
								<div class="form-group margin-top">
									<label for="observations">Observações <small class="text-light-gray normal">(opcional)</small></label>
									<textarea cols="80" rows="4" class="form-control" id="observations" name="observations" placeholder="Preencha caso queira dar instruções acerca dos produtos ou encomenda">{{ user.observations }}</textarea>
								</div>

								<footer class="clearfix">
									<div class="pull-left steps hidden-xs">
										Passo 1 de 3
									</div>
									<div class="pull-right">
										<small class="text-gray"><a href="{{ site_url('cart') }}">Editar carrinho</a> &nbsp; &bull; &nbsp; </small> <button class="btn btn-primary">Prosseguir <i class="fa fa-fw fa-arrow-right"></i></button>
									</div>
								</footer>

							</div>
						</div>
					{% endif %}

				</div>

				<div class="col-md-4 col-md-offset-0 col-lg-3 col-lg-offset-1 hidden-xs hidden-sm">

					<div class="well">
						<h3 class="margin-bottom-sm bordered">Resumo</h3>
						<dl class="dl-horizontal text-left">
							{% for item in cart.items %}
								<dt title="{{ item.title|e_attr }}"><small class="normal text-gray">{{ item.qty }}x</small> &nbsp;{{ item.title }}</dt>
								<dd class="text-dark price">{{ item.subtotal | money_with_sign }}</dd>
							{% endfor %}
						</dl>

						<hr>

						<dl class="dl-horizontal text-left margin-bottom-0">

							{% if not store.taxes_included or cart.total_taxes == 0 %}
                                <dt class="margin-bottom-xxs">{{ user.l10n.tax_name }}</dt>
                                <dd class="text-dark price">{{ cart.product_tax | money_with_sign }}</dd>
                            {% endif %}

							<dt class="bold h4 margin-0">Subtotal</dt>
                            <dd class="bold h4 margin-0 price">{{ (store.taxes_included ? cart.subtotal : cart.subtotal_with_tax) | money_with_sign }}</dd>
						</dl>

						{% if store.taxes_included and cart.total_taxes > 0 %}
                            <div class="small text-muted margin-top-xxs">Inclui {{ user.l10n.tax_name }} a {{ cart.product_tax | money_with_sign }}</div>
                        {% endif %}

						<button class="btn btn-lg btn-primary btn-block margin-top-sm">Prosseguir <i class="fa fa-fw fa-arrow-right"></i></button>
					</div>

				</div>
			</div>

		{{ form_close() }}

	</div>

{% endblock %}