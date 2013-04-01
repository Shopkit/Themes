{# 
Description: Order data form page
#}

{% extends 'base.tpl' %}

{% block content %}
	
	<ul class="breadcrumb">
		<li><a href="/">Home</a><span class="divider">›</span></li>
		<li><a href="{{ site_url('cart') }}">Carrinho de Compras</a><span class="divider">›</span></li>
		<li><a href="{{ site_url('cart/payment') }}">Pagamento</a><span class="divider">›</span></li>
		<li class="active">Dados de Envio</li>
	</ul>
	
	<h1>Dados de Envio</h1>		
	<br>
	
	{% if errors.form %}
		<div class="alert alert-error">
			<button type="button" class="close" data-dismiss="alert">×</button>
			<h5>Erro</h5>
			<p>{{ errors.form }}</p>
		</div>
	{% endif %}
	
	{{ form_open('cart/confirm', {'class': 'form'}) }}
	
		<label for="nome">Nome <small class="muted">(*)</small></label>
		<input type="text" name="nome" id="nome" class="span9" value="{{ user.name }}" required>
		<br><br>
		
		<label for="email">E-mail <small class="muted">(*)</small></label>
		<input type="email" name="email" id="email" class="span9" value="{{ user.email }}" required>
		<br><br>
		
		<label for="morada">Morada <small class="muted">(*)</small></label>
		<textarea cols="80" rows="4" class="span9" id="morada" name="morada" placeholder="Introduza a morada onde quer receber a encomenda" required>{{ user.address }}</textarea>
		<br><br>
				
		<div class="row">
			
			<div class="span4">
				
				<label for="cp">Código Postal <small class="muted">(*)</small></label>
				<input type="text" name="cp" id="cp" class="span4" value="{{ user.zip_code }}" required>
				<br><br>
				
				<label for="contribuinte">Nr. Contribuinte</label>
				<input type="text" name="contribuinte" id="contribuinte" class="span4" value="{{ user.tax_id }}">
				
			</div>
			
			<div class="span4 offset1">
				
				<label for="localidade">Localidade <small class="muted">(*)</small></label>
				<input type="text" name="localidade" id="localidade" class="span4" value="{{ user.city }}" required>
				<br><br>
				
				<label for="telefone">Telefone</label>
				<input type="text" name="telefone" id="telefone" class="span4" value="{{ user.phone }}">
				
			</div>
			
		</div>
		
		<br>
		<label for="observacoes">Observações</label>
		<textarea cols="80" rows="4" class="span9" id="observacoes" name="observacoes" placeholder="Preencha caso queira dar instruções acerca dos produtos ou encomenda">{{ user.notes }}</textarea>

		<br><br>

		<label class="checkbox"><input type="checkbox" name="subscribe_newsletter" id="subscribe_newsletter" value="1"> Pretendo registar-me na newsletter</label>
		
		<hr>
		
		<button type="submit" class="btn btn-large">Rever Encomenda ›</button>
	
	{{ form_close() }}
		
{% endblock %}