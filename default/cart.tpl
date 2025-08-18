{#
Description: Shopping cart page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<ul class="breadcrumb well-default">
		<li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
		<li class="active">{{ 'lang.storefront.cart.title'|t }}</li>
	</ul>

	<h1>{{ 'lang.storefront.cart.title'|t }}</h1>

	<br>

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

		{% if store.settings.rewards.active and cart.total_rewards_to_earn and store.settings.rewards.message_checkout %}
			<div class="alert alert-info">
				<i class="icon margin-right-xxs">{{ icons('trophy') }}</i>
				{{ store.settings.rewards.message_checkout|rewards_message(cart.total_rewards_to_earn) }}
			</div>
		{% endif %}

		{{ form_open('cart/post/data') }}

			<div class="table-responsive">
				<table class="table table-bordered table-cart well-featured {{ store.theme_options.well_featured_shadow }}">
					<thead>
						<tr>
							<th>{{ 'lang.storefront.account.orders.order.product.title'|t }}</th>
							<th>{{ 'lang.storefront.layout.product.quantity'|t }}</th>
							<th class="text-right">{{ 'lang.storefront.layout.subtotal.title'|t }}</th>
							<th class="text-center">{{ 'lang.storefront.layout.button.remove'|t }}</th>
						</tr>
					</thead>

					<tbody>

					{% for item in cart.items %}
						<tr data-product="{{ item.product_id }}" data-product-option="{{ item.options|keys[0] }}">
							<td>
								{% if item.image %}<img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ item.image }}" width="22" height="22" class="hidden-phone lazy"> {% endif %}

								{{ item.title }}

								<div class="unit-price text-muted small">{{ 'lang.storefront.cart.product.unit_price.label'|t }} <span class="semi-bold">{{ item.price | money_with_sign }}</span></div>

                                {% if item.extras %}
                                    <div class="items-extra-wrapper">
                                        <a href="#item-extra-{{ item.item_id }}" class=" margin-top-xxs inline-block small" data-toggle="collapse" href="#item-extra-{{ item.item_id }}">{{ item.extras|length }} {{ item.extras|length > 1 ? 'lang.storefront.product.extra_options.plural.label'|t : 'lang.storefront.product.extra_options.singular.label'|t }} <span class="text-muted">({{ item.subtotal_extras > 0 ? item.subtotal_extras | money_with_sign : 'lang.storefront.cart.order_summary.shipping_total.free'|t }})</span> {{ icons('angle-down') }}</a>

                                        <ul class="list-group extra-options collapse margin-bottom-0 margin-top-xs well-default {{ store.theme_options.well_default_shadow }}" id="item-extra-{{ item.item_id }}">
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
							<td><div class="form-inline"><input class="input-micro" type="number" value="{{ item.qty }}" name="qtd[{{ item.item_id }}]" {% if item.stock_sold_single %} data-toggle="tooltip" data-placement="bottom" title="{{ 'lang.storefront.cart.product_limit.tooltip'|t }}" readonly {% endif %}> <button type="submit" formaction="{{ site_url('cart/post/update') }}" class="btn btn-default {{ store.theme_options.button_default_shadow }} btn-small">{{ 'lang.storefront.cart.change.button'|t }}</button></div></td>
							<td class="price text-right">{{ item.subtotal | money_with_sign }}</td>
							<td class="text-center"><a href="{{ item.remove_link }}" class="btn btn-small cart-remove-product-url">{{ icons('trash') }}&nbsp;<span class="hidden-phone">{{ 'lang.storefront.layout.button.remove'|t }}</span></a></td>
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
						<input type="text" value="{{ cart.coupon.code }}" class="form-control" id="cupao" name="cupao" placeholder="{{ 'lang.storefront.cart.order_summary.coupon_code.placeholder'|t }}">
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

			{% if user.is_logged_in and store.settings.rewards.active and user.rewards %}
				<div class="cart-rewards">
					<h4>{{ rewards_label }}</h4>
					<p class="{{ not cart.rewards ? '' : 'hidden' }}">{{ store.settings.rewards.message_redeem_checkout|rewards_message(user.rewards) }}</p>

					<div class="cart-rewards-input {{ not cart.rewards ? '' : 'hidden' }}">
						<div class="input-append">
							<input type="number" value="" class="form-control" id="rewards" name="rewards" placeholder="{{ 'lang.storefront.cart.order_summary.cart_rewards.placeholder'|t([rewards_label|lower]) }}" min="0" max="{{ user.rewards }}">
							<button type="submit" formaction="{{ site_url('cart/rewards/add') }}" class="btn btn-default {{ store.theme_options.button_default_shadow }}">{{ 'lang.storefront.cart.order_summary.cart_rewards.button'|t }}</button>
						</div>
					</div>

					<div class="cart-rewards-label margin-top-xxs {{ cart.rewards ? '' : 'hidden' }}">
						<span class="label label-light-bg h5">
							{{ icons('trophy') }}
							<span class="cart-rewards-text">{{ cart.rewards.rewards|rewards_label }}</span>
							<a href="{{ site_url('cart/rewards/remove') }}" class="btn-close">{{ icons('times') }}</a>
						</span>
					</div>
				</div>

			{% endif %}

			<hr>

			<button type="submit" formaction="{{ site_url('cart/post/data') }}" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} btn-large">{{ 'lang.storefront.layout.button.checkout'|t }} ›</button>

		{{ form_close() }}

		{% if store.settings.cart.related_products_intelligent %}
			<div class="related-products margin-top hidden" data-load="related-products" data-href="{{ site_url('related-products') }}" data-products="{{ cart.items|column('product_id')|json_encode }}" data-num-products="3" data-products-per-row="3" data-css-class-wrapper="cart-related-products" data-type="intelligent">
				<div class="text-center">
					<h3 class="products-title margin-bottom">{{ 'lang.storefront.cart.related_products.title'|t }}</h3>
					<div class="related-products-placement"></div>
				</div>
			</div>
		{% endif %}

	{% else %}

		<div class="alert alert-info">
			{{ 'lang.storefront.cart.no_products'|t }}.
		</div>

	{% endif %}

{% endblock %}
