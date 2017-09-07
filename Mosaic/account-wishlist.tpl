{#
Description: Wishlist account page
#}

{% import 'account.tpl' as account_macros %}

{% extends 'base.tpl' %}

{% block content %}


	<div class="content">
		<div class="row-fluid">

			<div class="span12">

				<p class="breadcrumbs">
					<a href="/"><i class="fa fa-home"></i></a> ›
					<a href="{{ site_url('account') }}">A minha conta</a> › 
					Wishlist
				</p><br>

				<h1>Olá <strong>{{ user.name|first_word }}</strong>.</h1>

				<h3>Wishlist</h3>

				{% if user.wishlist %}
					<div class="table-responsive">
						<table class="table table-vertical-align">
							<tbody>
								{% for product in user.wishlist %}
									<tr>
										<td width="60">
											<a href="{{ product.url }}"><img src="{{ product.image }}" alt="{{ product.title }}" title="{{ product.title }}" width="60"></a>
										</td>
										<td>
											<p class="margin-bottom-0"><a href="{{ product.url }}">{{ product.title }}</a></p>

											{% if (product.stock_qty and product.stock_show_info) %}
												<small>{{ product.stock_qty }} unidades em stock</small><br>
											{% endif %}

											 <small class="text-muted">Adicionado em {{ product.created_at|date("d \\d\\e F \\d\\e Y") }}</small>
										</td>
										<td class="text-right">
		                                    <a href="{{ product.remove_wishlist_url }}" class="text-muted small" title="Remover"><i class="fa fa-fw fa-trash fa-lg"></i></a> &nbsp; 
		                                    <a href="{{ product.add_cart_url }}" class="text-muted small" title="Adicionar ao carrinho"><i class="fa fa-fw fa-cart-plus fa-lg"></i></a>
		                                </td>
									</tr>
								{% endfor %}
							</tbody>
						</table>
					</div>
				{% else %}
					<p>Não existem produtos na wishlist.</p>
				{% endif %}
			</div>

		</div>
	</div>

{% endblock %}