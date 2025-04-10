{#
Description: Shopping cart page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="content">
		<section class="page">

			<p class="breadcrumbs">
				<a href="{{ site_url() }}">{{ icons('home') }}</a> ›
				{{ 'lang.storefront.cart.title'|t }}
			</p><br>

			<h1>{{ 'lang.storefront.cart.title'|t }}</h1>

			<hr>

			{% if cart.items %}

				{% if errors.form %}
					<div class="alert alert-error {{ store.theme_options.well_danger_shadow }}">
						<button type="button" class="close" data-dismiss="alert">×</button>
						<h5>{{ 'lang.storefront.layout.events.form.error'|t }}</h5>
						{{ errors.form }}
					</div>
				{% endif %}

				{% if warnings.form %}
					<div class="alert alert-warning {{ store.theme_options.well_warning_shadow }}">
						<button type="button" class="close" data-dismiss="alert">×</button>
						<h5>{{ 'lang.storefront.layout.events.form.warning'|t }}</h5>
						{{ warnings.form }}
					</div>
				{% endif %}

				{% if success.form %}
					<div class="alert alert-success {{ store.theme_options.well_success_shadow }}">
						<button type="button" class="close" data-dismiss="alert">×</button>
						<h5>{{ 'lang.storefront.layout.events.form.success'|t }}</h5>
						{{ success.form }}
					</div>
				{% endif %}

				{{ generic_macros.cart_notice() }}

				{{ form_open('cart/post/data') }}

					<div class="table-responsive">
						<table class="table table-bordered table-cart well-featured {{ store.theme_options.well_featured_shadow }}">
							<thead>
								<tr>
									<th>{{ 'lang.storefront.account.orders.order.product.title'|t }}</th>
									<th>{{ 'lang.storefront.layout.product.quantity'|t }}</th>
									<th style="text-align:right;">{{ 'lang.storefront.layout.subtotal.title'|t }}</th>
									<th style="text-align:center;">{{ 'lang.storefront.layout.button.remove'|t }}</th>
								</tr>
							</thead>

							<tbody>

							{% for item in cart.items %}
								<tr data-product="{{ item.product_id }}" data-product-option="{{ item.options|keys[0] }}">
									<td>
										{{ item.title }}

										<div class="unit-price text-muted small">{{ 'lang.storefront.cart.product.unit_price.label'|t }} <span class="semi-bold">{{ item.price | money_with_sign }}</span></div>

										{% if item.extras %}
											<div class="items-extra-wrapper">
												<a href="#item-extra-{{ item.item_id }}" class=" margin-top-xxs inline-block small text-default" data-toggle="collapse" href="#item-extra-{{ item.item_id }}">{{ item.extras|length }} {{ item.extras|length > 1 ? 'lang.storefront.product.extra_options.plural.label'|t : 'lang.storefront.product.extra_options.singular.label'|t }} <span class="text-muted">({{ item.subtotal_extras > 0 ? item.subtotal_extras | money_with_sign : 'lang.storefront.cart.order_summary.shipping_total.free'|t }})</span> {{ icons('angle-down') }}</a>

												<ul class="list-group extra-options collapse margin-bottom-0 margin-top-xs" id="item-extra-{{ item.item_id }}">
													{% for key, extra in item.extras %}
														<li class="list-group-item">
															<div class="list-group-item-header">
																<h6 class="margin-0 semi-bold">{{ extra.title }}</h6>
																<span class="badge badge-transparent normal"><span class="text-muted">{{ extra.qty }}x</span> {{ extra.price ?  extra.price | money_with_sign : 'lang.storefront.cart.order_summary.shipping_total.free'|t }}</span>
															</div>
															<div class="text-truncate small margin-top-xxs" style="max-width: 200px; min-width: 100%" data-toggle="tooltip" title="{{ extra.value }}">{{ extra.value }}</div>
														</li>
													{% endfor %}
												</ul>
											</div>
										{% endif %}
									</td>
									<td><div class="form-inline"><input class="span1" type="number" value="{{ item.qty }}" name="qtd[{{ item.item_id }}]" {% if item.stock_sold_single %} data-toggle="tooltip" data-placement="bottom" title="{{ 'lang.storefront.cart.product_limit.tooltip'|t }}" readonly {% endif %}> <button type="submit" formaction="{{ site_url('cart/post/update') }}" class="btn-small btn-primary {{ store.theme_options.button_primary_shadow }}">{{ icons('sync') }}</button></div></td>
									<td class="price text-right">{{ item.subtotal | money_with_sign }}</td>
									<td style="text-align:center;"><a href="{{ item.remove_link }}" class="btn-small btn-primary {{ store.theme_options.button_primary_shadow }} cart-remove-product-url">{{ icons('trash') }}</a></td>
								</tr>
							{% endfor %}

							</tbody>

							<tfoot>
								<tr>
									<td class="subtotal">{{ 'lang.storefront.layout.subtotal.title'|t }}</td>
									<td colspan="2" class="subtotal price text-right">{{ cart.subtotal | money_with_sign }}</td>
									<td class="subtotal">&nbsp;</td>
								</tr>
							</tfoot>
						</table>
					</div>

					<hr>

					<div class="coupon-code">
						<h4>{{ 'lang.storefront.cart.order_summary.coupon_code.title'|t }}</h4>

						<div class="coupon-code-input {{ not cart.coupon ? '' : 'hidden' }}">
							<div class="input-append">
								<input type="text" value="{{ cart.coupon.code }}" class="form-control margin-bottom-0" id="cupao" name="cupao" placeholder="{{ 'lang.storefront.cart.order_summary.coupon_code.placeholder'|t }}">
								<button type="submit" formaction="{{ site_url('cart/coupon/add') }}" class="btn btn-default {{ store.theme_options.button_default_shadow }}">{{ 'lang.storefront.cart.order_summary.coupon_code.button'|t }}</button>
							</div>
						</div>

						<div class="coupon-code-label margin-top-xxs {{ cart.coupon ? cart.coupon.code : 'hidden' }}">
							<span class="label label-light-bg h5">
								{{ icons('tags') }}
								<span class="coupon-code-text">{{ cart.coupon.code }}</span>
								<a href="{{ site_url('cart/coupon/remove') }}" class="btn-close">{{ icons('times') }}</a>
							</span>
						</div>
					</div>

					<hr>

					<div id="payment-method-messaging-element"></div>

					<button type="submit" formaction="{{ site_url('cart/post/data') }}" class="button btn-primary {{ store.theme_options.button_primary_shadow }}" style="width:200px">
						{{ icons('angle-right') }}
						<span>{{ 'lang.storefront.layout.button.checkout'|t }}</span>
					</button>

				{{ form_close() }}

			{% else %}

				<p>{{ 'lang.storefront.cart.no_products'|t }}.</p>

			{% endif %}

		</section>
	</div>

	{% if cart.items %}
		{% if store.settings.cart.related_products_intelligent %}
			<div class="related-products margin-top hidden" data-load="related-products" data-href="{{ site_url('related-products') }}" data-products="{{ cart.items|column('product_id')|json_encode }}" data-num-products="6" data-products-per-row="4" data-css-class-wrapper="cart-related-products" data-type="intelligent">
				<div class="wide text-center">
					<h1 class="wide">{{ 'lang.storefront.cart.related_products.title'|t }}</h1>
				</div>
				<div class="related-products-placement"></div>
			</div>
		{% endif %}
	{% endif %}

{% endblock %}
