{#
Description: Account profile page
#}

{% import 'account.tpl' as account_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">
		<div class="row-fluid">

			<div class="span12">

				<p class="breadcrumbs">
					<a href="{{ site_url() }}"><i class="fa fa-home"></i></a> ›
					<a href="{{ site_url('account') }}">A minha conta</a> ›
					Dados de cliente
				</p><br>

				<h1>Olá <strong>{{ user.name|first_word }}</strong>.</h1>

				{% if errors.form %}
					<div class="alert alert-error">
						<button type="button" class="close" data-dismiss="alert">×</button>
						<h5>Erro</h5>
						{{ errors.form }}
					</div>
				{% endif %}

				{% if events.client.save_profile_success %}
					<div class="callout callout-success">
						<p>Os dados foram gravados com sucesso.</p>
					</div>
				{% endif %}

				{{ form_open('account/save-profile', {'role': 'form'}) }}

					<h3>Dados de cliente</h3>

					<div class="row-fluid">
						<div class="span6">
							<div class="form-group">
								<label for="delivery_name">Nome <small class="text-light-gray normal">(*)</small></label>
								<input type="text" name="name" id="name" class="form-control span12" value="{{ user.name }}" required>
							</div>
						</div>
						<div class="span6">
							<div class="form-group">
								<label for="email">E-mail <small class="text-light-gray normal">(*)</small></label>
								<input type="email" name="email" id="email" class="form-control span12" value="{{ user.email }}" required>
							</div>
						</div>
					</div>

					<div class="row-fluid">
						{% if store.settings.cart.field_company != 'hidden' %}
							<div class="span6">
								<div class="form-group">
									<label for="company">Empresa {{ store.settings.cart.field_company == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
									<input type="text" name="company" id="company" class="form-control span12" value="{{ user.company }}" placeholder="{{ store.settings.cart.field_company == 'optional' ? 'Opcional' }}" {{ store.settings.cart.field_company == 'required' ? 'required' }}>
								</div>
							</div>
						{% endif %}

						{% if store.settings.cart.field_fiscal_id != 'hidden' %}
							<div class="span6">
								<div class="form-group">
									<label for="fiscal_id">NIF {{ store.settings.cart.field_fiscal_id == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
									<input type="text" name="fiscal_id" id="fiscal_id" class="form-control span12" value="{{ user.fiscal_id }}" placeholder="{{ store.settings.cart.field_fiscal_id == 'optional' ? 'Opcional' }}" {{ store.settings.cart.field_fiscal_id == 'required' ? 'required' }}>
								</div>
							</div>
						{% endif %}
					</div>

					<div class="row-fluid">
						<div class="span6">
							<div class="form-group">
								<label for="locale">Idioma <small class="text-light-gray normal">(*)</small></label>
								<select name="locale" id="locale" class="form-control span12" required>
									{% for key, name in locales %}
										<option value="{{ key }}" {% if user.locale == key %} selected {% endif %}>{{ name }}</option>
									{% endfor %}
								</select>
							</div>
						</div>
						<div class="span6">
							<div class="form-group">
								<label for="gender">Género</label>
								<select name="gender" id="gender" class="form-control span12">
									<option value=""></option>
									<option value="female" {% if user.gender == 'female' %} selected {% endif %}>Feminino</option>
									<option value="male" {% if user.gender == 'male' %} selected {% endif %}>Masculino</option>
									<option value="other" {% if user.gender == 'other' %} selected {% endif %}>Outro</option>
								</select>
							</div>
						</div>
					</div>

					<div class="row-fluid">
						<div class="span6">
							<div class="form-group">
								<label for="birthday">Data de nascimento</label>
								<input type="date" name="birthday" id="birthday" class="form-control span12" value="{{ user.birthday }}">
							</div>
						</div>
						<div class="span6">
							{% if apps.newsletter %}
								<label for="locale">Newsletter</label>
								<div class="checkbox">
									<label>
										<input type="checkbox" name="subscribe_newsletter" id="subscribe_newsletter" value="1" {% if user.subscribe_newsletter %} checked {% endif %}>
										Pretendo registar-me na newsletter
									</label>
								</div>
							{% endif %}
						</div>
					</div>

					<div class="row-fluid">
						<div class="span6">
							<div class="form-group">
								<label for="password">Password</label>
								<input type="password" name="password" id="password" class="form-control span12">
							</div>
						</div>
						<div class="span6">
							<div class="form-group">
								<label for="repeat_password">Confirmar password</label>
								<input type="password" name="repeat_password" id="repeat_password" class="form-control span12">
							</div>
						</div>
					</div>

					<h3>Morada de envio</h3>
					<div class="delivery-info">
						<div class="row-fluid">
							<div class="span8">
								<div class="form-group">
									<label for="delivery_name">Nome <small class="text-light-gray normal">(*)</small></label>
									<input type="text" name="delivery_name" id="delivery_name" class="form-control span12" value="{{ user.delivery.name|default(user.name) }}" required>
								</div>
							</div>
							{% if store.settings.cart.field_delivery_phone != 'hidden' %}
								<div class="span4">
									<div class="form-group">
										<label for="delivery_phone">Telefone {{ store.settings.cart.field_delivery_phone == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
										<input type="text" name="delivery_phone" id="delivery_phone" class="form-control span12" value="{{ user.delivery.phone }}" placeholder="{{ store.settings.cart.field_delivery_phone == 'optional' ? 'Opcional' }}" {{ store.settings.cart.field_delivery_phone == 'required' ? 'required' }}>
									</div>
								</div>
							{% endif %}
						</div>

						<div class="row-fluid">
							<div class="span12">
								<div class="form-group">
									<label for="delivery_address">Morada <small class="text-light-gray normal">(*)</small></label>
									<div class="row-fluid">
										<div class="span8">
											<input type="text" id="delivery_address" class="form-control span12" placeholder="Endereço" name="delivery_address" value="{{ user.delivery.address }}" data-places="route" required>
										</div>
										<div class="span4">
											<input type="text" class="form-control span12" placeholder="Nr., Andar, etc. (opcional)" name="delivery_address_extra" id="delivery_address_extra" value="{{ user.delivery.address_extra }}" autocomplete="off">
										</div>
									</div>
								</div>
							</div>
						</div>

						<div class="row-fluid">
							<div class="span3">
								<div class="form-group">
									<label for="delivery_zip_code">Código Postal <small class="text-light-gray normal">(*)</small></label>
									<input type="text" name="delivery_zip_code" id="delivery_zip_code" class="form-control span12" value="{{ user.delivery.zip_code }}" data-places="postal_code" required>
								</div>
							</div>
							<div class="span5">
								<div class="form-group">
									<label for="delivery_city">Localidade <small class="text-light-gray normal">(*)</small></label>
									<input type="text" name="delivery_city" id="delivery_city" class="form-control span12" value="{{ user.delivery.city }}" data-places="locality" required>
								</div>
							</div>
							<div class="span4">
								<div class="form-group">
									<label for="delivery_country">País <small class="text-light-gray normal">(*)</small></label>
									<select name="delivery_country" id="delivery_country" class="form-control span12" required>
										{% for key, country in countries %}
											<option value="{{ key }}" {% if user.delivery.country_code == key %} selected {% endif %}>{{ country }}</option>
										{% endfor %}
									</select>
								</div>
							</div>
						</div>
					</div>

					<h3>Morada de facturação</h3>
					<div class="checkbox margin-bottom">
						<label>
							<input type="checkbox" name="billing_info_same_delivery" id="billing_info_same_delivery" value="1" {% if user.billing.same_as_delivery %} checked {% endif %} data-target=".billing-info">
							A morada de facturação é igual à morada de envio
						</label>
					</div>
					<div class="{% if user.billing.same_as_delivery %}hidden{% endif %} billing-info">
						<div class="row-fluid">
							<div class="span8">
								<div class="form-group">
									<label for="billing_name">Nome <small class="text-light-gray normal">(*)</small></label>
									<input type="text" name="billing_name" id="billing_name" class="form-control span12" value="{{ user.billing.name }}">
								</div>
							</div>
							{% if store.settings.cart.field_billing_phone != 'hidden' %}
								<div class="span4">
									<div class="form-group">
										<label for="billing_phone">Telefone {{ store.settings.cart.field_billing_phone == 'required' ? '<small class="text-light-gray normal">(*)</small>' }}</label>
										<input type="text" name="billing_phone" id="billing_phone" class="form-control span12" value="{{ user.billing.phone }}" placeholder="{{ store.settings.cart.field_billing_phone == 'optional' ? 'Opcional' }}">
									</div>
								</div>
							{% endif %}
						</div>

						<div class="row-fluid">
							<div class="span12">
								<div class="form-group">
									<label for="billing_address">Morada <small class="text-light-gray normal">(*)</small></label>
									<div class="row-fluid">
										<div class="span8">
											<input type="text" id="billing_address" class="form-control span12" placeholder="Endereço" name="billing_address" value="{{ user.billing.address }}" data-places="route">
										</div>
										<div class="span4">
											<input type="text" class="form-control span12" placeholder="Nr., Andar, etc. (opcional)" name="billing_address_extra" id="billing_address_extra" value="{{ user.billing.address_extra }}">
										</div>
									</div>
								</div>
							</div>
						</div>

						<div class="row-fluid">
							<div class="span3">
								<div class="form-group">
									<label for="billing_zip_code">Código Postal <small class="text-light-gray normal">(*)</small></label>
									<input type="text" name="billing_zip_code" id="billing_zip_code" class="form-control span12" value="{{ user.billing.zip_code }}" data-places="postal_code">
								</div>
							</div>
							<div class="span5">
								<div class="form-group">
									<label for="billing_city">Localidade <small class="text-light-gray normal">(*)</small></label>
									<input type="text" name="billing_city" id="billing_city" class="form-control span12" value="{{ user.billing.city }}" data-places="locality">
								</div>
							</div>
							<div class="span4">
								<div class="form-group">
									<label for="billing_country">País <small class="text-light-gray normal">(*)</small></label>
									<select name="billing_country" id="billing_country" class="form-control span12">
										{% for key, country in countries %}
											<option value="{{ key }}" {% if user.billing.country_code == key %} selected {% endif %}>{{ country }}</option>
										{% endfor %}
									</select>
								</div>
							</div>
						</div>
					</div>

					<hr>

					<footer class="clearfix">
						<div class=" margin-top-xxs pull-left">
							<a href="{{ site_url('account/delete') }}" class="text-error small" onclick="return confirm('Tem a certeza que deseja eliminar a sua conta?')"><i class="fa fa-trash" aria-hidden="true"></i> Eliminar Conta</a>
						</div>
						<button class="button pull-right">Gravar Dados</button>
					</footer>
				{{ form_close() }}
			</div>

		</div>
	</div>

{% endblock %}