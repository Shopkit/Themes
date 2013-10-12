{# 
Description: Shopping cart page
#}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb">
		<li><a href="/">Home</a><span class="divider">›</span></li>
		<li class="active">Carrinho de Compras</li>
	</ul>

	<h1>Carrinho de Compras</h1>

	<br>

	{% if cart.items %}
				
		{{ form_open('cart/update') }}
				
			<table class="table table-bordered table-cart">
				<thead>
					<tr>
						<th>Título</th>
						<th width="17%">Quantidade</th>
						<th>Preço&nbsp;Uni.</th>
						<th>SubTotal</th>
						<th>Remover</th>
					</tr>
				</thead>
						
				<tbody>
							
				{% for item in cart.items %} 
					<tr>
						<td>{% if item.image %}<img src="{{ item.image }}" width="22" height="22" class="hidden-phone"> {% endif %}{{ item.title }}</td>
						<td><div class="form-inline"><input class="input-micro" type="text" value="{{ item.qty }}" name="qtd[{{ item.item_id }}]"> <button type="submit" class="btn btn-small">Alterar</button></div></td>
						<td class="price text-right">{{ item.price | money_with_sign }}</td>
						<td class="price text-right">{{ item.subtotal | money_with_sign }}</td>
						<td><a href="{{ item.remove_link }}" class="btn btn-small"><i class="icon-trash"></i>&nbsp;<span class="hidden-phone">Remover</span></a></td>
					</tr>
				{% endfor %}
							
				</tbody>
						
				<tfoot>
					<tr>
						<td class="subtotal">Subtotal Encomenda</td>
						<td colspan="3" class="subtotal price text-right">{{ cart.subtotal | money_with_sign }}</td>
						<td class="subtotal">&nbsp;</td>
					</tr>
				</tfoot>
			</table>
			
			
			<p><a class="btn btn-large" href="{{ site_url('cart/data') }}">Prosseguir ›</a></p>
				
		{{ form_close() }}
				
		{% else %}
			
			<div class="alert alert-info">
				Não existem produtos no carrinho.
			</div>
				
		{% endif %}
		
{% endblock %}