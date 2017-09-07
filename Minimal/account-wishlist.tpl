{#
Description: Wishlist account page
#}

{% import 'account.tpl' as account_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="container">
		<div class="row">
			<div class="col-sm-3">
				<div class="panel panel-default margin-bottom">
					<div class="panel-heading">
						<a href="{{ site_url('account') }}" class="link-inherit">A minha conta</a>
					</div>

					{{ account_macros.account_navigation() }}

				</div>
			</div>

			<div class="col-sm-8 col-sm-offset-1">
				<h1 class="margin-top-0 margin-bottom">Olá <strong>{{ user.name|first_word }}</strong>.</h1>

				<h3 class="margin-top-0 text-gray light">Wishlist</h3>
				{% if user.wishlist %}
					<div class="table-responsive">
						<table class="table table-cart vertical-align">
							<tbody>
								{% for product in user.wishlist %}
									<tr>
										<td class="cart-img">
											<a href="{{ product.url }}"><img src="{{ product.image }}" alt="{{ product.title }}" title="{{ product.title }}" class="border-radius"></a>
										</td>
										<td>
											<h4 class="normal margin-top-0 margin-bottom-xxs"><a href="{{ product.url }}">{{ product.title }}</a></h4>

											{% if (product.stock_qty and product.stock_show_info) %}
												<small>{{ product.stock_qty }} unidades em stock</small><br>
											{% endif %}

											<small class="text-muted">Adicionado em {{ product.created_at|date("d \\d\\e F \\d\\e Y") }}</small>
										</td>
										<td class="cart-actions">
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