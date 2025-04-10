{#
Template Name: Shopkit Default Template
Author: Shopkit
Version: 4.0
Description: This is the base layout. It is included in every page with this code {% extends 'base.tpl' %}
Github: https://github.com/Shopkit/Default
#}

{% import 'macros.tpl' as generic_macros %}

{# Vars #}
{% set products_per_page_home = store.products_per_page_home ?: 9 %}
{% set products_per_page_catalog = store.products_per_page_catalog ?: 18 %}
{% set categories_per_page = store.categories_per_page ?: 18 %}
{% set brands_per_page = store.brands_per_page ?: 36 %}
{% set show_search_suggestions = store.theme_options.show_search_suggestions == 'block' ? '' : 'remove-typeahead' %}

<!DOCTYPE html>
<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="pt"> <![endif]-->
<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="pt"> <![endif]-->
<!--[if IE 8]>    <html class="no-js lt-ie9" lang="pt"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
<head>
	<meta charset="utf-8">
	<title>{{ title }}</title>

	<meta name="description" content="{{ description|e_attr }}">
	<meta name="keywords" content="{{ tags|e_attr }}">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

	{% if store.show_branding %}
		<meta name="author" content="Shopkit">
	{% endif %}

	{% if store.translate_meta %}
		<meta name="google-translate-customization" content="{{ store.translate_meta }}">
	{% endif %}

	<link rel="canonical" href="{{ canonical_url }}" />

	{% if store.favicon %}
		<link rel="shortcut icon" href="{{ store.favicon }}">
	{% endif %}

	<link rel="alternate" href="{{ site_url('rss') }}" type="application/rss+xml" title="{{ store.name|e_attr }}">

	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="{{ fonts }}" rel="stylesheet">

	{{ icon_library }}
	<link id="theme-css" rel="stylesheet" href="{{ store.assets.css }}">

	{% if store.custom_css %}
		<style>{{ store.custom_css }}</style>
	{% endif %}

	<script src="{{ assets_url('assets/common/vendor/modernizr/2.7.1/modernizr.min.js') }}"></script>
	<script src="{{ assets_url('assets/common/vendor/jquery/1.9.1/jquery.min.js') }}"></script>

	{{ head_content }}

</head>
<body class="{{ css_class }} {{ store.theme_options.header_position }} {{ store.theme_options.icon_library }}">

	<header>
		<div class="container">
			<div class="header-inner">
				{% if store.notice %}
					<div class="store-notice">{{ store.notice }}</div>
				{% endif %}

				<div class="clearfix">
					{% if store.logo %}
						<p class="pull-left logo"><a href="{{ site_url() }}"><img src="{{ store.logo }}" alt="{{ store.name|e_attr }}"></a></p>
					{% else %}
						<h1 class="pull-left logo"><a href="{{ site_url() }}">{{ store.name }}</a></h1>
					{% endif %}

					<!-- CART -->
					<aside class="pull-right cart-header">
						<div class="btn-group">
							<a class="btn btn-primary {{ store.theme_options.button_primary_shadow }}" href="{{ site_url('cart') }}">{{ icons('shopping-cart', 'fa-lg') }} {{ 'lang.storefront.cart.title'|t }} ({{ cart.item_count }})</a>
							<button data-toggle="dropdown" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} dropdown-toggle"><span class="caret"></span></button>
							<ul class="dropdown-menu well-default {{ store.theme_options.well_default_shadow }}">
								{% if cart.items %}
									{% for item in cart.items %}
										<li>
											<a href="{{ item.product_url }}">
												<strong>{{ item.qty }}x</strong> {{ item.title }}
												{% if item.extras %}
													<div class="items-extra-wrapper">
														{% set item_extra_tip = '' %}
														{% for key, extra in item.extras %}
															{% set item_extra_tip = item_extra_tip ~ extra.title ~': '~ extra.value ~ (loop.last ? '' : '</br>') %}
														{% endfor %}
														<span href="#item-extra-{{ item.item_id }}" class="inline-block small" data-toggle="tooltip" title="{{ item_extra_tip }}" data-html="true">{{ item.extras|length }} {{ item.extras|length > 1 ? 'lang.storefront.product.extra_options.plural.label'|t : 'lang.storefront.product.extra_options.singular.label'|t }} <span class="text-muted">({{ item.subtotal_extras > 0 ? item.subtotal_extras | money_with_sign : 'lang.storefront.cart.order_summary.shipping_total.free'|t }})</span></span>
													</div>
												{% endif %}
												<strong class="price">{{ item.price | money_with_sign }}</strong>
											</a>
										</li>
									{% endfor %}
								{% else %}
									<li><a>{{ 'lang.storefront.cart.no_products'|t }}</a></li>
								{% endif %}
							</ul>
						</div>

						<p class="cart-header-totals">
							{% if store.settings.cart.users_registration != 'disabled' %}
								<span class="pull-left">
									{% if user.is_logged_in %}
										<a href="{{ site_url('account') }}" class="link-account">{{ icons('user') }} {{ 'lang.storefront.layout.greetings'|t }} <strong>{{ user.name|first_word }}</strong></a>
									{% else %}
										<a href="{{ site_url('signin') }}" class="link-signin">{{ icons('sign-in') }} {{ 'lang.storefront.login.signin.title'|t }}</a>
									{% endif %}
								</span>
							{% endif %}
							<span class="pull-right"><a href="{{ site_url('cart') }}" class="text-default">{{ 'lang.storefront.order.total'|t }}: <strong>{{ cart.subtotal | money_with_sign }}</strong></a></span>
						</p>
					</aside>
					<!-- END CART -->
				</div>

				<div id="nav-spacer" class="hidden"></div>

				<div class="navbar {{ store.theme_options.header_position }}">
					<div class="navbar-inner">
						<div class="container">
							{% if apps.google_translate %}
								{{ generic_macros.google_translate(apps.google_translate, 'hidden-desktop') }}
							{% endif %}
							<a class="btn btn-default btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
								{{ icons('bars', 'fa-lg') }}
							</a>
							<div class="nav-collapse trigger-priority-nav">
								<ul class="nav">
									{% for primary_navigation in store.navigation.primary %}
										<li class="menu-{{ primary_navigation.menu_text|slug }}"><a href="{{ primary_navigation.menu_url }}" {{ primary_navigation.target_blank ? 'target="_blank"' }}>{{ primary_navigation.menu_text }}</a></li>
										<li class="divider-vertical divider-{{ primary_navigation.menu_text|slug }}"></li>
									{% endfor %}
								</ul>
								{% if store.theme_options.show_search %}
									<form action="{{ site_url('search') }}" class="navbar-search pull-right {{ show_search_suggestions }}">
										<input type="text" name="q" value="{{ search ? search.query }}" placeholder="{{ 'lang.storefront.layout.header.search'|t }}" class="search-query span2">
									</form>
								{% endif %}
								{% if apps.google_translate %}
									{{ generic_macros.google_translate(apps.google_translate, 'visible-desktop') }}
								{% endif %}
							</div>
						</div>
					</div>
				</div>

				{{ generic_macros.gallery() }}
			</div>
		</div>
	</header>

	<div class="main" role="main">
		<div class="container">

			<div class="row show-grid">

				<aside class="span3 col-left">

					{% if (current_page == 'cart' or current_page == 'data' or current_page == 'payment' or current_page == 'confirm') and cart.items %}
						<section class="order-resume">
							<h3>{{ 'lang.storefront.cart.order_summary.title'|t }}</h3>

							<dl class="dl-horizontal text-left margin-bottom-0">

								<div class="cart-line">
									<dt class="bold">{{ 'lang.storefront.layout.subtotal.title'|t }}</dt>
									<dd class="bold">{{ cart.subtotal | money_with_sign }}</dd>
								</div>

								{% if cart.coupon %}
									<div class="cart-line">
										<dt>{{ 'lang.storefront.order.discount'|t }}</dt>
										<dd class="bold">{{ cart.coupon.type == 'shipping' ? 'lang.storefront.cart.order_summary.free_shipping'|t : '- ' ~ cart.discount | money_with_sign }}</dd>
									</div>
								{% endif %}

								<div class="shipping">
									{% set no_shipping_text = 'lang.storefront.cart.order_summary.shipping.calculating.text'|t ~ ' <span data-toggle="tooltip" data-placement="top" title="' ~ 'lang.storefront.cart.order_summary.shipping.calculating.tooltip'|t ~ '">'~ icons('question-circle') ~'</span>' %}
									<div class="cart-line">
										<dt>{{ 'lang.storefront.cart.order_summary.shipping.title'|t }}</dt>
										<dd class="bold shipping-value">{{ cart.shipping_methods ? (user.shipping_method ? (cart.coupon.type == 'shipping' or cart.total_shipping == 0 ? 'lang.storefront.cart.order_summary.shipping_total.free'|t : cart.total_shipping | money_with_sign) : no_shipping_text) : cart.total_shipping | money_with_sign }}</dd>
									</div>
								</div>

								<div class="cart-line payment-tax {{ not cart.total_payment ? 'hidden' }}">
									<dt>{{ 'lang.storefront.cart.order_summary.total_payment'|t }} <span data-toggle="tooltip" data-placement="top" title="{{ user.payment_method.title }}">{{ icons('question-circle') }}</span></dt>
									<dd class="bold payment-tax-value">{{ cart.total_payment | money_with_sign }}</dd>
								</div>

								{% if not store.taxes_included or cart.total_taxes == 0 %}
									<div class="cart-line total-taxes">
										<dt>{{ user.l10n.tax_name }}</dt>
										<dd class="bold total-taxes-value">{{ cart.total_taxes | money_with_sign }}</dd>
									</div>
								{% endif %}
							</dl>

							<hr>

							<dl class="dl-horizontal text-left h4 margin-bottom-0 cart-line total">
								<dt>{{ 'lang.storefront.order.total'|t }}</dt>
								<dd class="bold price total-value">{{ cart.total | money_with_sign }}</dd>
							</dl>

							{% if store.taxes_included and cart.total_taxes > 0 %}
								<div class="text-right total-taxes text-left-xs">
									<small class="text-muted">{{ 'lang.storefront.cart.order_summary.taxes_included'|t([user.l10n.tax_name, cart.total_taxes|money_with_sign]) }}</small>
								</div>
							{% endif %}

							<hr>

						</section>

						<div id="payment-method-messaging-element"></div>
					{% endif %}

					{% if user.is_logged_in %}
						<section class="account-menu">
							<h3><a href="{{ site_url('account') }}">{{ 'lang.storefront.account.my_account'|t }}</a></h3>

							<nav class="normal">
								<ul>
									<li><a href="{{ site_url('account/orders')}}" class="list-group-item {{ current_page == 'account-orders' ? 'active' }}">{{ icons('shopping-bag', 'text-muted') }} {{ 'lang.storefront.layout.orders.title'|t }}</a></li>
									<li><a href="{{ site_url('account/profile')}}" class="list-group-item {{ current_page == 'account-profile' ? 'active' }}">{{ icons('user', 'text-muted') }} {{ 'lang.storefront.layout.client.title'|t }}</a></li>
									<li><a href="{{ site_url('account/wishlist')}}" class="list-group-item {{ current_page == 'account-wishlist' ? 'active' }}">{{ icons('heart', 'text-muted') }} {{ 'lang.storefront.layout.wishlist.title'|t }}</a></li>
									<li><a href="{{ site_url('account/logout')}}" class="list-group-item">{{ icons('sign-out', 'text-muted') }} {{ 'lang.storefront.layout.logout.title'|t }}</a></li>
								</ul>
							</nav>
						</section>
					{% endif %}

					<h3>{{ 'lang.storefront.macros.products.title'|t }}</h3>

					<nav>
						<ul>
							{% for catalog_menu in store.navigation.catalogs_menus %}
								<li class="menu-{{ catalog_menu.menu_item }} {{ current_page == catalog_menu.menu_item ? 'active' }} {{ store.theme_options['show_menu_' ~ catalog_menu.menu_item] ? '' : 'hidden' }}">
									<h4>
										<a href="{{ catalog_menu.menu_url }}">{{ ('lang.storefront.' ~ catalog_menu.menu_item ~ '.title')|t }}</a>
									</h4>
								</li>
							{% endfor %}

							{% for products_category in categories %}
								<li class="{{ (category.id == products_category.id) ? 'active' }} {{ 'menu-' ~ products_category.handle }}">

									{% if products_category.children %}
										<h4 data-toggle="collapse" data-target="{{ '#category_' ~ products_category.id }}">
											<a href="#" data-href="{{ products_category.url }}">{{ products_category.title }} {{ icons('angle-down') }}</a>
										</h4>

										<ul id="{{ 'category_' ~ products_category.id }}" class="sub-categories collapse {{ (category.parent == products_category.id or category.id == products_category.id) ? 'in' }}">
											{% for sub_category in products_category.children %}
												<li class="{{ (category.id== sub_category.id) ? 'active' }} {{ 'menu-' ~ sub_category.handle }}">

													{% if sub_category.children %}
														<h5 data-toggle="collapse" data-target="{{ '#sub_category_' ~ sub_category.id }}">
															<a href="#" data-href="{{ sub_category.url }}">{{ sub_category.title }} {{ icons('angle-down') }}</a>
														</h5>

														<ul id="sub_category_{{ sub_category.id }}" class="sub-subcategories collapse {{ (category.parent == sub_category.id or category.id == sub_category.id) ? 'in' }}">
															{% for children in sub_category.children %}
																<li class="{{ (category.id== children.id) ? 'active' }} {{ 'menu-' ~ children.handle }}">
																	<a href="{{ children.url }}">{{ children.title }}</a>
																</li>
															{% endfor %}
														</ul>
													{% else %}
														<h5>
															<a href="{{ sub_category.url }}">{{ sub_category.title }}</a>
														</h5>
													{% endif %}
												</li>
											{% endfor %}
										</ul>
									{% else %}
										<h4>
											<a href="{{ products_category.url }}">{{ products_category.title }}</a>
										</h4>
									{% endif %}
								</li>
							{% endfor %}
						</ul>
					</nav>

					{% if store.navigation.secondary %}
						<section class="pages">
							<h3>{{ 'lang.storefront.layout.menu.title'|t }}</h3>

							<nav class="normal">
								<ul>
									{% for secondary_navigation in store.navigation.secondary %}
										<li><a href="{{ secondary_navigation.menu_url }}" class="menu-{{ secondary_navigation.menu_text|slug }}" {{ secondary_navigation.target_blank ? 'target="_blank"' }}>{{ secondary_navigation.menu_text }}</a></li>
									{% endfor %}
								</ul>
							</nav>
						</section>
					{% endif %}

					<section class="social hidden-phone">
						<h3>{{ 'lang.storefront.home.block.social.title'|t }}</h3>

						<nav class="normal social">
							<ul>
								{% if store.facebook %}
									<li class="facebook"><a target="_blank" href="{{ store.facebook }}">{{ icons('facebook-f', 'fa-lg') }}{{ 'lang.storefront.layout.social.facebook'|t }}</a></li>
								{% endif %}
								{% if store.twitter %}
									<li class="twitter"><a target="_blank" href="{{ store.twitter }}">{{ icons('twitter', 'fa-lg') }}{{ 'lang.storefront.layout.social.twitter'|t }}</a></li>
								{% endif %}
								{% if store.instagram %}
									<li class="instagram"><a target="_blank" href="{{ store.instagram }}">{{ icons('instagram', 'fa-lg') }}{{ 'lang.storefront.layout.social.instagram'|t }}</a></li>
								{% endif %}
								{% if store.pinterest %}
									<li class="pinterest"><a target="_blank" href="{{ store.pinterest }}">{{ icons('pinterest', 'fa-lg') }}{{ 'lang.storefront.layout.social.pinterest'|t }}</a></li>
								{% endif %}
								{% if store.youtube %}
									<li class="youtube"><a target="_blank" href="{{ store.youtube }}">{{ icons('youtube', 'fa-lg') }}{{ 'lang.storefront.layout.social.youtube'|t }}</a></li>
								{% endif %}
								{% if store.linkedin %}
									<li class="linkedin"><a target="_blank" href="{{ store.linkedin }}">{{ icons('linkedin-square', 'fa-lg') }}{{ 'lang.storefront.layout.social.linkedin'|t }}</a></li>
								{% endif %}
								{% if store.tiktok %}
									<li class="tiktok"><a target="_blank" href="{{ store.tiktok }}">{{ icons('tiktok', 'fa-lg') }}{{ 'lang.storefront.layout.social.tiktok'|t }}</a></li>
								{% endif %}
								<li class="rss"><a href="{{ site_url('rss') }}">{{ icons('rss', 'fa-lg') }}{{ 'lang.storefront.layout.social.rss'|t }}</a></li>
							</ul>
						</nav>
					</section>

					{% if apps.newsletter %}
						<section class="newsletter hidden-phone">
							<h3>{{ 'lang.storefront.form.newsletter.label'|t }}</h3>
							<p>Inscreva-se na nossa newsletter para receber todas as novidades no seu e-mail.</p>

							<input name="nome_newsletter" type="text" placeholder="{{ 'lang.storefront.form.name.label'|t }}" class="span3" required>
							<input name="email_newsletter" type="text" placeholder="{{ 'lang.storefront.form.email.label'|t }}" class="span3" required>
							<button class="btn btn-primary {{ store.theme_options.button_primary_shadow }} submit-newsletter" type="button">{{ 'lang.storefront.form.newsletter.button'|t }}</button>
						</section>
					{% endif %}

					{% if apps.facebook_page %}
						<hr>
						<div class="fb-page" data-href="{{ apps.facebook_page.facebook_url }}" data-small-header="false" data-adapt-container-width="true" data-hide-cover="false" data-show-facepile="true"><blockquote cite="{{ apps.facebook_page.facebook_url }}" class="fb-xfbml-parse-ignore"><a href="{{ apps.facebook_page.facebook_url }}">{{ 'lang.storefront.layout.social.facebook'|t }}</a></blockquote></div>
					{% endif %}

					{% if store.is_ssl %}
						<div style="text-align: center;"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ assets_url('templates/assets/common/icons/secure-site-ssl.png') }}" alt="Site Seguro" title="Site Seguro" style="margin-top: 15px; height: 35px;" class="lazy"></div>
					{% endif %}

				</aside>

				<aside class="span9  col-right">

					{% block content %}{% endblock %}

					{% set reviews = reviews("order:random product:#{product.id} limit:6") %}

					{% if current_page == 'product' and apps.product_reviews and apps.product_reviews.product_reviews_block and reviews.reviews %}
						{{ generic_macros.reviews_block(reviews) }}
					{% endif %}

				</aside>

			</div>

			{% if current_page == 'home' %}
				{% if store.featured_blocks %}
					<section class="featured-blocks content margin-top">
						<div class="row">
							{% for featured_block in store.featured_blocks %}
								<div class="{{ loop.first ? 'offset' ~ (12 - 4 * store.featured_blocks|length) / 2 }} span4 col-featured-block">
									<div class="featured-block">
										<div style="-webkit-mask-image: url('{{ featured_block.icon }}');mask-image: url('{{ featured_block.icon }}');"></div>
										{# <img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ featured_block.icon }}" alt="{{ featured_block.title }}" height="40" class="lazy"> #}
										<h4 class="bold">{{ featured_block.title }}</h4>
										<p>{{ featured_block.description }}</p>
									</div>
								</div>
							{% endfor %}
						</div>
					</section>
				{% endif %}

				{% set brands = brands("order:#{store.theme_options.home_brands_sorting} limit:5") %}
				{% if brands %}
					<section class="brands-block">
						<div class="row">
							<h3 class="span12">{{ 'lang.storefront.home.block.brands.title'|t }}</h3>
							<div class="brands-list">
								{% for brand in brands %}
									<div class="offset1 span1 col-brand">
										<a href="{{ brand.url }}" class="img-frame"><img src="{{ brand.image.thumb }}" alt="{{ brand.title }}" title="{{ brand.title }}"></a>
									</div>
								{% endfor %}
							</div>
							<p class="span12 small margin-top"><a href="{{ site_url('brands') }}" class="text-underline">{{ 'lang.storefront.brands.title'|t }}</a></p>
						</div>
					</section>
				{% endif %}
			{% endif %}

			{% if current_page != 'product' and apps.product_reviews and apps.product_reviews.product_reviews_block and reviews.reviews %}
            	{{ generic_macros.reviews_block(reviews) }}
        	{% endif %}

		</div>
	</div>

	<footer>
		<div class="container">
			<div class="footer-inner">
				<div class="clearfix">
					<div class="pull-left">
						&copy; <strong>{{ store.name }}</strong> {{ "now"|date("Y") }}. {{ 'lang.storefront.layout.footer.copyright'|t }}.<br><br>
						{% for primary_navigation in store.navigation.primary %}
							<a href="{{ primary_navigation.menu_url }}" {{ primary_navigation.target_blank ? 'target="_blank"' }}>{{ primary_navigation.menu_text }}</a>{{ not loop.last ? ' &nbsp; | &nbsp; ' }}
						{% endfor %}
					</div>

					<div class="pull-right">
						<p>{{ store.footer_info|nl2br }}</p>
					</div>
				</div>

				<div class="payment-logos">
					{% for payment in store.payments %}
						{% if payment.active and payment.image %}
							<img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ payment.image }}" alt="{{ payment.title }}" title="{{ payment.title }}" class="lazy">
						{% endif %}
					{% endfor %}
				</div>

				{% if store.theme_options.footer_images %}
					<div class="footer-images">
						{% for footer_image in store.theme_options.footer_images %}
							{{ footer_image.link ? '<a href="' ~ footer_image.link ~ '" target="_blank">' : '' }}
							<img class="lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ footer_image.image.full }}" alt="{{ footer_image.title }}" title="{{ footer_image.title }}">
							{{ footer_image.link ? '</a>' : '' }}
						{% endfor %}
					</div>
				{% endif %}

				{% if store.show_branding %}
					<p class="powered-by" style="margin-top:40px; text-align: center; opacity:0.25; color: #000; font-size: 9px">{{ 'lang.storefront.layout.footer.poweredby'|t }}<br><a href="https://shopk.it/?utm_source={{ store.username }}&amp;utm_medium=referral&amp;utm_campaign=Shopkit-Stores-Branding" title="Powered by Shopkit e-commerce" target="_blank" rel="nofollow"><img src="{{ assets_url('assets/frontend/img/logo-shopkit-black.png') }}" alt="Powered by Shopkit e-commerce" title="Powered by Shopkit e-commerce" style="height:25px;"></a></p>
				{% endif %}
			</div>
		</div>
	</footer>

	{% if store.theme_options.popups|length > 0 %}
		{% for popup in store.theme_options.popups %}
			{% if get.preview or (('all' in popup.location) or (current_page in popup.location)) %}
				{% if popup.type == 'popup' %}
					<div class="modal fade banner-theme-options" id="banner-{{ popup.type }}-{{ popup.unique_id }}" data-unique_id="{{ popup.unique_id }}" data-type="{{ popup.type }}" data-show_timing="{{ popup.show_timing }}" tabindex="-1" role="dialog" aria-labelledby="banner-popupLabel">
						<div class="modal-dialog {{ popup.modal_size }}" role="document">
							<div class="modal-content">
								<div class="modal-body" style="background-color:{{ popup.background_color }};color:{{ popup.text_color }}">
									<button type="button" class="close" data-index="{{ popup.id }}" data-unique_id="{{ popup.unique_id }}" aria-label="Close" style="background-color:{{ popup.background_color }};color:{{ popup.text_color }}"><span aria-hidden="true">&times;</span></button>
									<div class="banner-content {{ popup.image.full ? 'image-' ~ popup.image_position : 'no-image' }} {{ popup.content ? 'has-content' : 'no-content' }}">
										{% if popup.image.full %}
											<div class="popup-image-wrapper">
												<div class="banner-image" data-size="{{ popup.image_background_size }}" style="background-image:url({{ popup.image.full }});background-size:{{ popup.image_background_size ? popup.image_background_size }};background-position:{{ popup.image_background_size == 'cover' ? (popup.image_background_position_x ~ ' ' ~ popup.image_background_position_y ~ ';') : '' }}"></div>
											</div>
										{% endif %}
										{% if popup.content %}
											<div class="popup-content-wrapper">
												<div class="banner-text">{{ popup.content }}</div>
												{{ generic_macros.popup_interactions(popup) }}
											</div>
										{% else %}
											{% if popup.interaction == 'button' or popup.interaction == 'newsletter' %}
												<div class="popup-content-wrapper">
													{{ generic_macros.popup_interactions(popup) }}
												</div>
											{% endif %}
										{% endif %}
									</div>
								</div>
							</div>
						</div>
					</div>
				{% elseif popup.type == 'slide' or popup.type == 'banner' %}
					<div id="banner-{{ popup.type }}-{{ popup.unique_id }}" class="{{ popup.type == 'slide' ? popup.slide_position : popup.banner_position }} banner-theme-options hidden {{ popup.type == 'banner' and popup.style == 'full' ? 'banner-inline' : 'banner-floating' }} {{ popup.modal_size }}" data-unique_id="{{ popup.unique_id }}" data-type="{{ popup.type }}" data-show_timing="{{ popup.show_timing }}">
						<div class="banner-wrapper {{ popup.type == 'banner' ? 'size-' ~ popup.style : '' }}" style="background-color:{{ popup.background_color }};color:{{ popup.text_color }}">
							<button type="button" class="close" data-index="{{ popup.id }}" data-unique_id="{{ popup.unique_id }}" aria-label="Close" style="background-color:{{ popup.background_color }};color:{{ popup.text_color }}">
								<span aria-hidden="true">&times;</span>
							</button>
							<div class="banner-content {{ popup.image.full ? 'image-' ~ popup.image_position : 'no-image' }} {{ popup.content ? 'has-content' : 'no-content' }}">
								{% if popup.image.full and popup.type == 'slide' %}
									<div class="popup-image-wrapper">
										<div class="banner-image" data-size="{{ popup.image_background_size }}" style="background-image:url({{ popup.image.full }});background-size:{{ popup.image_background_size ? popup.image_background_size }};background-position:{{ popup.image_background_size == 'cover' ? (popup.image_background_position_x ~ ' ' ~ popup.image_background_position_y ~ ';') : '' }}"></div>
									</div>
								{% endif %}
								{% if popup.content %}
									<div class="popup-content-wrapper">
										<div class="banner-text">{{ popup.content }}</div>
										{{ generic_macros.popup_interactions(popup) }}
									</div>
								{% else %}
									{% if popup.interaction == 'button' or popup.interaction == 'newsletter' %}
										<div class="popup-content-wrapper">
											{{ generic_macros.popup_interactions(popup) }}
										</div>
									{% endif %}
								{% endif %}
							</div>
						</div>
					</div>
				{% endif %}
			{% endif %}
		{% endfor %}
	{% endif %}


	{# Events #}
	{% if events.wishlist %}
		<div class="modal hide fade modal-alert">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">×</button>
				<h3>{{ 'lang.storefront.layout.wishlist.title'|t }}</h3>
			</div>
			<div class="modal-body">
				{% if events.wishlist.added %}
					<h5 class="text-normal">{{ 'lang.storefront.layout.events.wishlist.added'|t }}</h5>
				{% elseif events.wishlist.removed %}
					<h5 class="text-normal">{{ 'lang.storefront.layout.events.wishlist.removed'|t }}</h5>
				{% endif %}
			</div>
			<div class="modal-footer">
				<a href="#" class="btn btn-default {{ store.theme_options.button_default_shadow }}" data-dismiss="modal">{{ 'lang.storefront.layout.button.close'|t }}</a>
			</div>
		</div>
	{% endif %}

	{% if events.cart %}
		<div class="modal hide fade modal-alert">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">×</button>
				<h3>{{ 'lang.storefront.cart.title'|t }}</h3>
			</div>
			<div class="modal-body">
				{% set button_label = 'lang.storefront.layout.button.close'|t %}

				{% if events.cart.stock_qty or events.cart.stock_sold_single or events.cart.no_stock %}

					{% if events.cart.stock_qty %}
						<h5 class="text-normal">{{ 'lang.storefront.layout.events.cart.not_enough_stock'|t }}</h5>
					{% endif %}

					{% if events.cart.stock_sold_single %}
						<h5 class="text-normal">{{ 'lang.storefront.layout.events.cart.stock_sold_single'|t }} <strong>{{ events.cart.stock_sold_single }}</strong></h5>
					{% endif %}

					{% if events.cart.no_stock %}
						<h5 class="text-normal">{{ 'lang.storefront.layout.events.cart.products_without_stock'|t }}</h5>
					{% endif %}

				{% else %}

					{% if events.cart.added %}
						<h5 class="text-normal">{{ 'lang.storefront.layout.events.cart.added'|t }}</h5>
						{% set button_label = 'lang.storefront.layout.button.keep_buying'|t %}
					{% elseif events.cart.error %}
						<h5 class="text-normal">{{ 'lang.storefront.layout.events.cart.error'|t }}.</h5>
						{% set button_label = 'lang.storefront.layout.button.keep_buying'|t %}
					{% elseif events.cart.updated %}
						<h5 class="text-normal">{{ 'lang.storefront.layout.events.cart.updated'|t }}</h5>
					{% elseif events.cart.session_updated_items or events.cart.session_not_updated_items or events.cart.session_updated %}
						<h5 class="text-normal">{{ 'lang.storefront.layout.events.cart.updated'|t }}</h5>
						{% if events.cart.session_updated_items %}
							<h5><strong>{{ 'lang.storefront.layout.events.cart.updated_items'|t }}</strong></h5>
							<ul>
								{% for product in events.cart.session_updated_items %}
									<li><strong>{{ product.qty }}x</strong> - {{ product.title }}</li>
								{% endfor %}
							</ul>
						{% endif %}
						{% if events.cart.session_not_updated_items %}
							<h5><strong>{{ 'lang.storefront.layout.events.cart.not_updated_items'|t }}</strong></h5>
							<ul>
								{% for product in events.cart.session_not_updated_items %}
									<li><strong>{{ product.qty }}x</strong> - {{ product.title }}</li>
								{% endfor %}
							</ul>
						{% endif %}
					{% elseif events.cart.deleted %}
						<h5 class="text-normal">{{ 'lang.storefront.layout.events.cart.deleted'|t }}.</h5>
					{% endif %}

				{% endif %}
			</div>
			<div class="modal-footer">
				<a href="#" class="btn btn-default {{ store.theme_options.button_default_shadow }}" data-dismiss="modal">{{ button_label }}</a>
				{% if events.cart.added %}
					<a class="btn btn-primary {{ store.theme_options.button_primary_shadow }}" href="{{ site_url('cart') }}">{{ icons('shopping-cart') }} {{ 'lang.storefront.layout.button.see_cart'|t }}</a>
				{% endif %}
			</div>
		</div>
	{% endif %}

	{% if events.unsubscribe %}
		<div class="modal hide fade modal-alert">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">×</button>
				<h3>{{ 'lang.storefront.layout.events.unsubscribe_title'|t }}</h3>
			</div>
			<div class="modal-body">
				<div class="text-center">
					{{ icons('envelope', 'fa-3x text-light-gray') }}
					<h5 class="text-normal">{{ 'lang.storefront.layout.events.unsubscribe_text'|t }}</h5>
				</div>
			</div>
			<div class="modal-footer">
				<a href="#" class="btn btn-default {{ store.theme_options.button_default_shadow }}" data-dismiss="modal">{{ 'lang.storefront.layout.button.close'|t }}</a>
			</div>
		</div>
	{% endif %}

	{% if events.payment_status %}
		<div class="modal hide fade modal-alert">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">×</button>
				<h3>{{ 'lang.storefront.order.payment.title'|t }}</h3>
			</div>
			<div class="modal-body">
				<div class="text-center">
					{% if events.payment_status.success is same as (true) %}
						{{ icons('check', 'fa-3x text-success') }}
					{% elseif events.payment_status.success is same as (false) %}
						{{ icons('times', 'fa-3x text-light-gray') }}
					{% else %}
						{{ icons('check', 'fa-3x text-light-gray') }}
					{% endif %}

					<h5 class="text-normal">{{ events.payment_status.message }}</h5>
				</div>
			</div>
			<div class="modal-footer">
				<a href="#" class="btn btn-default {{ store.theme_options.button_default_shadow }}" data-dismiss="modal">{{ 'lang.storefront.layout.button.close'|t }}</a>
			</div>
		</div>
	{% endif %}

	{% if events.contact_form_success or events.contact_form_errors %}
		<div class="modal hide fade modal-alert">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">×</button>
				<h3>{{ 'lang.storefront.contact.contact_form.title'|t }}</h3>
			</div>
			<div class="modal-body">
				{% if events.contact_form_success %}
					<h5 class="text-normal">{{ 'lang.storefront.layout.events.contact_form_success.title'|t }} {{ 'lang.storefront.layout.events.contact_form_success.text'|t }}</h5>
				{% endif %}

				{% if events.contact_form_errors %}
					<h5 class="text-normal">{{ 'lang.storefront.layout.events.contact_form_error'|t }}</h5>
					<p>{{ events.contact_form_errors }}</p>
				{% endif %}
			</div>
			<div class="modal-footer">
				<a href="#" class="btn btn-default {{ store.theme_options.button_default_shadow }}" data-dismiss="modal">{{ 'lang.storefront.layout.button.close'|t }}</a>
			</div>
		</div>
	{% endif %}

	<div class="modal hide fade" id="user-geolocation-modal" tabindex="-1" role="dialog" aria-labelledby="user-geolocation-modalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				{{ form_open(site_url('user_location'), { 'method' : 'post', 'class' : 'no-margin'  }) }}
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">{{ 'lang.storefront.layout.button.close'|t }}</span></button>
						<h3 class="user-geolocation-modal-choose-country-region">{{ 'lang.storefront.layout.modals.geolocation.choose_country'|t }}</h3>
					</div>
					<div class="modal-body">
						<p><span class="flag-icon user-geolocation-modal-flag"></span> <span class="user-geolocation-modal-flag-ask-country">{{ 'lang.storefront.layout.modals.geolocation.ask_country'|t }}</span></p>
						<select name="user-geolocation-modal-select-country" id="user-geolocation-modal-select-country" class="form-control">
							{% for key, country in countries %}
								<option value="{{ key }}">{{ country }}</option>
							{% endfor %}
						</select>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-default {{ store.theme_options.button_default_shadow }} user-geolocation-modal-cancel" data-dismiss="modal">{{ 'lang.storefront.layout.button.cancel'|t }}</button>
						<button type="submit" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} user-geolocation-modal-change-country-region">{{ 'lang.storefront.layout.modals.geolocation.button.change_country'|t }}</button>
					</div>
				{{ form_close() }}
			</div>
		</div>
	</div>

	<!--[if lt IE 7]>
	<div class="modal hide fade modal-alert">
		<div class="modal-header">
			<button type="button" class="close" data-dismiss="modal">×</button>
			<h3>Actualize o seu browser</h3>
		</div>
		<div class="modal-body">
			<p class="chromeframe">Está a usar um browser (navegador) desactualizado.<br><a href="http://browsehappy.com/" target="_blank">Actualize o seu browser</a> ou instale o  <a href="http://www.google.com/chromeframe/?redirect=true" target="_blank">Google Chrome Frame</a> para ter uma melhor e mais segura experiência de navegação.</p>
		</div>
		<div class="modal-footer">
			<a href="#" class="btn btn-default {{ store.theme_options.button_default_shadow }}" data-dismiss="modal">{{ 'lang.storefront.layout.button.close'|t }}</a>
		</div>
	</div>
	<![endif]-->

	<div id="fb-root"></div>

	<script>
		{% if store.custom_js %}
			{{ store.custom_js }}
		{% endif %}
	</script>

	<script src="{{ store.assets.plugins }}"></script>
	<script src="{{ store.assets.scripts }}"></script>

	{{ footer_content }}

</body>
</html>
