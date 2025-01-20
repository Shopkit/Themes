{#
Description: Shopping cart page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="container">

		<h1 class="margin-bottom">{{ 'lang.storefront.cart.title'|t }}</h1>

		<ol class="breadcrumb margin-bottom hidden-xs">
			<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a></li>
			<li class="active">{{ 'lang.storefront.cart.title'|t }}</li>
		</ol>

		{% if cart.items %}

			{% if errors.form %}
				<div class="callout callout-danger {{ store.theme_options.well_danger_shadow }}">
					<h4>{{ 'lang.storefront.layout.events.form.error'|t }}</h4>
					{{ errors.form }}
				</div>
			{% endif %}

			{% if warnings.form %}
				<div class="callout callout-warning {{ store.theme_options.well_warning_shadow }}">
					<h4>{{ 'lang.storefront.layout.events.form.warning'|t }}</h4>
					{{ warnings.form }}
				</div>
			{% endif %}

			{% if success.form %}
				<div class="callout callout-success {{ store.theme_options.well_success_shadow }}">
					<h4>{{ 'lang.storefront.layout.events.form.success'|t }}</h4>
					{{ success.form }}
				</div>
			{% endif %}

			{{ generic_macros.cart_notice() }}

			{{ form_open('cart/post/data', {'class' : 'form'}) }}
				<div class="row">
					<div class="col-md-8 col-lg-8">

						<div class="table-cart-products well-featured {{ store.theme_options.well_featured_shadow }} margin-bottom">
							<div class="table-responsive table-cart-responsive form-inline">
								<table class="table table-cart">

									<tbody>

										{% for item in cart.items %}
											<tr data-product="{{ item.product_id }}" data-product-option="{{ item.options|keys[0] }}">
												<td class="cart-img">
													<a href="{{ item.product_url }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ item.image }}" alt="{{ item.title|e_attr }}" title="{{ item.title|e_attr }}" class="border-radius lazy"></a>
												</td>

												<td>
													<h4 class="normal margin-top-0 margin-bottom-xxs"><a href="{{ item.product_url }}">{{ item.title }}</a></h4>

													<div class="unit-price text-muted small">{{ 'lang.storefront.cart.product.unit_price.label'|t }} <span class="semi-bold">{{ item.price | money_with_sign }}</span></div>

													{% if item.extras %}
														<div class="items-extra-wrapper">
															<a href="#item-extra-{{ item.item_id }}" class=" margin-top-xxs inline-block small text-default" data-toggle="collapse" href="#item-extra-{{ item.item_id }}">{{ item.extras|length }} {{ item.extras|length > 1 ? 'lang.storefront.product.extra_options.plural.label'|t : 'lang.storefront.product.extra_options.singular.label'|t }} <span class="text-muted">({{ item.subtotal_extras > 0 ? item.subtotal_extras | money_with_sign : 'lang.storefront.cart.order_summary.shipping_total.free'|t }})</span> <i class="fa fa-fw fa-angle-down" aria-hidden="true"></i></a>

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

												<td class="text-right">
													<h4 class="margin-top-0 margin-bottom-sm bold price">{{ item.subtotal | money_with_sign }}</h4>

													<div class="form-group">
														<label class="hidden-xs" for="qty-{{ item.item_id }}">{{ 'lang.storefront.cart.product.qty'|t }}&nbsp;</label><input class="form-control input-sm input-qtd" type="number" value="{{ item.qty }}" name="qtd[{{ item.item_id }}]" {% if item.stock_sold_single %} data-toggle="tooltip" data-placement="left" title="{{ 'lang.storefront.cart.product_limit.tooltip'|t }}" readonly {% endif %} id="qty-{{ item.item_id }}">
													</div>

													<span class="margin-left-xxs visible-xs-inline-block visible-sm-inline-block">&nbsp;<button type="submit" formaction="{{ site_url('cart/post/update') }}" class="btn btn-default {{ store.theme_options.button_default_shadow }} btn-sm"><i class="fa fa-refresh"></i></button></span>

													<a href="{{ item.remove_link }}" class="btn btn-link btn-sm text-default inline-block margin-left-xxs cart-remove-product-url"><i class="fa fa-trash"></i></a>
												</td>
											</tr>
										{% endfor %}

									</tbody>

								</table>

							</div>

							<footer>
								<button type="submit" formaction="{{ site_url('cart/post/update') }}" class="btn btn-default {{ store.theme_options.button_default_shadow }}"><i class="fa fa-fw fa-refresh"></i> {{ 'lang.storefront.cart.update.button'|t }}</button> &nbsp;
								<button type="submit" formaction="{{ site_url('cart/post/data') }}" class="btn btn-primary {{ store.theme_options.button_primary_shadow }}"><i class="fa fa-fw fa-shopping-cart"></i> {{ 'lang.storefront.layout.button.buy'|t }}</button>
							</footer>
						</div>

						<div class="well well-default {{ store.theme_options.well_default_shadow }} text-center visible-md visible-lg">
							<h3 class="margin-bottom-md">{{ 'lang.storefront.cart.questions.title'|t }}</h3>
							<p class="margin-bottom-md">{{ 'lang.storefront.cart.questions.text'|t([site_url('contact')]) }}</p>
						</div>

					</div>

					<div class="order-resume-container col-sm-12 col-sm-offset-0 col-md-4 col-md-offset-0 col-lg-3 col-lg-offset-1">

						<div class="order-resume well well-default {{ store.theme_options.well_default_shadow }}">
							<h3 class="margin-bottom-sm margin-top-0 bordered">{{ 'lang.storefront.cart.order_summary.title'|t }}</h3>

							<dl class="dl-horizontal text-left margin-bottom-0">
								<dt class="bold">{{ 'lang.storefront.layout.subtotal.title'|t }}:</dt>
								<dd class="text-dark price">{{ cart.subtotal | money_with_sign }}</dd>

								{% if cart.coupon %}
									<dt>{{ 'lang.storefront.order.discount'|t }}</dt>
									<dd class="text-dark price">{{ cart.coupon.type == 'shipping' ? 'lang.storefront.cart.order_summary.free_shipping'|t : '- ' ~ cart.discount | money_with_sign }}</dd>
								{% endif %}

								{% set no_shipping_text = 'lang.storefront.cart.order_summary.shipping.calculating.text'|t ~ ' <span data-toggle="tooltip" data-placement="top" title="' ~ 'lang.storefront.cart.order_summary.shipping.calculating.tooltip'|t ~ '"><i class="fa fa-question-circle"></i></span>' %}
								<dt>{{ 'lang.storefront.cart.order_summary.shipping.title'|t }}</dt>
								<dd class="text-dark price total-shipping">{{ cart.shipping_methods ? (user.shipping_method ? (cart.coupon.type == 'shipping' or cart.total_shipping == 0 ? 'lang.storefront.cart.order_summary.shipping_total.free'|t : cart.total_shipping | money_with_sign) : no_shipping_text) : cart.total_shipping | money_with_sign }}</dd>

								{% if cart.total_payment %}
									<div class="flex">
										<dt>{{ 'lang.storefront.cart.order_summary.total_payment'|t }} <span data-toggle="tooltip" data-placement="top" title="{{ user.payment_method.title }}"><i class="fa fa-question-circle"></i></span></dt>
										<dd class="text-dark price">{{ cart.total_payment | money_with_sign }}</dd>
									</div>
								{% endif %}

								{% if not store.taxes_included or cart.total_taxes == 0 %}
									<dt>{{ user.l10n.tax_name }}</dt>
									<dd class="text-dark price">{{ cart.total_taxes | money_with_sign }}</dd>
								{% endif %}
							</dl>

							<hr>

							<dl class="dl-horizontal text-left h3 margin-bottom-0">
								<dt>{{ 'lang.storefront.order.total'|t }}</dt>
								<dd class="bold price">{{ cart.total | money_with_sign }}</dd>
							</dl>

							{% if store.taxes_included and cart.total_taxes > 0 %}
								<div class="text-right text-left-xs">
									<small class="text-muted">{{ 'lang.storefront.cart.order_summary.taxes_included'|t([user.l10n.tax_name, cart.total_taxes|money_with_sign]) }}</small>
								</div>
							{% endif %}

							<hr>

							<div class="coupon-code">
								<label for="cupao">{{ 'lang.storefront.cart.order_summary.coupon_code.title'|t }}</label>

								<div class="coupon-code-input {{ not cart.coupon ? '' : 'hidden' }}">
									<div class="input-group">
										<input type="text" value="{{ cart.coupon.code }}" class="form-control" id="cupao" name="cupao" placeholder="{{ 'lang.storefront.cart.order_summary.coupon_code.placeholder'|t }}">
										<span class="input-group-btn">
											<button type="submit" formaction="{{ site_url('cart/coupon/add') }}" class="btn btn-default {{ store.theme_options.button_default_shadow }}">{{ 'lang.storefront.cart.order_summary.coupon_code.button'|t }}</button>
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

							<button type="submit" formaction="{{ site_url('cart/post/data') }}" class="btn btn-block btn-primary {{ store.theme_options.button_primary_shadow }} btn-lg margin-top"><i class="fa fa-fw fa-shopping-cart"></i> {{ 'lang.storefront.layout.button.buy'|t }}</button>
						</div>

						<div id="payment-method-messaging-element"></div>

						<div class="well well-default {{ store.theme_options.well_default_shadow }} text-center margin-bottom-0 hidden-md hidden-lg">
							<h3 class="margin-bottom-md">{{ 'lang.storefront.cart.questions.title'|t }}</h3>
							<p class="margin-bottom-md">{{ 'lang.storefront.cart.questions.text'|t([site_url('contact')]) }}</p>
						</div>

					</div>

				</div>
			{{ form_close() }}

			{% if store.settings.cart.related_products_intelligent %}
				<div class="row">
					<div class="col-xs-12">
						<div class="related-products margin-top hidden" data-load="related-products" data-href="{{ site_url('related-products') }}" data-products="{{ cart.items|column('product_id')|json_encode }}" data-num-products="4" data-products-per-row="4" data-css-class-wrapper="cart-related-products" data-type="intelligent">
							<div class="text-center">
								<h3>{{ 'lang.storefront.cart.related_products.title'|t }}</h3>
								<div class="related-products-placement product-list-no-hover margin-top"></div>
							</div>
						</div>
					</div>
				</div>
			{% endif %}

		{% else %}
			<div class="row">
				<div class="col-md-8 col-md-offset-2">
					<div class="well well-default {{ store.theme_options.well_default_shadow }} text-center margin-top">
						<h3 class="normal">{{ 'lang.storefront.cart.no_products'|t }}</h3>
						<p>{{ 'lang.storefront.cart.no_products.discover'|t([site_url('new'), site_url('sales')]) }}</p>
					</div>
				</div>
			</div>
		{% endif %}

	</div>

{% endblock %}
