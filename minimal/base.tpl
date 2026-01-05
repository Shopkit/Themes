{#
Template Name: Minimal
Author: Shopkit
Version: 4.0
#}

{% import 'macros.tpl' as generic_macros %}

{# Vars #}
{% set products_per_page_catalog = store.products_per_page_catalog ?: 18 %}
{% set categories_per_page = store.categories_per_page ?: 18 %}
{% set categories_per_row = store.theme_options.categories_per_row ?: 4 %}
{% set mobile_categories_per_row = store.theme_options.mobile_categories_per_row ?: 1 %}
{% set brands_per_page = store.brands_per_page ?: 36 %}
{% set brands_per_row = store.theme_options.brands_per_row ?: 6 %}
{% set mobile_brands_per_row = store.theme_options.mobile_brands_per_row ?: 2 %}
{% set show_categories_navigation = store.theme_options.show_categories_navigation == 'show' ? 'show' : '' %}
{% set store_name = store.name|e_attr  %}
{% set layout_container = store.theme_options.layout_container == 'fluid' ? 'container-fluid' : 'container' %}
{% set mobile_products_per_row = store.theme_options.mobile_products_per_row == '2' ? '6' : '12' %}
{% set products_per_row = current_page == 'home' ? (store.theme_options.home_products_per_row is not null ? store.theme_options.home_products_per_row : '4') : (store.theme_options.products_per_row is not null ? store.theme_options.products_per_row : '4') %}
{% set posts_per_page = store.theme_options.posts_per_page ?: 3 %}
{% set posts_per_row = store.theme_options.posts_per_row ?: 1 %}
{% set show_search_suggestions = store.theme_options.show_search_suggestions == 'block' ? '' : 'remove-typeahead' %}

<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if IE 9]>         <html class="no-js ie9"> <![endif]-->
<!--[if gt IE 9]><!--> <html class="no-js"> <!--<![endif]-->
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<title>{{ title }}</title>

		<meta name="description" content="{{ description|e_attr }}">
		<meta name="keywords" content="{{ tags|e_attr }}">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<meta name="theme-color" content="{{ store.basecolor }}">

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

		{% if store.favicon %}
			<link rel="shortcut icon" href="{{ store.favicon }}">
		{% endif %}

		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">

		<link href="{{ site_url('rss') }}" rel="alternate" type="application/rss+xml" title="{{ store.name|e_attr }}">

		<link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="{{ fonts }}" rel="stylesheet">

		{{ icon_library }}
		<link id="theme-css" href="{{ store.assets.css }}" rel="stylesheet">

		{% if store.custom_css %}
			<style>{{ store.custom_css }}</style>
		{% endif %}

		<script src="{{ assets_url('assets/common/vendor/modernizr/2.7.1/modernizr.min.js') }}"></script>
		<script src="{{ assets_url('assets/common/vendor/jquery/1.11.2/jquery.min.js') }}"></script>

		{{ head_content }}

	</head>

	<body class="{{ css_class }} {{ store.theme_options.modal_mask_blur != '0' ? 'modal-backdrop-blur' }} {{ store.theme_options.icon_library }}">

		<header>

			<div class="store-notice clearfix">
				{% if store.notice %}
					<div class="small store-notice-text">
						{{ store.notice }}
					</div>
				{% endif %}

				<div class="user-auth">
					{% if store.settings.cart.users_registration != 'disabled' %}
						{% if user.is_logged_in %}
							<div class="user-loggedin">
								<a href="{{ site_url('account') }}" class="link-account">{{ icons('user') }} {{ 'lang.storefront.layout.greetings'|t }} {{ user.name|first_word }}</a>
								<ul class="dropdown-menu well-featured {{ store.theme_options.well_featured_shadow }}" role="menu">
									<li class="{{ current_page == 'account-orders' ? 'active' }}"><a href="{{ site_url('account/orders')}}">{{ icons('shopping-bag') }} {{ 'lang.storefront.layout.orders.title'|t }}</a></li>
									<li class="{{ current_page == 'account-profile' ? 'active' }}"><a href="{{ site_url('account/profile')}}">{{ icons('user') }} {{ 'lang.storefront.layout.client.title'|t }}</a></li>
									<li class="{{ current_page == 'account-wishlist' ? 'active' }}"><a href="{{ site_url('account/wishlist')}}">{{ icons('heart') }} {{ 'lang.storefront.layout.wishlist.title'|t }}</a></li>
									{% if store.settings.rewards.active %}<li class="{{ current_page == 'account-rewards' ? 'active' }}"><a href="{{ site_url('account/rewards')}}">{{ icons('trophy') }} {{ store.settings.rewards.plural_label ?: 'lang.storefront.account.rewards.plural.label'|t }} ({{ user.rewards }})</a></li>{% endif %}
									<li><a href="{{ site_url('account/logout')}}">{{ icons('sign-out') }} {{ 'lang.storefront.layout.logout.title'|t }}</a></li>
								</ul>
							</div>
						{% else %}
							<a href="{{ site_url('signin') }}" class="link-signin">{{ icons('sign-in') }} {{ 'lang.storefront.login.signin.title'|t }}</a>
						{% endif %}
					{% endif %}

					<a href="{{ site_url('cart') }}" class="link-cart">{{ icons('shopping-cart') }} {{ cart.subtotal | money_with_sign }}</a>
				</div>

				{% if apps.google_translate %}
					{{ generic_macros.google_translate(apps.google_translate) }}
				{% endif %}

				{% if store.theme_options.show_search %}
					{{ form_open(site_url('search'), { 'method' : 'get', 'class' : 'navbar-form navbar-right', 'role' : 'search' }) }}
						<div class="form-group {{ show_search_suggestions }}">
							<div class="search-form hidden">
								<input type="search" name="q" value="{{ search ? search.query }}" class="form-control input-sm" placeholder="{{ 'lang.storefront.layout.header.search'|t }}" required>
							</div>
						</div>
						<button type="submit" class="btn-search btn btn-link">{{ icons('search') }}</button>
					{{ form_close() }}
				{% endif %}
			</div>

			{# Begin logo #}
			{% if store.logo %}
				<a href="{{ site_url() }}" class="logo"><img src="{{ store.logo }}" alt="{{ store.name|e_attr }}" title="{{ store.name|e_attr }}" height="60"></a>
				{% else %}
				<h1 class="logo"><a href="{{ site_url() }}">{{ store.name }}</a></h1>
			{% endif %}
			{# End logo #}

			{# Begin site navigation #}
			<nav class="navbar">
				<div class="{{ layout_container }}">

					<div class="navbar-header">

						<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse">
							<span class="sr-only">Toggle navigation</span>
							{{ icons('bars') }}
						</button>

					</div>

					<div class="collapse navbar-collapse" id="navbar-collapse">
						<ul class="nav navbar-nav">
							{% for catalog_menu in store.navigation.catalogs_menus %}
								<li class="menu-{{ catalog_menu.menu_item }} {{ current_page == catalog_menu.menu_item ? 'active' }} {{ store.theme_options['show_menu_' ~ catalog_menu.menu_item] ? '' : 'hidden' }}">
									<a href="{{ catalog_menu.menu_url }}">{{ ('lang.storefront.' ~ catalog_menu.menu_item ~ '.title')|t }}</a>
								</li>
							{% endfor %}

							{% if show_categories_navigation == 'show' %}
								{% for products_category in categories %}
									<li class="{{ (category.id == products_category.id) ? 'active' }} {{ products_category.children ? 'dropdown' }} {{ 'menu-' ~ products_category.handle }}">

										{% if products_category.children %}
											<a class="dropdown-toggle" data-toggle="dropdown" href="#" data-href="{{ products_category.url }}">
												{{ products_category.title }} <span class="caret"></span>
											</a>
											<ul class="dropdown-menu well-featured {{ store.theme_options.well_featured_shadow }}" role="menu">
												{% for sub_category in products_category.children %}
													<li class="{{ sub_category.children ? 'subdropdown' }} {{ (category.id == sub_category.id or category.parent == sub_category.id ? 'open') }} {{ (category.id == sub_category.id) ? 'active' }} {{ 'menu-' ~ sub_category.handle }}">

														{% if sub_category.children %}
															<a class="dropdown-toggle" data-toggle="dropdown" href="#" data-href="{{ sub_category.url }}">
																{{ sub_category.title }} <span class="caret"></span>
															</a>

															<ul id="sub_category_{{ sub_category.id }}" class="dropdown-submenu" role="menu">
																{% for children in sub_category.children %}
																	<li class="{{ (category.id == children.id) ? 'active' }} {{ 'menu-' ~ children.handle }}">
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
							{% else %}
								{% for primary_navigation in store.navigation.primary %}
									<li class="menu-{{ primary_navigation.menu_text|slug }} {{ current_page == primary_navigation.menu_item ? 'active' }}"><a href="{{ primary_navigation.menu_url }}" {{ primary_navigation.target_blank ? 'target="_blank"' }}>{{ primary_navigation.menu_text }}</a></li>
								{% endfor %}
							{% endif %}
						</ul>

					</div>

				</div>

			</nav>
			{# End site navigation #}

		</header>

		{% if current_page != 'home' %}
			{{ generic_macros.gallery() }}
		{% endif %}

		{# This is where content of each page will appear #}
		{% block content %}{% endblock %}

		{% set reviews = reviews("order:random product:#{product.id} limit:6") %}

		{% if apps.product_reviews and apps.product_reviews.product_reviews_block and reviews.reviews %}
			{{ generic_macros.reviews_block(reviews) }}
		{% endif %}

		{# Begin footer #}
		<footer>

			<div class="{{ layout_container }}">

				<nav>
					<ul>
						{% if show_categories_navigation == 'show' %}
							{% for primary_navigation in store.navigation.primary %}
								<li class="menu-{{ primary_navigation.menu_text|slug }}"><a href="{{ primary_navigation.menu_url }}" {{ primary_navigation.target_blank ? 'target="_blank"' }}>{{ primary_navigation.menu_text }}</a></li>
							{% endfor %}
						{% endif %}


						{% for secondary_navigation in store.navigation.secondary %}
							<li class="menu-{{ secondary_navigation.menu_text|slug }}"><a href="{{ secondary_navigation.menu_url }}" {{ secondary_navigation.target_blank ? 'target="_blank"' }}>{{ secondary_navigation.menu_text }}</a></li>
						{% endfor %}
					</ul>
				</nav>

				<div class="copyright">
					&copy; {{ store.name }} {{ "now"|date("Y") }}. {{ store.footer_info }}
				</div>

				<div class="payment-logos">
					{% for payment in store.payments %}
						{% if payment.active and payment.image %}
							<img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ payment.image }}" alt="{{ payment.title }}" title="{{ payment.title }}" class="lazy">
						{% endif %}
					{% endfor %}
				</div>

				{% if store.theme_options.footer_images %}
					<div class="row">
						<div class="footer-images margin-top">
							{% for footer_image in store.theme_options.footer_images %}
								{{ footer_image.link ? '<a href="' ~ footer_image.link ~ '" target="_blank">' : '' }}
								<img class="lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ footer_image.image.full }}" alt="{{ footer_image.title }}" title="{{ footer_image.title }}">
								{{ footer_image.link ? '</a>' : '' }}
							{% endfor %}
						</div>
					</div>
				{% endif %}

				{% if store.is_ssl %}
					<div class="text-center" style="margin-top:30px;"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ assets_url('templates/assets/common/icons/secure-site-ssl.png') }}" alt="Site Seguro" title="Site Seguro" style="height: 35px;" class="lazy"></div>
				{% endif %}

				{% if store.show_branding %}
					<div class="powered-by">
						{{ 'lang.storefront.layout.footer.poweredby'|t }}<br><a href="https://shopk.it/?utm_source={{ store.username }}&amp;utm_medium=referral&amp;utm_campaign=Shopkit-Stores-Branding" title="Powered by Shopkit e-commerce" target="_blank" rel="nofollow"><img src="{{ assets_url('assets/frontend/img/logo-shopkit-black.png') }}" alt="Powered by Shopkit e-commerce" title="Powered by Shopkit e-commerce" style="height:25px;" height="25" width="105"></a>
					</div>
				{% endif %}

			</div>

		</footer>
		{# End Footer #}

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
                                                        <video class="popup-video" data-size="{{ popup.image_background_size }}" style="object-fit:{{ popup.image_background_size ? popup.image_background_size }};object-position:{{ popup.image_background_size == 'cover' ? (popup.image_background_position_x ~ ' ' ~ popup.image_background_position_y ~ ';') : '' }}" autoplay muted loop playsinline poster="{{ popup.image.full }}" aria-label="{{ popup.image.alt ? popup.image.alt : popup.title }}">
                                                            <source src="{{ popup.image.video_url }}" type="video/mp4">
                                                            {{ popup.image.alt ? popup.image.alt : popup.title }}
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
                            <div class="banner-wrapper {{ popup.type == 'banner' ? 'size-' ~ popup.style : '' }}"  style="background-color:{{ popup.background_color }};color:{{ popup.text_color }}">
                                <button type="button" class="close" data-index="{{ popup.id }}" data-unique_id="{{ popup.unique_id }}" aria-label="Close" style="background-color:{{ popup.background_color }};color:{{ popup.text_color }}"><span aria-hidden="true">&times;</span></button>
                                <div class="banner-content {{ popup.image.full ? 'image-' ~ popup.image_position : 'no-image' }} {{ popup.content ? 'has-content' : 'no-content' }}">
                                    {% if popup.image.full and popup.type == 'slide' %}
                                        <div class="popup-image-wrapper">
											{% if popup.image.video_url %}
                                                <video class="popup-video" data-size="{{ popup.image_background_size }}" style="object-fit:{{ popup.image_background_size ? popup.image_background_size }};object-position:{{ popup.image_background_size == 'cover' ? (popup.image_background_position_x ~ ' ' ~ popup.image_background_position_y ~ ';') : '' }}" autoplay muted loop playsinline poster="{{ popup.image.full }}" aria-label="{{ popup.image.alt ? popup.image.alt : popup.title }}">
                                                    <source src="{{ popup.image.video_url }}" type="video/mp4">
                                                            {{ popup.image.alt ? popup.image.alt : popup.title }}
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
			<div class="modal fade" id="wishlist-modal" tabindex="-1" role="dialog" aria-labelledby="wishlist-modalLabel">
				<div class="modal-dialog" role="document">
					<div class="modal-content">
						<div class="modal-body">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
							<div class="text-center">
								{% if events.wishlist.added %}
									{{ icons('heart', 'fa-4x text-muted') }}
									<h3 class="text-muted">{{ 'lang.storefront.layout.events.wishlist.added'|t }}</h3>
								{% elseif events.wishlist.removed %}
									{{ icons('heart', 'fa-4x text-muted') }}
									<h3 class="text-muted">{{ 'lang.storefront.layout.events.wishlist.removed'|t }}</h3>
								{% endif %}
							</div>
						</div>
					</div>
				</div>
			</div>
			<script>
				$(document).ready(function(){
					$('#wishlist-modal').modal('show');
				});
			</script>
		{% endif %}

		{% if events.cart %}
			<div class="modal fade" id="cart-modal" tabindex="-1" role="dialog" aria-labelledby="cart-modalLabel">
				<div class="modal-dialog" role="document">
					<div class="modal-content">

						<div class="modal-body">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>

							<div class="text-center">

								{% if events.cart.stock_qty or events.cart.stock_sold_single or events.cart.no_stock %}

									{% if events.cart.stock_qty %}
										{{ icons('ban', 'fa-4x text-muted') }}
										<h3 class="text-muted">{{ 'lang.storefront.layout.events.cart.not_enough_stock'|t }}</h3>
									{% endif %}
									{% if events.cart.stock_sold_single %}
										{{ icons('ban', 'fa-4x text-muted') }}
										<h4 class="text-muted">{{ 'lang.storefront.layout.events.cart.stock_sold_single'|t }} <strong>{{ events.cart.stock_sold_single }}</strong></h4>
									{% endif %}
									{% if events.cart.no_stock %}
										{{ icons('ban', 'fa-4x text-muted') }}
										<h3 class="text-muted">{{ 'lang.storefront.layout.events.cart.products_without_stock'|t }}</h3>
									{% endif %}

								{% else %}

									{% if events.cart.added %}
										{{ icons('check', 'fa-4x text-muted') }}
										<h3 class="text-muted">{{ 'lang.storefront.layout.events.cart.added'|t }}</h3>
									{% elseif events.cart.error %}
										{{ icons('times', 'fa-4x text-muted') }}
										<h3 class="text-muted">{{ 'lang.storefront.layout.events.cart.error'|t }}</h3>
									{% elseif events.cart.updated %}
										{{ icons('sync', 'fa-4x text-muted') }}
										<h3 class="text-muted">{{ 'lang.storefront.layout.events.cart.updated'|t }}</h3>
									{% elseif events.cart.session_updated_items or events.cart.session_not_updated_items or events.cart.session_updated %}
										{{ icons('sync', 'fa-4x text-muted') }}
										<h3 class="text-muted">{{ 'lang.storefront.layout.events.cart.updated'|t }}</h3>

										{% if events.cart.session_updated_items %}
											<h4 class="text-left margin-top">{{ 'lang.storefront.layout.events.cart.updated_items'|t }}</h4>
											<ul class="text-left">
												{% for product in events.cart.session_updated_items %}
													<li><strong>{{ product.qty }}x</strong> - {{ product.title }}</li>
												{% endfor %}
											</ul>
										{% endif %}
										{% if events.cart.session_not_updated_items %}
											<h4 class="text-left margin-top">{{ 'lang.storefront.layout.events.cart.not_updated_items'|t }}</h4>
											<ul class="text-left">
												{% for product in events.cart.session_not_updated_items %}
													<li><strong>{{ product.qty }}x</strong> - {{ product.title }}</li>
												{% endfor %}
											</ul>
										{% endif %}
									{% elseif events.cart.deleted %}
										{{ icons('trash', 'fa-4x text-muted') }}
										<h3 class="text-muted">{{ 'lang.storefront.layout.events.cart.deleted'|t }}.</h3>
									{% endif %}

								{% endif %}

							</div>
						</div>

						<div class="modal-footer">
							{% if events.cart.added or events.cart.session_updated_items or events.cart.session_not_updated_items %}
								<button type="button" class="btn btn-default {{ store.theme_options.button_default_shadow }}" data-dismiss="modal">{{ 'lang.storefront.layout.button.keep_buying'|t }}</button>
								<a href="{{ site_url('cart') }}" class="btn btn-primary {{ store.theme_options.button_primary_shadow }}">{{ 'lang.storefront.layout.button.see_cart'|t }}</a>
							{% else %}
								<button type="button" class="btn btn-default {{ store.theme_options.button_default_shadow }}" data-dismiss="modal">{{ 'lang.storefront.layout.button.close'|t }}</button>
							{% endif %}
						</div>

					</div>
				</div>
			</div>

			<script>
				$(document).ready(function(){
					$('#cart-modal').modal('show');
				});
			</script>
		{% endif %}

		{% if events.unsubscribe %}
			<div class="modal fade" id="unsubscribe-modal" tabindex="-1" role="dialog" aria-labelledby="unsubscribe-modalLabel">
				<div class="modal-dialog" role="document">
					<div class="modal-content">

						<div class="modal-body">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>

							<div class="text-center">
								{{ icons('envelope', 'fa-4x text-muted') }}

								<h3 class="text-muted">{{ 'lang.storefront.layout.events.unsubscribe_title'|t }}</h3>
								<p>{{ 'lang.storefront.layout.events.unsubscribe_text'|t }}</p>
							</div>
						</div>

						<div class="modal-footer">
							<button type="button" class="btn btn-default {{ store.theme_options.button_default_shadow }}" data-dismiss="modal">{{ 'lang.storefront.layout.button.close'|t }}</button>
						</div>
					</div>
				</div>
			</div>

			<script>
				$(document).ready(function(){
					$('#unsubscribe-modal').modal('show');
				});
			</script>
		{% endif %}

		{% if events.payment_status %}
			<div class="modal fade" id="payment-modal" tabindex="-1" role="dialog" aria-labelledby="payment-modalLabel">
				<div class="modal-dialog" role="document">
					<div class="modal-content">

						<div class="modal-body">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>

							<div class="text-center">
								{% if events.payment_status.success is same as (true) %}
									{{ icons('check', 'fa-4x text-muted') }}
								{% elseif events.payment_status.success is same as (false) %}
									{{ icons('times', 'fa-4x text-muted') }}
								{% else %}
									{{ icons('check', 'fa-4x text-muted') }}
								{% endif %}

								<h3 class="text-muted">{{ events.payment_status.message }}</h3>
							</div>
						</div>

						<div class="modal-footer">
							<button type="button" class="btn btn-default {{ store.theme_options.button_default_shadow }}" data-dismiss="modal">{{ 'lang.storefront.layout.button.close'|t }}</button>
						</div>

					</div>
				</div>
			</div>

			<script>
				$(document).ready(function(){
					$('#payment-modal').modal('show');
				});
			</script>
		{% endif %}

		{% if events.contact_form_success or events.contact_form_errors %}
			<div class="modal fade" id="contact-modal" tabindex="-1" role="dialog" aria-labelledby="contact-modalLabel">
				<div class="modal-dialog" role="document">
					<div class="modal-content">

						<div class="modal-body">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>

							<div class="text-center">
								{% if events.contact_form_success %}
									{{ icons('envelope', 'fa-4x text-muted') }}
									<h3 class="text-muted">{{ 'lang.storefront.layout.events.contact_form_success.title'|t }}</h3>
									<p>{{ 'lang.storefront.layout.events.contact_form_success.text'|t }}</p>
								{% endif %}

								{% if events.contact_form_errors %}
									{{ icons('envelope', 'fa-4x text-muted') }}
									<h3 class="text-muted">{{ 'lang.storefront.layout.events.contact_form_error'|t }}</h3>
									<p>{{ events.contact_form_errors }}</p>
								{% endif %}
							</div>
						</div>

						<div class="modal-footer">
							<button type="button" class="btn btn-default {{ store.theme_options.button_default_shadow }}" data-dismiss="modal">{{ 'lang.storefront.layout.button.close'|t }}</button>
						</div>

					</div>
				</div>
			</div>

			<script>
				$(document).ready(function(){
					$('#contact-modal').modal('show');
				});
			</script>
		{% endif %}

		{% if events.return_form_success %}
            <div class="modal fade" id="return-events-modal" tabindex="-1" role="dialog" aria-labelledby="return-events-modalLabel">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">

                        <div class="modal-body">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>

                            <div class="text-center">
                                {% if events.return_form_success %}
                                    {{ icons('envelope', 'fa-4x text-muted') }}
                                    <h3 class="text-muted">{{ 'lang.storefront.layout.events.return_form_success.title'|t }}</h3>
                                    <p>{{ 'lang.storefront.layout.events.return_form_success.text'|t }}</p>
                                {% endif %}
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-default {{ store.theme_options.button_default_shadow }}" data-dismiss="modal">{{ 'lang.storefront.layout.button.close'|t }}</button>
                        </div>

                    </div>
                </div>
            </div>

            <script>
                $(document).ready(function(){
                    $('#return-events-modal').modal('show');
                });
            </script>
        {% endif %}

        {% if events.return_cancel_success or events.return_cancel_errors %}
            <div class="modal fade" id="contact-modal" tabindex="-1" role="dialog" aria-labelledby="contact-modalLabel">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">

                        <div class="modal-body">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>

                            <div class="text-center">
                                {% if events.return_cancel_success %}
                                    {{ icons('envelope', 'fa-4x text-muted') }}
                                    <h3 class="text-muted">{{ 'lang.storefront.layout.events.return_cancel_success'|t }}</h3>
                                {% elseif events.return_cancel_errors %}
                                    {{ icons('envelope', 'fa-4x text-muted') }}
                                    <h3 class="text-muted">{{ 'lang.storefront.layout.events.return_cancel_errors'|t }}</h3>
                                {% endif %}
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="btn btn-default {{ store.theme_options.button_default_shadow }}" data-dismiss="modal">{{ 'lang.storefront.layout.button.close'|t }}</button>
                        </div>

                    </div>
                </div>
            </div>

            <script>
                $(document).ready(function(){
                    $('#contact-modal').modal('show');
                });
            </script>
        {% endif %}

		<div class="modal fade" id="user-geolocation-modal" tabindex="-1" role="dialog" aria-labelledby="user-geolocation-modalLabel">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					{{ form_open(site_url('user_location'), { 'method' : 'post' }) }}
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

		{# //End Events #}

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
