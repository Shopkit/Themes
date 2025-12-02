{#
Template Name: Mosaic
Author: Shopkit
Version: 4.0
Description: This is the base layout. It's included in every page with this code: {% extends 'base.tpl' %}
#}

{% import 'macros.tpl' as generic_macros %}

{# Vars #}
{% set products_per_page_catalog = store.products_per_page_catalog ?: 12 %}
{% set categories_per_page = store.categories_per_page ?: 12 %}
{% set brands_per_page = store.brands_per_page ?: 24 %}
{% set store_name = store.name|e_attr  %}
{% set posts_per_page = store.theme_options.posts_per_page ?: 3 %}
{% set show_search_suggestions = store.theme_options.show_search_suggestions == 'block' ? '' : 'remove-typeahead' %}

<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
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

	{% if apps.facebook_comments.username %}
		<meta property="fb:admins" content="{{ apps.facebook_comments.username }}">
	{% endif %}
	<!-- End Facebook Meta -->

	<link rel="canonical" href="{{ canonical_url }}" />

	<link rel="alternate" href="{{ site_url('rss') }}" type="application/rss+xml" title="{{ store.name|e_attr }}">

	{% if store.favicon %}
		<link rel="shortcut icon" href="{{ store.favicon }}">
	{% endif %}

	<link rel="preconnect" href="https://fonts.googleapis.com">
	<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
	<link href="{{ fonts }}" rel="stylesheet">

	<link id="theme-css" rel="stylesheet" href="{{ store.assets.css }}">
	{{ icon_library }}

	{% if store.custom_css %}
		<style>{{ store.custom_css }}</style>
	{% endif %}

	<script src="{{ assets_url('assets/common/vendor/modernizr/2.7.1/modernizr.min.js') }}"></script>
	<script src="{{ assets_url('assets/common/vendor/jquery/1.9.1/jquery.min.js') }}"></script>

	{{ head_content }}

</head>
<body class="template-mosaic {{ css_class }} {{ store.theme_options.icon_library }}">

	<section class="sidebar">

		<header>

			{% if store.settings.cart.users_registration != 'disabled' %}
				{% if user.is_logged_in %}
					<a href="{{ site_url('account') }}" class="link-account btn-slide" data-target=".account">{{ icons('user') }}</a>
				{% else %}
					<a href="{{ site_url('signin') }}" class="link-signin">{{ icons('sign-in') }}</a>
				{% endif %}
			{% endif %}

			<a href="{{ site_url('cart') }}" class="btn-cart btn-slide" data-target=".cart">
				<span>{{ cart.item_count }}</span>
				{{ icons('shopping-cart') }}
			</a>

			<a href="#" class="btn-navbar">
				{{ icons('bars') }}
			</a>

			{% if apps.newsletter %}
				<a href="#" class="btn-newsletter btn-slide" data-target=".newsletter">
					{{ icons('envelope') }}
				</a>
			{% endif %}

			<div class="inner-header">

				{% if store.logo %}
					<a href="{{ site_url() }}" class="logo"><img src="{{ store.logo }}" alt="{{ store.name|e_attr }}"></a>
				{% else %}
					<h1 class="logo"><a href="{{ site_url() }}">{{ store.name }}</a></h1>
				{% endif %}

				<div class="content-header">
					<h3>{{ store.description }}</h3>
					<h4>{{ store.notice }}</h4>
					<hr>

					<nav class="main-nav">
						<ul class="unstyled">
							{% for primary_navigation in store.navigation.primary %}
								<li class="menu-{{ primary_navigation.menu_text|slug }}"><a href="{{ primary_navigation.menu_url }}" {{ primary_navigation.target_blank ? 'target="_blank"' }}>{{ primary_navigation.menu_text }}</a></li>
							{% endfor %}
						</ul>
					</nav>

					{% if store.theme_options.show_search %}
						<form action="{{ site_url('search') }}" class="search-bar {{ show_search_suggestions }}">
							{{ icons('search') }}
							<input type="search" value="{{ search ? search.query }}" placeholder="{{ 'lang.storefront.layout.header.search'|t }}" name="q">
						</form>
					{% endif %}
				</div>

			</div>

			<nav class="secondary-nav">
				<ul class="unstyled">
					<li><a href="#" class="btn-slide" data-target=".categories">{{ 'lang.storefront.layout.categories.title'|t }}</a></li><li><a href="#" class="btn-slide" data-target=".pages">{{ 'lang.storefront.layout.footer.pages.title'|t }}</a></li>
				</ul>
			</nav>

		</header>

		<footer>

			<nav class="social-nav">
				<ul class="unstyled">
					{% if apps.newsletter %}<li><a href="#" class="btn-newsletter btn-slide" data-target=".newsletter">{{ icons('envelope') }}</a></li>{% endif %}
					{% if store.facebook %}<li><a target="_blank" href="{{ store.facebook }}">{{ icons('facebook-f') }}</a></li>{% endif %}
					{% if store.twitter %}<li><a target="_blank" href="{{ store.twitter }}">{{ icons('twitter') }}</a></li>{% endif %}
					{% if store.instagram %}<li><a target="_blank" href="{{ store.instagram }}">{{ icons('instagram') }}</a></li>{% endif %}
					{% if store.pinterest %}<li><a target="_blank" href="{{ store.pinterest }}">{{ icons('pinterest') }}</a></li>{% endif %}
					{% if store.youtube %}<li><a target="_blank" href="{{ store.youtube }}">{{ icons('youtube') }}</a></li>{% endif %}
					{% if store.linkedin %}<li><a target="_blank" href="{{ store.linkedin }}">{{ icons('linkedin-square') }}</a></li>{% endif %}
					{% if store.tiktok %}<li><a target="_blank" href="{{ store.tiktok }}">{{ icons('tiktok') }}</a></li>{% endif %}
					<li class="link-social-rss"><a href="{{ site_url('rss') }}">{{ icons('rss') }}</a></li>
					{% if apps.google_translate %}
						{{ generic_macros.google_translate(apps.google_translate) }}
					{% endif %}
				</ul>
			</nav>

			{% if store.is_ssl %}
				<div class="text-center" style="margin-bottom:30px;"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ assets_url('templates/assets/common/icons/secure-site-ssl.png') }}" alt="Site Seguro" title="Site Seguro" style="height: 30px;" class="lazy"></div>
			{% endif %}

			{% if store.theme_options.footer_images %}
				<div class="row">
					<div class="footer-images margin-bottom">
						{% for footer_image in store.theme_options.footer_images %}
							{{ footer_image.link ? '<a href="' ~ footer_image.link ~ '" target="_blank">' : '' }}
							<img class="lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ footer_image.image.full }}" alt="{{ footer_image.title }}" title="{{ footer_image.title }}">
							{{ footer_image.link ? '</a>' : '' }}
						{% endfor %}
					</div>
				</div>
			{% endif %}

			<p>&copy; <strong>{{ store.name }}</strong> {{ "now"|date("Y") }}. {{ 'lang.storefront.layout.footer.copyright'|t }}.</p>
			{% if store.footer_info %}<p>{{ store.footer_info|nl2br }}</p>{% endif %}

			{% if store.show_branding %}
				<div class="powered-by">
					{{ 'lang.storefront.layout.footer.poweredby'|t }}<br><a href="https://shopk.it/?utm_source={{ store.username }}&amp;utm_medium=referral&amp;utm_campaign=Shopkit-Stores-Branding" title="Powered by Shopkit e-commerce" target="_blank" rel="nofollow"><img src="{{ assets_url('assets/frontend/img/logo-shopkit-black.png') }}" alt="Powered by Shopkit e-commerce" title="Powered by Shopkit e-commerce" style="height:25px;" height="25" width="105"></a>
				</div>
			{% endif %}
		</footer>

	</section>

	<div class="cart slide-bar well-featured {{ store.theme_options.well_featured_shadow }}">

		<header>
			<h3>{{ 'lang.storefront.cart.title'|t }}</h3>
			<span class="price">{{ cart.subtotal | money_with_sign }}</span>
		</header>

		<section>
			{% if cart.items %}

				{% for item in cart.items %}
					<div class="cart-item">
						<p><strong>{{ item.qty }}x</strong> {{ item.title }}</p>
						{% if item.extras %}
                            <div class="items-extra-wrapper">
                                {% set item_extra_tip = '' %}
                                {% for key, extra in item.extras %}
                                    {% set item_extra_tip = item_extra_tip ~ extra.title ~': '~ extra.value ~ (loop.last ? '' : '</br>') %}
                                {% endfor %}
                                <span href="#item-extra-{{ item.item_id }}" class="inline-block small" data-toggle="tooltip" title="{{ item_extra_tip }}" data-html="true">{{ item.extras|length }} {{ item.extras|length > 1 ? 'lang.storefront.product.extra_options.plural.label'|t : 'lang.storefront.product.extra_options.singular.label'|t }} <span class="text-muted">({{ item.subtotal_extras > 0 ? item.subtotal_extras | money_with_sign : 'lang.storefront.cart.order_summary.shipping_total.free'|t }})</span></span>
                            </div>
                        {% endif %}
						<p class="price"><strong>{{ item.price | money_with_sign }}</strong>
					</div>

					<hr>
				{% endfor %}

				<div class="cart-buttons">
					<a href="{{ site_url('cart') }}" class="btn btn-primary {{ store.theme_options.button_primary_shadow }} margin-bottom-sm">{{ 'lang.storefront.layout.button.see_cart'|t }}</a>
                    <a href="{{ site_url('cart/data') }}" class="btn btn-default {{ store.theme_options.button_default_shadow }}">{{ 'lang.storefront.layout.button.checkout'|t }}</a>
				</div>

			{% else %}
				<p>{{ 'lang.storefront.cart.no_products'|t }}</p>
			{% endif %}

			<div class="payment-logos">
				{% for payment in store.payments %}
					{% if payment.active and payment.image %}
						<img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ payment.image }}" alt="{{ payment.title }}" title="{{ payment.title }}" class="lazy">
					{% endif %}
				{% endfor %}
			</div>

			<div class="text-center"><a class="close" href="#" data-target=".cart">&times;</a></div>

		</section>

	</div>

	<div class="categories slide-bar well-featured {{ store.theme_options.well_featured_shadow }}">

		<header>
			<h3>{{ 'lang.storefront.layout.categories.title'|t }}</h3>
		</header>

		<section>

			<ul class="unstyled list">
				{% for catalog_menu in store.navigation.catalogs_menus %}
					<li class="menu-{{ catalog_menu.menu_item }} {{ current_page == catalog_menu.menu_item ? 'active' }} {{ store.theme_options['show_menu_' ~ catalog_menu.menu_item] ? '' : 'hidden' }}">
						<a href="{{ catalog_menu.menu_url }}">{{ ('lang.storefront.' ~ catalog_menu.menu_item ~ '.title')|t }}</a>
					</li>
				{% endfor %}

				{% for products_category in categories %}
					<li class="{{ (category.id == products_category.id) ? 'active' }} {{ 'menu-' ~ products_category.handle }}">

						{% if products_category.children %}
							<a href="{{ '#category_' ~ products_category.id }}" data-href="{{ products_category.url }}" data-toggle="collapse" target="{{ '#category_' ~ products_category.id }}">{{ products_category.title }} &nbsp; {{ icons('angle-down') }}</a>

							<ul id="{{ 'category_' ~ products_category.id }}" class="sub-categories collapse {{ (category.parent == products_category.id or product.categories[0].parent == products_category.id or category.id == products_category.id or products_category.id == product.categories[0].id) ? 'in' }}">
								{% for sub_category in products_category.children %}
									<li class="{{ (category.id == sub_category.id or product.categories[0].id == sub_category.id) ? 'active' }} {{ 'menu-' ~ sub_category.handle }}">

										{% if sub_category.children %}
											<a href="{{ '#sub_category_' ~ sub_category.id }}" data-href="{{ sub_category.url }}" data-toggle="collapse" target="{{ '#sub_category_' ~ sub_category.id }}">{{ sub_category.title }} &nbsp; {{ icons('angle-down') }}</a>

											<ul id="{{ 'sub_category_' ~ sub_category.id }}" class="collapse sub-subcategories {{ (category.parent == sub_category.id or product.categories[0].parent == sub_category.id or category.id == sub_category.id or sub_category.id == product.categories[0].id) ? 'in' }}">
												{% for children in sub_category.children %}
													<li class="{{ (category.id == children.id or product.categories[0].id == children.id) ? 'active' }} {{ 'menu-' ~ children.handle }}">
														<a href="{{ children.url }}">{{ children.title }}</a>
													</li>
												{% endfor %}
											</ul>
										{% else %}
											<a href="{{ sub_category.url }}">{{ sub_category.title }}</a>
										{% endif %}
									</li>
								{% endfor %}
							</ul>
						{% else %}
							<a href="{{ products_category.url }}">{{ products_category.title }}</a>
						{% endif %}
					</li>
				{% endfor %}
			</ul>

			<div class="text-center"><a class="close" href="#" data-target=".categories">&times;</a></div>
		</section>

	</div>

	{% if store.settings.cart.users_registration != 'disabled' and user.is_logged_in %}
		<div class="account slide-bar well-featured {{ store.theme_options.well_featured_shadow }}">
			<header>
				<h3>{{ 'lang.storefront.layout.greetings'|t }} {{ user.name|first_word }}</h3>
			</header>
			<section>
				<ul class="unstyled list">
					<li class="{{ current_page == 'account' ? 'active' }}"><a href="{{ site_url('account') }}">{{ 'lang.storefront.account.my_account'|t }}</a></li>
					<li class="{{ current_page == 'account-orders' ? 'active' }}"><a href="{{ site_url('account/orders')}}">{{ 'lang.storefront.layout.orders.title'|t }}</a></li>
					<li class="{{ current_page == 'account-profile' ? 'active' }}"><a href="{{ site_url('account/profile')}}">{{ 'lang.storefront.layout.client.title'|t }}</a></li>
					<li class="{{ current_page == 'account-wishlist' ? 'active' }}"><a href="{{ site_url('account/wishlist')}}">{{ 'lang.storefront.layout.wishlist.title'|t }}</a></li>
					{% if store.settings.rewards.active %}<li class="{{ current_page == 'account-rewards' ? 'active' }}"><a href="{{ site_url('account/rewards')}}">{{ store.settings.rewards.plural_label ?: 'lang.storefront.account.rewards.plural.label'|t }} ({{ user.rewards }})</a></li>{% endif %}
					<li><a href="{{ site_url('account/logout')}}">{{ 'lang.storefront.layout.logout.title'|t }}</a></li>
				</ul>
				<div class="text-center"><a class="close" href="#" data-target=".account">&times;</a></div>
			</section>
		</div>
	{% endif %}

	{% if apps.newsletter %}
		<div class="newsletter slide-bar well-featured {{ store.theme_options.well_featured_shadow }}">
			<header>
				<h3>{{ 'lang.storefront.form.newsletter.label'|t }}</h3>
			</header>

			<section class="padding">
				<p>Inscreva-se na nossa newsletter para receber todas as novidades no seu e-mail.</p>
				<br>

				<input name="nome_newsletter" type="text" placeholder="{{ 'lang.storefront.form.name.label'|t }}" class="input-block-level" required="">
				<input name="email_newsletter" type="email" placeholder="{{ 'lang.storefront.form.email.label'|t }}" class="input-block-level" required="">
				<button class="btn btn-primary {{ store.theme_options.button_primary_shadow }} submit-newsletter" type="button">{{ 'lang.storefront.form.newsletter.button'|t }}</button>

				<div class="text-center"><a class="close" href="#" data-target=".newsletter">&times;</a></div>
			</section>
		</div>
	{% endif %}

	<div class="pages slide-bar well-featured {{ store.theme_options.well_featured_shadow }}">

		<header>
			<h3>{{ 'lang.storefront.layout.footer.pages.title'|t }}</h3>
		</header>

		<section>

			<ul class="unstyled list">
				{% for secondary_navigation in store.navigation.secondary %}
					<li class="menu-{{ secondary_navigation.menu_text|slug }}"><a href="{{ secondary_navigation.menu_url }}" {{ secondary_navigation.target_blank ? 'target="_blank"' }}>{{ secondary_navigation.menu_text }}</a></li>
				{% endfor %}
			</ul>

			<div class="text-center"><a class="close" href="#" data-target=".pages">&times;</a></div>

		</section>

	</div>

	<section class="main">

		{% block content %}{% endblock %}

		{% set reviews = reviews("order:random product:#{product.id} limit:6") %}

		{% if apps.product_reviews and apps.product_reviews.product_reviews_block and reviews.reviews %}
			{{ generic_macros.reviews_block(reviews) }}
		{% endif %}

	</section>

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
												{% if popup.image.video_url %}
                                                    <video class="popup-video" data-size="{{ popup.image_background_size }}" style="object-fit:{{ popup.image_background_size ? popup.image_background_size }};object-position:{{ popup.image_background_size == 'cover' ? (popup.image_background_position_x ~ ' ' ~ popup.image_background_position_y ~ ';') : '' }}" autoplay muted loop playsinline poster="{{ popup.image.full }}">
                                                        <source src="{{ popup.image.video_url }}" type="video/mp4">
                                                	</video>
                                                {% else %}
													<div class="banner-image" data-size="{{ popup.image_background_size }}" style="background-image:url({{ popup.image.full }});background-size:{{ popup.image_background_size ? popup.image_background_size }};background-position:{{ popup.image_background_size == 'cover' ? (popup.image_background_position_x ~ ' ' ~ popup.image_background_position_y ~ ';') : '' }}"></div>
												{% endif %}
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
										{% if popup.image.video_url %}
                                            <video class="popup-video" data-size="{{ popup.image_background_size }}" style="object-fit:{{ popup.image_background_size ? popup.image_background_size }};object-position:{{ popup.image_background_size == 'cover' ? (popup.image_background_position_x ~ ' ' ~ popup.image_background_position_y ~ ';') : '' }}" autoplay muted loop playsinline poster="{{ popup.image.full }}">
                                                <source src="{{ popup.image.video_url }}" type="video/mp4">
                                        	</video>
                                        {% else %}
											<div class="banner-image" data-size="{{ popup.image_background_size }}" style="background-image:url({{ popup.image.full }});background-size:{{ popup.image_background_size ? popup.image_background_size }};background-position:{{ popup.image_background_size == 'cover' ? (popup.image_background_position_x ~ ' ' ~ popup.image_background_position_y ~ ';') : '' }}"></div>
										{% endif %}
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
					<h5>{{ 'lang.storefront.layout.events.contact_form_error'|t }}</h5>
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
				{{ form_open(site_url('user_location'), { 'method' : 'post', 'class' : 'no-margin'}) }}
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

	<!--[if lt IE 8]>
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

	<script src="{{ store.assets.plugins }}"></script>
	<script src="{{ store.assets.scripts }}"></script>

	<script>
		var basecolor = '{{ store.basecolor }}';

		{% if store.custom_js %}
			{{ store.custom_js }}
		{% endif %}

	</script>

	{{ footer_content }}

</body>
</html>
