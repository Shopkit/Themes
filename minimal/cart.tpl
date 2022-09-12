{#
Description: Shopping cart page
#}

{% extends 'base.tpl' %}

{% block content %}

	<div class="container">

		<h1 class="margin-bottom">Carrinho de Compras</h1>

		<ol class="breadcrumb margin-bottom hidden-xs">
			<li><a href="{{ site_url() }}">Home</a></li>
			<li class="active">Carrinho de Compras</li>
		</ol>

		{% if cart.items %}

			{% if errors.form %}
				<div class="callout callout-danger">
					<h4>Erro</h4>
					{{ errors.form }}
				</div>
			{% endif %}

			{% if warnings.form %}
				<div class="callout callout-warning">
					<h4>Aviso</h4>
					{{ warnings.form }}
				</div>
			{% endif %}

			{% if success.form %}
				<div class="callout callout-success">
					<h4>Sucesso</h4>
					{{ success.form }}
				</div>
			{% endif %}

			{{ form_open('cart/post/data', {'class' : 'form'}) }}
				<div class="row">
					<div class="col-md-8 col-lg-8">

						<div class="table-responsive table-cart-responsive form-inline">
							<table class="table table-cart">

								<tbody>

									{% for item in cart.items %}
										<tr data-product="{{ item.product_id }}" data-product-option="{{ item.options|keys[0] }}">
											<td class="cart-img">
												<a href="{{ item.product_url }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ item.image }}" alt="{{ item.title|e_attr }}" title="{{ item.title|e_attr }}" class="border-radius lazy"></a>
											</td>

											<td>
												<h4 class="normal margin-top-0 margin-bottom-xs"><a href="{{ item.product_url }}">{{ item.title }}</a></h4>

												<a href="{{ item.remove_link }}" class="text-muted small"><i class="fa fa-trash"></i> Remover</a>
											</td>

											<td class="text-right">
												<h4 class="margin-top-0 margin-bottom-sm bold price">{{ item.subtotal | money_with_sign }}</h4>

												<div class="form-group">
													<label class="hidden-xs" for="qty-{{ item.item_id }}">Qtd.&nbsp;</label><input class="form-control input-sm input-qtd" type="number" value="{{ item.qty }}" name="qtd[{{ item.item_id }}]" {% if item.stock_sold_single %} data-toggle="tooltip" data-placement="left" data-original-title="Só é possível comprar 1 unidade deste produto." title="Só é possível comprar 1 unidade deste produto." readonly {% endif %} id="qty-{{ item.item_id }}">
												</div><span class="visible-xs-inline-block visible-sm-inline-block">&nbsp;<button type="submit" class="btn btn-default btn-sm"><i class="fa fa-refresh"></i></button></span>
											</td>
										</tr>
									{% endfor %}

								</tbody>

							</table>

						</div>

						<footer>
							<button type="submit" formaction="{{ site_url('cart/post/update') }}" class="btn btn-default"><i class="fa fa-fw fa-refresh"></i> Actualizar carrinho</button> &nbsp;
							<button type="submit" formaction="{{ site_url('cart/post/data') }}" class="btn btn-primary"><i class="fa fa-fw fa-shopping-cart"></i> Comprar</button>
						</footer>

						<div class="well text-center visible-md visible-lg">
							<h3 class="margin-bottom-md">Questões?</h3>
							<p class="margin-bottom-md">Se tiver dúvidas sobre sua compra, ou quaisquer outras questões, <a href="{{ site_url('contact') }}">entre em contacto</a>.</p>
						</div>

					</div>

					<div class="order-resume-container col-sm-12 col-sm-offset-0 col-md-4 col-md-offset-0 col-lg-3 col-lg-offset-1">

						<div class="order-resume well">
							<h3 class="margin-bottom-sm margin-top-0 bordered">Resumo</h3>

							<dl class="dl-horizontal text-left margin-bottom-0">
								<dt class="bold">Subtotal:</dt>
								<dd class="text-dark price">{{ cart.subtotal | money_with_sign }}</dd>

								{% if cart.coupon %}
									<dt>Desconto</dt>
									<dd class="text-dark price">{{ cart.coupon.type == 'shipping' ? 'Envio gratuito' : '- ' ~ cart.discount | money_with_sign }}</dd>
								{% endif %}

								<dt>Portes de envio</dt>
								<dd class="text-dark price">{{ cart.shipping_methods ? (user.shipping_method ? (cart.coupon.type == 'shipping' or cart.total_shipping == 0 ? 'Grátis' : cart.total_shipping | money_with_sign) : 'n/a') : cart.total_shipping | money_with_sign }}</dd>

								{% if not store.taxes_included or cart.total_taxes == 0 %}
									<dt>{{ user.l10n.tax_name }}</dt>
									<dd class="text-dark price">{{ cart.total_taxes | money_with_sign }}</dd>
								{% endif %}
							</dl>

							<hr>

							<dl class="dl-horizontal text-left h3 margin-bottom-0">
                                <dt>Total</dt>
                                <dd class="bold price">{{ cart.total | money_with_sign }}</dd>
                            </dl>

                            {% if store.taxes_included and cart.total_taxes > 0 %}
                                <div class="text-right text-left-xs">
                                    <small class="text-muted">Inclui {{ user.l10n.tax_name }} a {{ cart.total_taxes | money_with_sign }}</small>
                                </div>
                            {% endif %}

							<hr>

							<div class="coupon-code">
                                <label for="cupao">Cupão de desconto</label>

                                <div class="coupon-code-input {{ not cart.coupon ? '' : 'hidden' }}">
									<div class="input-group">
                                    	<input type="text" value="{{ cart.coupon.code }}" class="form-control" id="cupao" name="cupao" placeholder="Inserir código">
										<span class="input-group-btn">
                                            <button type="submit" formaction="{{ site_url('cart/coupon/add') }}" class="btn btn-default">Aplicar</button>
                                        </span>
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

							<button type="submit" formaction="{{ site_url('cart/post/data') }}" class="btn btn-block btn-primary btn-lg margin-top"><i class="fa fa-fw fa-shopping-cart"></i> Comprar</button>
						</div>

						<div class="well text-center margin-bottom-0 hidden-md hidden-lg">
							<h3 class="margin-bottom-md">Questões?</h3>
							<p class="margin-bottom-md">Se tiver dúvidas sobre sua compra, ou quaisquer outras questões, <a href="{{ site_url('contact') }}">entre em contacto</a>.</p>
						</div>

					</div>

				</div>
			{{ form_close() }}

			{% if store.settings.cart.related_products_intelligent %}
				<div class="row">
					<div class="col-xs-12">
						<div class="related-products margin-top hidden" data-load="related-products" data-products="{{ cart.items|column('product_id')|json_encode }}" data-num-products="4" data-products-per-row="4" data-css-class-wrapper="cart-related-products" data-type="intelligent">
							<div class="text-center">
								<h3>Outros clientes também compraram</h3>
								<div class="related-products-placement product-list-no-hover margin-top"></div>
							</div>
						</div>
					</div>
				</div>
			{% endif %}

		{% else %}
			<div class="row">
				<div class="col-md-8 col-md-offset-2">
					<div class="well text-center margin-top">
						<h3 class="normal">Não existem produtos no carrinho</h3>
						<p>Descubra os nossos <a href="{{ site_url('new') }}" class="text-underline">produtos mais recentes</a> ou veja as nossas <a href="{{ site_url('sales') }}" class="text-underline">promoções</a>.</p>
					</div>
				</div>
			</div>
		{% endif %}

	</div>

{% endblock %}
