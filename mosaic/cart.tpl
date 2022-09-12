{#
Description: Shopping cart page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">
		<section class="page">

			<p class="breadcrumbs">
				<a href="{{ site_url() }}"><i class="fa fa-home"></i></a> ›
				Carrinho de Compras
			</p><br>

			<h1>Carrinho de Compras</h1>

			<hr>

			{% if cart.items %}

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

				{{ form_open('cart/post/data') }}

					<div class="table-responsive">
						<table class="table table-bordered table-cart">
							<thead>
								<tr>
									<th>Produto</th>
									<th>Quantidade</th>
									<th style="text-align:right;">Subtotal</th>
									<th style="text-align:center;">Remover</th>
								</tr>
							</thead>

							<tbody>

							{% for item in cart.items %}
								<tr data-product="{{ item.product_id }}" data-product-option="{{ item.options|keys[0] }}">
									<td>{{ item.title }}</td>
									<td><div class="form-inline"><input class="span1" type="number" value="{{ item.qty }}" name="qtd[{{ item.item_id }}]" {% if item.stock_sold_single %} data-toggle="tooltip" data-placement="bottom" data-original-title="Só é possível comprar 1 unidade deste produto." title="Só é possível comprar 1 unidade deste produto." readonly {% endif %}> <button type="submit" formaction="{{ site_url('cart/post/update') }}" class="btn-small"><i class="fa fa-refresh"></i></button></div></td>
									<td class="price text-right">{{ item.subtotal | money_with_sign }}</td>
									<td style="text-align:center;"><a href="{{ item.remove_link }}" class="btn-small"><i class="fa fa-trash-o"></i></a></td>
								</tr>
							{% endfor %}

							</tbody>

							<tfoot>
								<tr>
									<td class="subtotal">Subtotal Encomenda</td>
									<td colspan="2" class="subtotal price text-right">{{ cart.subtotal | money_with_sign }}</td>
									<td class="subtotal">&nbsp;</td>
								</tr>
							</tfoot>
						</table>
					</div>

					<hr>

					<div class="coupon-code">
						<h4>Cupão de desconto</h4>

						<div class="coupon-code-input {{ not cart.coupon ? '' : 'hidden' }}">
							<div class="input-append">
								<input type="text" value="{{ cart.coupon.code }}" class="form-control margin-bottom-0" id="cupao" name="cupao" placeholder="Inserir código">
								<button type="submit" formaction="{{ site_url('cart/coupon/add') }}" class="btn btn-default">Aplicar</button>
							</div>
						</div>

						<div class="coupon-code-label margin-top-xxs {{ cart.coupon ? cart.coupon.code : 'hidden' }}">
							<span class="label label-light-bg h5">
								<i class="fa fa-tags fa-fw" aria-hidden="true"></i>
								<span class="coupon-code-text">{{ cart.coupon.code }}</span>
								<a href="{{ site_url('cart/coupon/remove') }}" class="btn-close"><i class="fa fa-times fa-fw" aria-hidden="true"></i></a>
							</span>
						</div>
					</div>

					<hr>

					<button type="submit" formaction="{{ site_url('cart/post/data') }}" class="button" style="width:200px">
						<i class="fa fa-chevron-right"></i>
						<span>Prosseguir</span>
					</button>

				{{ form_close() }}

			{% else %}

				<p>Não existem produtos no carrinho.</p>

			{% endif %}

		</section>
	</div>

	{% if cart.items %}
		{% if store.settings.cart.related_products_intelligent %}
			<div class="related-products margin-top hidden" data-load="related-products" data-products="{{ cart.items|column('product_id')|json_encode }}" data-num-products="6" data-products-per-row="4" data-css-class-wrapper="cart-related-products" data-type="intelligent">
				<div class="wide text-center">
					<h1 class="wide">Outros clientes também compraram</h1>
				</div>
				<div class="related-products-placement"></div>
			</div>
		{% endif %}
	{% endif %}

{% endblock %}
