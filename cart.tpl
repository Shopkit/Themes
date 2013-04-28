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
						<td class="price text-right">&euro; {{ item.price }}</td>
						<td class="price text-right">&euro; {{ item.subtotal }}</td>
						<td><a href="{{ item.remove_link }}" class="btn btn-small"><i class="icon-trash"></i>&nbsp;<span class="hidden-phone">Remover</span></a></td>
					</tr>
				{% endfor %}
							
				</tbody>
						
				<tfoot>
					
					{% if cart.discount %}
						<tr>
							<td class="discount">Desconto</td>
							<td align="right" class="discount price text-right" colspan="3">- € {{ cart.discount }}</td>
							<td class="discount">&nbsp;</td>
						</tr>
					{% endif %}
					
					<tr>
						<td class="subtotal">Subtotal Encomenda</td>
						<td colspan="3" class="subtotal price text-right">&euro; {{ cart.subtotal }}</td>
						<td class="subtotal">&nbsp;</td>
					</tr>
				</tfoot>
			</table>
			
			
			<p><a class="btn btn-large" href="{{ site_url('cart/payment') }}">Prosseguir ›</a></p>
				
		{{ form_close() }}
				
		{% else %}
			
			<div class="alert alert-info">
				Não existem produtos no carrinho.
			</div>
				
		{% endif %}
		
{% endblock %}