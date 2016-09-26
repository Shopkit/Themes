{#
Description: Order data form page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="container">

		<h1 class="margin-bottom">Dados de Envio</h1>

		<ol class="breadcrumb margin-bottom hidden-xs">
			<li><a href="/">Home</a></li>
			<li><a href="{{ site_url('cart') }}">Carrinho de Compras</a></li>
			<li class="active">Dados de Envio</li>
		</ol>

		{% if errors.form %}
			<div class="callout callout-danger">
				<h4>Erro</h4>
				<p>{{ errors.form }}</p>
			</div>
		{% endif %}

		{{ form_open('cart/post/payment', {'role': 'form'}) }}

			<div class="row">
				<div class="col-md-8 col-lg-8">

					<div class="row">
						<div class="col-sm-7">
							<div class="form-group">
								<label for="nome">Nome <small class="text-light-gray normal">(*)</small></label>
								<input type="text" name="nome" id="nome" class="form-control" value="{{ user.name }}" required>
							</div>
						</div>

						<div class="col-sm-5">
							<div class="form-group">
								<label for="contribuinte">Contribuinte</label>
								<input type="text" name="contribuinte" id="contribuinte" class="form-control" value="{{ user.tax_id }}">
							</div>
						</div>
					</div>

					<br>

					<div class="row">
						<div class="col-sm-7">
							<div class="form-group">
								<label for="email">E-mail <small class="text-light-gray normal">(*)</small></label>
								<input type="email" name="email" id="email" class="form-control" value="{{ user.email }}" required>
							</div>
						</div>

						<div class="col-sm-5">
							<div class="form-group">
								<label for="telefone">Telefone</label>
								<input type="text" name="telefone" id="telefone" class="form-control" value="{{ user.phone }}">
							</div>
						</div>
					</div>

					<br>

					<div class="row">
						<div class="col-sm-12">
							<div class="form-group">
								<label for="morada">Morada <small class="text-light-gray normal">(*)</small></label>
								<textarea  class="form-control" cols="80" rows="4" id="morada" name="morada" placeholder="Introduza a morada onde quer receber a encomenda" required>{{ user.address }}</textarea>
							</div>
						</div>
					</div>

					<br>

					<div class="row">

						<div class="col-sm-3">
							<div class="form-group">
								<label for="cp">Código Postal <small class="text-light-gray normal">(*)</small></label>
								<input type="text" name="cp" id="cp" class="form-control" value="{{ user.zip_code }}" required>
							</div>
						</div>

						<div class="col-sm-5">
							<div class="form-group">
								<label for="localidade">Localidade <small class="text-light-gray normal">(*)</small></label>
								<input type="text" name="localidade" id="localidade" class="form-control" value="{{ user.city }}" required>
							</div>
						</div>

						<div class="col-sm-4">
							<div class="form-group">
								<label for="pais">País <small class="text-light-gray normal">(*)</small></label>
								<select name="pais" id="pais" class="form-control" required>
									{% for key, country in countries %}
										<option value="{{ key }}" {% if user.country_code == key %} selected {% endif %}>{{ country }}</option>
									{% endfor %}
								</select>
							</div>
						</div>

					</div>

					<br>

					<div class="row">
						<div class="col-sm-12">
							<div class="form-group">
								<label for="observacoes">Observações <small class="text-light-gray normal">(opcional)</small></label>
								<textarea cols="80" rows="4" class="form-control" id="observacoes" name="observacoes" placeholder="Preencha caso queira dar instruções acerca dos produtos ou encomenda">{{ user.notes }}</textarea>
							</div>

							{% if apps.newsletter %}
								<div class="checkbox">
									<label>
										<input type="checkbox" name="subscribe_newsletter" id="subscribe_newsletter" value="1">
										Pretendo registar-me na newsletter
									</label>
								</div>
							{% endif %}

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


				</div>

				<div class="col-md-4 col-md-offset-0 col-lg-3 col-lg-offset-1 hidden-xs hidden-sm">

					<div class="well">
						<h3 class="margin-bottom-sm bordered">Resumo</h3>
						<dl class="dl-horizontal text-left">
							{% for item in cart.items %}
								<dt title="{{ item.title }}"><small class="normal text-gray">{{ item.qty }}x</small> &nbsp;{{ item.title }}</dt>
								<dd class="text-dark price">{{ item.subtotal | money_with_sign }}</dd>
							{% endfor %}
						</dl>

						<hr>

						<dl class="dl-horizontal text-left h4 margin-bottom-0">
							<dt>Subtotal:</dt>
							<dd class="text-dark bold price">{{ cart.subtotal | money_with_sign }}</dd>
						</dl>
					</div>

				</div>
			</div>

		{{ form_close() }}

	</div>

{% endblock %}