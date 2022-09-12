{#
Description: Shopping cart page
#}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb">
		<li><a href="{{ site_url() }}">Home</a><span class="divider">›</span></li>
		<li class="active">Carrinho de Compras</li>
	</ul>

	<h1>Carrinho de Compras</h1>

	<br>

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
							<th class="text-right">Subtotal</th>
							<th class="text-center">Remover</th>
						</tr>
					</thead>

					<tbody>

					{% for item in cart.items %}
						<tr data-product="{{ item.product_id }}" data-product-option="{{ item.options|keys[0] }}">
							<td>{% if item.image %}<img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ item.image }}" width="22" height="22" class="hidden-phone lazy"> {% endif %}{{ item.title }}</td>
							<td><div class="form-inline"><input class="input-micro" type="number" value="{{ item.qty }}" name="qtd[{{ item.item_id }}]" {% if item.stock_sold_single %} data-toggle="tooltip" data-placement="bottom" data-original-title="Só é possível comprar 1 unidade deste produto." title="Só é possível comprar 1 unidade deste produto." readonly {% endif %}> <button type="submit" formaction="{{ site_url('cart/post/update') }}" class="btn btn-small">Alterar</button></div></td>
							<td class="price text-right">{{ item.subtotal | money_with_sign }}</td>
							<td class="text-center"><a href="{{ item.remove_link }}" class="btn btn-small"><i class="fa fa-trash"></i>&nbsp;<span class="hidden-phone">Remover</span></a></td>
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
						<input type="text" value="{{ cart.coupon.code }}" class="form-control" id="cupao" name="cupao" placeholder="Inserir código">
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

			<button type="submit" formaction="{{ site_url('cart/post/data') }}" class="btn btn-large">Prosseguir ›</button>

		{{ form_close() }}

		{% if store.settings.cart.related_products_intelligent %}
			<div class="related-products margin-top hidden" data-load="related-products" data-products="{{ cart.items|column('product_id')|json_encode }}" data-num-products="3" data-products-per-row="3" data-css-class-wrapper="cart-related-products" data-type="intelligent">
				<div class="text-center">
					<h3 class="products-title margin-bottom">Outros clientes também compraram</h3>
					<div class="related-products-placement"></div>
				</div>
			</div>
		{% endif %}

	{% else %}

		<div class="alert alert-info">
			Não existem produtos no carrinho.
		</div>

	{% endif %}

{% endblock %}
