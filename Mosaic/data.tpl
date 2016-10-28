{#
Description: Order data form page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">

		<section class="page">

			<p class="breadcrumbs">
				<a href="/"><i class="fa fa-home"></i></a> ›
				<a href="{{ site_url('cart') }}">Carrinho de Compras</a> ›
				Dados de Envio
			</p><br>

			<h1>Dados de Envio</h1>

			<hr>

			{% if errors.form %}
				<div class="alert alert-error">
					<button type="button" class="close" data-dismiss="alert">×</button>
					<h5>Erro</h5>
					<p>{{ errors.form }}</p>
				</div>
			{% endif %}

			{{ form_open('cart/post/payment', {'class': 'form'}) }}

				<div class="row-fluid">
					<div class="span7">
						<label for="nome">Nome <small class="muted">(*)</small></label>
						<input type="text" name="nome" id="nome" class="input-block-level" value="{{ user.name }}" required>
					</div>

					<div class="span5">
						<label for="contribuinte">Nr. Contribuinte</label>
						<input type="text" name="contribuinte" id="contribuinte" class="input-block-level" value="{{ user.tax_id }}">
					</div>
				</div>
				<br><br>

				<div class="row-fluid">
					<div class="span7">
						<label for="email">E-mail <small class="muted">(*)</small></label>
						<input type="email" name="email" id="email" class="input-block-level" value="{{ user.email }}" required>
					</div>

					<div class="span5">
						<label for="telefone">Telefone</label>
						<input type="text" name="telefone" id="telefone" class="input-block-level" value="{{ user.phone }}">
					</div>
				</div>
				<br><br>

				<div class="row-fluid">
					<div class="span12">
						<label for="morada">Morada <small class="muted">(*)</small></label>
						<textarea cols="80" rows="4" class="input-block-level" id="morada" name="morada" placeholder="Introduza a morada onde quer receber a encomenda" required>{{ user.address }}</textarea>
					</div>
				</div>
				<br><br>

				<div class="row-fluid">

					<div class="span3">
						<label for="cp">Código Postal <small class="muted">(*)</small></label>
						<input type="text" name="cp" id="cp" class="input-block-level" value="{{ user.zip_code }}" required>
					</div>

					<div class="span5">
						<label for="localidade">Localidade <small class="muted">(*)</small></label>
						<input type="text" name="localidade" id="localidade" class="input-block-level" value="{{ user.city }}" required>
					</div>

					<div class="span4">
						<label for="pais">País <small class="muted">(*)</small></label>
						<select name="pais" id="pais" class="input-block-level" required>
							{% for key, country in countries %}
								<option value="{{ key }}" {% if user.country_code == key %} selected {% endif %}>{{ country }}</option>
							{% endfor %}
						</select>
					</div>

				</div>
				<br>

				<div class="row-fluid">
					<div class="span12">
						<label for="observacoes">Observações</label>
						<textarea cols="80" rows="4" class="input-block-level" id="observacoes" name="observacoes" placeholder="Preencha caso queira dar instruções acerca dos produtos ou encomenda">{{ user.notes }}</textarea>
					</div>
				</div>

				{% if apps.newsletter %}
					<br><br>
					<label class="checkbox"><input type="checkbox" name="subscribe_newsletter" id="subscribe_newsletter" value="1"> Pretendo registar-me na newsletter</label>
				{% endif %}

				<hr>

				<button type="submit" class="button">
					<i class="fa fa-chevron-right"></i>
					<span>Prosseguir</span>
				</button>

			{{ form_close() }}


		</section>

	</div>

{% endblock %}