{#
Description: Wishlist account page
#}

{% import 'account.tpl' as account_macros %}
{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="{{ layout_container }}">
		<div class="row">
			<div class="col-sm-3">
				<div class="panel well-featured {{ store.theme_options.well_featured_shadow }} panel-default margin-bottom">
					<div class="panel-heading">
						<a href="{{ site_url('account') }}" class="link-inherit">{{ 'lang.storefront.account.my_account'|t }}</a>
					</div>

					{{ account_macros.account_navigation() }}

				</div>
			</div>

			<div class="col-sm-8 col-sm-offset-1">
				<h1 class="margin-top-0 margin-bottom">{{ 'lang.storefront.layout.greetings'|t }} <strong>{{ user.name|first_word }}</strong>.</h1>

				<h3 class="margin-top-0 text-muted-dark light">{{ 'lang.storefront.layout.wishlist.title'|t }}</h3>
				{% if user.wishlist %}
					<div class="table-responsive">
						<table class="table table-cart vertical-align">
							<tbody>
								{% for product in user.wishlist %}
									<tr>
										<td class="cart-img">
											<a href="{{ product.url }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image }}" alt="{{ product.title|e_attr }}" title="{{ product.title|e_attr }}" class="border-radius lazy"></a>
										</td>
										<td>
											<h4 class="normal margin-top-0 margin-bottom-xxs"><a href="{{ product.url }}">{{ product.title }}</a></h4>

											{% if (product.stock_qty and product.stock_show_info) %}
												<small>{{ 'lang.storefront.account.wishlist.stock_units'|t([product.stock_qty]) }}</small><br>
											{% endif %}

											<small class="text-muted">{{ 'lang.storefront.account.wishlist.add_date'|t([product.created_at|format_datetime('long','none')]) }}</small>
										</td>
										<td class="cart-actions">
											<a href="{{ product.remove_wishlist_url }}" class="text-muted small" title="{{ 'lang.storefront.layout.button.remove'|t }}"><i class="fa fa-fw fa-trash fa-lg"></i></a> &nbsp;
		                                    <a href="{{ product.add_cart_url }}" class="text-muted small" title="{{ 'lang.storefront.layout.button.add_to_cart'|t }}"><i class="fa fa-fw fa-cart-plus fa-lg"></i></a>
										</td>
									</tr>
								{% endfor %}
							</tbody>
						</table>
					</div>
				{% else %}
					<p>{{ 'lang.storefront.account.wishlist.no_products'|t }}</p>
				{% endif %}
			</div>
		</div>
	</div>

{% endblock %}