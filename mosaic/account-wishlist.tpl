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
					<a href="{{ site_url() }}">{{ icons('home') }}</a> ›
					<a href="{{ site_url('account') }}">{{ 'lang.storefront.account.my_account'|t }}</a> ›
					{{ 'lang.storefront.layout.wishlist.title'|t }}
				</p><br>

				<h1>{{ 'lang.storefront.layout.greetings'|t }} <strong>{{ user.name|first_word }}</strong>.</h1>

				<h3>{{ 'lang.storefront.layout.wishlist.title'|t }}</h3>

				{% if user.wishlist %}
					<div class="table-responsive">
						<table class="table table-vertical-align">
							<tbody>
								{% for product in user.wishlist %}
									<tr>
										<td width="60">
											<a href="{{ product.url }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image }}" alt="{{ product.title|e_attr }}" title="{{ product.title|e_attr }}" width="60" class="lazy"></a>
										</td>
										<td>
											<p class="margin-bottom-0"><a href="{{ product.url }}">{{ product.title }}</a></p>

											{% if (product.stock_qty and product.stock_show_info) %}
												<small>{{ 'lang.storefront.account.wishlist.stock_units'|t([product.stock_qty]) }}</small><br>
											{% endif %}

											 <small class="text-muted">{{ 'lang.storefront.account.wishlist.add_date'|t([product.created_at|format_datetime('long','none')]) }}</small>
										</td>
										<td class="text-right nowrap">
		                                    <a href="{{ product.remove_wishlist_url }}" class="text-muted small" title="{{ 'lang.storefront.layout.button.remove'|t }}">{{ icons('trash', 'fa-lg') }}</a> &nbsp;
		                                    <a href="{{ product.add_cart_url }}" class="text-muted small" title="{{ 'lang.storefront.layout.button.add_to_cart'|t }}">{{ icons('cart-plus', 'fa-lg') }}</a>
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