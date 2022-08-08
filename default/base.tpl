{#
Template Name: Shopkit Default Template
Author: Shopkit
Version: 4.0
Description: This is the base layout. It is included in every page with this code {% extends 'base.tpl' %}
Github: https://github.com/Shopkit/Default
#}

{# Vars #}
{% set products_per_page_home = store.products_per_page_home ?: 9 %}
{% set products_per_page_catalog = store.products_per_page_catalog ?: 18 %}
{% set categories_per_page = store.categories_per_page ?: 18 %}
{% set brands_per_page = store.brands_per_page ?: 36 %}

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

	<!-- Facebook Meta -->
	<meta property="og:site_name" content="{{ store.name|e_attr }}">
	<meta property="og:type" content="website">
	<meta property="og:title" content="{{ title|e_attr }}">
	<meta property="og:description" content="{{ description|e_attr }}">
	<meta property="og:url" content="{{ current_url() }}">
	{% if image %}
		<meta property="og:image" content="{{ image }}">
	{% endif %}

	{% if apps.facebook_comments.username %}
		<meta property="fb:admins" content="{{ apps.facebook_comments.username }}">
	{% endif %}
	<!-- End Facebook Meta -->

	<link rel="canonical" href="{{ canonical_url }}" />

	{% if store.favicon %}
		<link rel="shortcut icon" href="{{ store.favicon }}">
	{% endif %}

	<link rel="alternate" href="{{ site_url('rss') }}" type="application/rss+xml" title="{{ store.name|e_attr }}">
	<link rel="stylesheet" href="{{ assets_url('assets/common/vendor/fontawesome/4.7/css/font-awesome.min.css') }}">
	<link rel="stylesheet" href="{{ store.assets.css }}">

	{% if store.custom_css %}
		<style>{{ store.custom_css }}</style>
	{% endif %}

	<script src="{{ assets_url('assets/common/vendor/modernizr/2.7.1/modernizr.min.js') }}"></script>
	<script src="{{ assets_url('assets/common/vendor/jquery/1.9.1/jquery.min.js') }}"></script>

	{{ head_content }}

</head>
<body class="{{ css_class }}">

	<div class="container">

		<header>

			{% if store.notice %}
				<div class="store-notice">{{ store.notice }}</div>
			{% endif %}

			<div class="clearfix">
				{% if store.logo %}
					<p class="logo pull-left"><a href="{{ site_url() }}"><img src="{{ store.logo }}" alt="{{ store.name|e_attr }}"></a></p>
				{% else %}
					<h1 class="logo pull-left"><a href="{{ site_url() }}">{{ store.name }}</a></h1>
				{% endif %}

				<!-- CART -->
				<aside class="pull-right cart-header">
					<div class="btn-group">
						<a class="btn btn-inverse" href="{{ site_url('cart') }}"><i class="fa fa-shopping-cart fa-lg fa-fw"></i> Carrinho de Compras ({{ cart.item_count }})</a>
						<button data-toggle="dropdown" class="btn btn-inverse dropdown-toggle"><span class="caret"></span></button>
						<ul class="dropdown-menu">
							{% if cart.items %}
								{% for item in cart.items %}
									<li><a href="{{ item.product_url }}"><strong>{{ item.qty }}x</strong> {{ item.title }} &ndash; <strong class="price">{{ item.price | money_with_sign }}</strong></a></li>
								{% endfor %}
							{% else %}
								<li><a>Não existem produtos no carrinho</a></li>
							{% endif %}
						</ul>
					</div>

					<p class="cart-header-totals">
						{% if store.settings.cart.users_registration != 'disabled' %}
							<span class="pull-left">
								{% if user.is_logged_in %}
									<a href="{{ site_url('account') }}" class="link-account text-default"><i class="fa fa-fw fa-user"></i> Olá <strong>{{ user.name|first_word }}</strong></a>
								{% else %}
									<a href="#signin" class="trigger-shopkit-auth-modal link-signin text-default"><i class="fa fa-fw fa-sign-in"></i> Login</a>
								{% endif %}
							</span>
						{% endif %}
						<span class="pull-right"><a href="{{ site_url('cart') }}" class="text-default">Total: <strong>{{ cart.subtotal | money_with_sign }}</strong></a></span>
					</p>
				</aside>
				<!-- END CART -->
			</div>

			<div class="navbar navbar-inverse">
				<div class="navbar-inner">
					<div class="container">
						<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
							<i class="fa fa-bars fa-lg"></i>
						</a>
						<div class="nav-collapse trigger-priority-nav">
							<ul class="nav">
								{% for primary_navigation in store.navigation.primary %}
									<li class="menu-{{ primary_navigation.menu_text|slug }}"><a href="{{ primary_navigation.menu_url }}" {{ primary_navigation.target_blank ? 'target="_blank"' }}>{{ primary_navigation.menu_text }}</a></li>
									<li class="divider-vertical divider-{{ primary_navigation.menu_text|slug }}"></li>
								{% endfor %}
							</ul>
							<form action="{{ site_url('search') }}" class="navbar-search pull-right">
								<input type="text" name="q" value="{{ search ? search.query }}" placeholder="Pesquisar" class="search-query span2">
							</form>
							{% if apps.google_translate %}
								{% set default_lang = apps.google_translate.default_language %}
								<div class="languages-dropdown visible-desktop btn-group pull-right">
									<button type="button" class="btn btn-sm btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
										<span class="current-language"><span class="flag-icon"></span></span>
									</button>
									<ul class="dropdown-menu">
										<li class="googtrans-{{ default_lang }}"><a href="{{ current_url() }}" lang="{{ default_lang }}"><span class="flag-icon flag-icon-{{ apps.google_translate.flags[default_lang] }}"></span></a></li>
										{% for lang in apps.google_translate.languages|split(',') %}
											{% if lang != default_lang %}
												<li class="googtrans-{{ lang }}"><a href="#googtrans({{ lang }})" lang="{{ lang }}"><span class="flag-icon flag-icon-{{ apps.google_translate.flags[lang] }}"></span></a></li>
											{% endif %}
										{% endfor %}
									</ul>
								</div>
							{% endif %}
						</div>
					</div>
				</div>
			</div>

			{% if store.gallery %}
				<section class="slideshow slideshow-home hidden-phone">
					<div class="loader"><i class="fa fa-circle-o-notch fa-spin"></i></div>
					<div class="flexslider">
						<ul class="slides">
							{% for gallery in store.gallery %}
								{% set has_slide_content = gallery.title or gallery.button or gallery.description ? 'has-slide-content' %}
								<li class="slide {{ has_slide_content }}" style="background-image:url({{ gallery.image.full }})">
									{% if has_slide_content %}
									<div class="slide-content">
										{% if gallery.title %}
											{% if gallery.link %}
												<h4 class="slide-title"><a href="{{ gallery.link }}">{{ gallery.title }}</a></h4>
											{% else %}
												<h4 class="slide-title">{{ gallery.title }}</h4>
											{% endif %}
										{% endif %}
										{% if gallery.description %}
											<div class="slide-description">{{ gallery.description }}</div>
										{% endif %}
										{% if gallery.button %}
											<div class="slide-button">
												<a href="{{ gallery.button_link }}" class="btn">{{ gallery.button }}</a>
											</div>
										{% endif %}
									</div>
								{% endif %}
								</li>
							{% endfor %}
						</ul>
					</div>

					{% if store.description %}
						<div class="store-description">
							{{ store.description }}
						</div>
					{% endif %}
				</section>
			{% endif %}

		</header>

		<div class="main" role="main">
			<div class="row show-grid">

				<aside class="span3 col-left">

					{% if user.is_logged_in %}
						<section class="account-menu">
							<h3><a href="{{ site_url('account') }}">A minha conta</a></h3>

							<nav class="normal">
								<ul>
									<li><a href="{{ site_url('account/orders')}}" class="list-group-item {{ current_page == 'account-orders' ? 'active' }}"><i class="text-muted fa fa-fw fa-shopping-bag" aria-hidden="true"></i> Encomendas</a></li>
									<li><a href="{{ site_url('account/profile')}}" class="list-group-item {{ current_page == 'account-profile' ? 'active' }}"><i class="text-muted fa fa-fw fa-user" aria-hidden="true"></i> Dados de cliente</a></li>
									<li><a href="{{ site_url('account/wishlist')}}" class="list-group-item {{ current_page == 'account-wishlist' ? 'active' }}"><i class="text-muted fa fa-fw fa-heart" aria-hidden="true"></i> Wishlist</a></li>
									<li><a href="{{ site_url('account/logout')}}" class="list-group-item"><i class="text-muted fa fa-fw fa-sign-out" aria-hidden="true"></i> Sair</a></li>
								</ul>
							</nav>
						</section>
					{% endif %}

					<h3>Produtos</h3>

					<nav>
						<ul>
							{% for catalog_menu in store.navigation.catalogs_menus %}
								<li class="menu-{{ catalog_menu.menu_item }} {{ current_page == catalog_menu.menu_item ? 'active' }}">
									<h4>
										<a href="{{ catalog_menu.menu_url }}">{{ catalog_menu.menu_text }}</a>
									</h4>
								</li>
							{% endfor %}

							{% for products_category in categories %}
								<li class="{{ (category.id == products_category.id) ? 'active' }} {{ 'menu-' ~ products_category.handle }}">

									{% if products_category.children %}
										<h4 data-toggle="collapse" data-target="{{ '#category_' ~ products_category.id }}">
											<a href="#" data-href="{{ products_category.url }}">{{ products_category.title }} <i class="fa fa-angle-down" aria-hidden="true"></i></a>
										</h4>

										<ul id="{{ 'category_' ~ products_category.id }}" class="sub-categories collapse {{ (category.parent == products_category.id or category.id == products_category.id) ? 'in' }}">
											{% for sub_category in products_category.children %}
												<li class="{{ (category.id== sub_category.id) ? 'active' }} {{ 'menu-' ~ sub_category.handle }}">

													{% if sub_category.children %}
														<h5 data-toggle="collapse" data-target="{{ '#sub_category_' ~ sub_category.id }}">
															<a href="#" data-href="{{ sub_category.url }}">{{ sub_category.title }} <i class="fa fa-angle-down" aria-hidden="true"></i></a>
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
							<h3>Menu</h3>

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
						<h3>Redes Sociais</h3>

						<nav class="normal social">
							<ul>
								{% if store.facebook %}
									<li class="facebook"><a target="_blank" href="{{ store.facebook }}"><i class="fa fa-facebook fa-lg fa-fw"></i> Facebook</a></li>
								{% endif %}
								{% if store.twitter %}
									<li class="twitter"><a target="_blank" href="{{ store.twitter }}"><i class="fa fa-twitter fa-lg fa-fw"></i> Twitter</a></li>
								{% endif %}
								{% if store.instagram %}
									<li class="instagram"><a target="_blank" href="{{ store.instagram }}"><i class="fa fa-instagram fa-lg fa-fw"></i> Instagram</a></li>
								{% endif %}
								{% if store.pinterest %}
									<li class="pinterest"><a target="_blank" href="{{ store.pinterest }}"><i class="fa fa-pinterest fa-lg fa-fw"></i> Pinterest</a></li>
								{% endif %}
								<li class="rss"><a href="{{ site_url('rss') }}"><i class="fa fa-rss fa-lg fa-fw"></i> RSS</a></li>
							</ul>
						</nav>
					</section>

					{% if apps.newsletter %}
						<section class="newsletter hidden-phone">
							<h3>Newsletter</h3>
							<p>Inscreva-se na nossa newsletter para receber todas as novidades no seu e-mail.</p>

							<input name="nome_newsletter" type="text" placeholder="Nome" class="span3" required>
							<input name="email_newsletter" type="text" placeholder="E-mail" class="span3" required>
							<button class="btn btn-inverse submit-newsletter" type="button">Registar</button>
						</section>
					{% endif %}

					{% if apps.facebook_page %}
						<hr>
						<div class="fb-page" data-href="{{ apps.facebook_page.facebook_url }}" data-small-header="false" data-adapt-container-width="true" data-hide-cover="false" data-show-facepile="true"><blockquote cite="{{ apps.facebook_page.facebook_url }}" class="fb-xfbml-parse-ignore"><a href="{{ apps.facebook_page.facebook_url }}">Facebook</a></blockquote></div>
					{% endif %}

					{% if store.is_ssl %}
						<div style="text-align: center;"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ assets_url('templates/assets/common/icons/secure-site-ssl.png') }}" alt="Site Seguro" title="Site Seguro" style="margin-top: 15px; height: 35px;" class="lazy"></div>
					{% endif %}

				</aside>

				<aside class="span9  col-right">

					{% block content %}{% endblock %}

				</aside>

			</div>

			{% if current_page == 'home' %}
				{% if store.featured_blocks %}
					<section class="featured-blocks content margin-top">
						<div class="row">
							{% for featured_block in store.featured_blocks %}
								<div class="{{ loop.first ? 'offset' ~ (12 - 4 * store.featured_blocks|length) / 2 }} span4 col-featured-block">
									<div class="featured-block">
										<img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ featured_block.icon }}" alt="{{ featured_block.title }}" height="40" class="lazy">
										<h4 class="bold">{{ featured_block.title }}</h4>
										<p>{{ featured_block.description }}</p>
									</div>
								</div>
							{% endfor %}
						</div>
					</section>
				{% endif %}
			{% endif %}

		</div>

		<footer>

			<div class="clearfix">
				<div class="pull-left">
					&copy; <strong>{{ store.name }}</strong> {{ "now"|date("Y") }}. Todos os direitos reservados.<br><br>
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

			{% if store.show_branding %}
				<p style="margin-top:40px; text-align: center; opacity:0.25; color: #000; font-size: 9px">Powered by<br><a href="https://shopk.it/?utm_source={{ store.username }}&amp;utm_medium=referral&amp;utm_campaign=Shopkit-Stores-Branding" title="Powered by Shopkit e-commerce" target="_blank" rel="nofollow"><img src="{{ assets_url('assets/frontend/img/logo-shopkit-black.png') }}" alt="Powered by Shopkit e-commerce" title="Powered by Shopkit e-commerce" style="height:25px;"></a></p>
			{% endif %}

		</footer>
	</div>

	{# Events #}
	{% if events.wishlist %}
		<div class="modal hide fade modal-alert">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">×</button>
				<h3>Wishlist</h3>
			</div>
			<div class="modal-body">
				{% if events.wishlist.added %}
					<h5 class="text-normal">O produto foi adicionado à wishlist</h5>
				{% elseif events.wishlist.removed %}
					<h5 class="text-normal">O produto foi removido da wishlist</h5>
				{% endif %}
			</div>
			<div class="modal-footer">
				<a href="#" class="btn" data-dismiss="modal">Fechar</a>
			</div>
		</div>
	{% endif %}

	{% if events.cart %}
		<div class="modal hide fade modal-alert">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">×</button>
				<h3>Carrinho de Compras</h3>
			</div>
			<div class="modal-body">
				{% set button_label = 'Fechar' %}

				{% if events.cart.stock_qty or events.cart.stock_sold_single or events.cart.no_stock %}

					{% if events.cart.stock_qty %}
						<h5 class="text-normal">Não existe stock suficiente do produto</h5>
					{% endif %}

					{% if events.cart.stock_sold_single %}
						<h5 class="text-normal">Só é possível comprar <strong>1 unidade</strong> do produto <strong>{{ events.cart.stock_sold_single }}</strong></h5>
					{% endif %}

					{% if events.cart.no_stock %}
						<h5 class="text-normal">Existem produtos que não têm stock suficiente</h5>
					{% endif %}

				{% else %}

					{% if events.cart.added %}
						<h5 class="text-normal">O produto <strong>{{ events.cart.added }}</strong> foi adicionado ao carrinho.</h5>
						{% set button_label = 'Continuar a comprar' %}
					{% elseif events.cart.error %}
						<h5 class="text-normal">O produto não foi adicionado ao carrinho.</h5>
						{% set button_label = 'Continuar a comprar' %}
					{% elseif events.cart.updated %}
						<h5 class="text-normal">O carrinho de compras foi actualizado</h5>
					{% elseif events.cart.session_updated_items or events.cart.session_not_updated_items or events.cart.session_updated %}
						<h5 class="text-normal">O carrinho de compras foi actualizado</h5>
						{% if events.cart.session_updated_items %}
							<h5><strong>Produtos adicionados</strong></h5>
							<ul>
								{% for product in events.cart.session_updated_items %}
									<li><strong>{{ product.qty }}x</strong> - {{ product.title }}</li>
								{% endfor %}
							</ul>
						{% endif %}
						{% if events.cart.session_not_updated_items %}
							<h5><strong>Produtos não adicionados</strong></h5>
							<ul>
								{% for product in events.cart.session_not_updated_items %}
									<li><strong>{{ product.qty }}x</strong> - {{ product.title }}</li>
								{% endfor %}
							</ul>
						{% endif %}
					{% elseif events.cart.deleted %}
						<h5 class="text-normal">O produto foi removido do carrinho.</h5>
					{% endif %}

				{% endif %}
			</div>
			<div class="modal-footer">
				<a href="#" class="btn" data-dismiss="modal">{{ button_label }}</a>
				{% if events.cart.added %}
					<a class="btn btn-inverse" href="{{ site_url('cart') }}"><i class="fa fa-shopping-cart"></i> Ver Carrinho</a>
				{% endif %}
			</div>
		</div>
	{% endif %}

	{% if events.unsubscribe %}
		<div class="modal hide fade modal-alert">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">×</button>
				<h3>Cancelar subscrição</h3>
			</div>
			<div class="modal-body">
				<div class="text-center">
					<i class="fa fa-envelope fa-3x text-light-gray"></i>
					<h5 class="text-normal">A sua subscrição foi cancelada.</h5>
				</div>
			</div>
			<div class="modal-footer">
				<a href="#" class="btn" data-dismiss="modal">Fechar</a>
			</div>
		</div>
	{% endif %}

	{% if events.payment_status %}
		<div class="modal hide fade modal-alert">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">×</button>
				<h3>Pagamento</h3>
			</div>
			<div class="modal-body">
				<div class="text-center">
					{% if events.payment_status.success is same as (true) %}
						<i class="fa fa-check fa-3x text-success"></i>
					{% elseif events.payment_status.success is same as (false) %}
						<i class="fa fa-times fa-3x text-light-gray"></i>
					{% else %}
						<i class="fa fa-check fa-3x text-light-gray"></i>
					{% endif %}

					<h5 class="text-normal">{{ events.payment_status.message }}</h5>
				</div>
			</div>
			<div class="modal-footer">
				<a href="#" class="btn" data-dismiss="modal">Fechar</a>
			</div>
		</div>
	{% endif %}

	{% if events.contact_form_success or events.contact_form_errors %}
		<div class="modal hide fade modal-alert">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">×</button>
				<h3>Formulário de Contacto</h3>
			</div>
			<div class="modal-body">
				{% if events.contact_form_success %}
					<h5 class="text-normal">A sua mensagem foi enviada com sucesso. Obrigado pelo contacto.</h5>
				{% endif %}

				{% if events.contact_form_errors %}
					<h5 class="text-normal">Não foi possivel enviar a sua mensagem:</h5>
					<p>{{ events.contact_form_errors }}</p>
				{% endif %}
			</div>
			<div class="modal-footer">
				<a href="#" class="btn" data-dismiss="modal">Fechar</a>
			</div>
		</div>
	{% endif %}

	<div class="modal hide fade" id="user-geolocation-modal" tabindex="-1" role="dialog" aria-labelledby="user-geolocation-modalLabel">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				{{ form_open(site_url('user_location'), { 'method' : 'post', 'class' : 'no-margin'  }) }}
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
						<h3 class="user-geolocation-modal-choose-country-region">Choose your country/region</h3>
					</div>
					<div class="modal-body">
						<p><span class="flag-icon user-geolocation-modal-flag"></span> <span class="user-geolocation-modal-flag-ask-country">Are you in <span class="user-geolocation-modal-country"></span>? Please confirm your country.</span></p>
						<select name="user-geolocation-modal-select-country" id="user-geolocation-modal-select-country" class="form-control">
							{% for key, country in countries_en %}
								<option value="{{ key }}">{{ country }}</option>
							{% endfor %}
						</select>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn user-geolocation-modal-cancel" data-dismiss="modal">Cancel</button>
						<button type="submit" class="btn btn-inverse user-geolocation-modal-change-country-region">Change country/region</button>
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
			<a href="#" class="btn" data-dismiss="modal">Fechar</a>
		</div>
	</div>
	<![endif]-->

	<div id="fb-root"></div>

	<script>
		{% if not apps.google_analytics_ec %}
			/* Google Analytics */
			var _gaq = _gaq || [];
			_gaq.push(['_setAccount', '{{ ga_profile_id }}']);
			_gaq.push(['_setDomainName', '{{ domain }}']);
			_gaq.push(['_trackPageview']);

			{% if apps.google_analytics %}
				_gaq.push(['b._setAccount', '{{ apps.google_analytics.tracking_id }}']);
				_gaq.push(['b._trackPageview']);
			{% endif %}

			(function() {
				var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
				ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
				var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
			})();
			/* End Google Analytics */
		{% endif %}

		{% if store.custom_js %}
			{{ store.custom_js }}
		{% endif %}
	</script>

	<script src="{{ store.assets.plugins }}"></script>
	<script src="{{ store.assets.scripts }}"></script>

	{{ footer_content }}

</body>
</html>