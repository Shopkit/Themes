{#
Template Name: Minimal
Author: Shopkit
Version: 4.0
#}

{% macro category_list(category, show_number_products = true) %}
	{% import _self as generic_macros %}

	{% set category_title = category.title|e_attr %}
	{% set category_url = category.url %}

	<article class="category category-id-{{ category.id }}">

		<a href="{{ category_url }}"><img src="{{ category.image.square }}" class="img-responsive" alt="{{ category_title }}" title="{{ category_title }}" width="400" height="400"></a>

		<div class="category-info">
			<a class="category-details" href="{{ category_url }}">
				<div>
					<h2>{{ category_title }}</h2>
					{% if not category.parent == 0 and category.children and show_number_products %}
						<p>{{ category.children|length }} Categorias</p>
					{% elseif show_number_products %}
						<p>{{ category.total_products }} Produtos</p>
					{% endif %}
				</div>
			</a>
		</div>

	</article>
{% endmacro %}

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

		<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">

		<link href="{{ site_url('rss') }}" rel="alternate" type="application/rss+xml" title="{{ store.name|e_attr }}">

		<link href="https://fonts.googleapis.com/css?family=Lato:100,300,400,700,900,400italic" rel="stylesheet">
		<link href="https://netdna.bootstrapcdn.com/font-awesome/4.6.3/css/font-awesome.min.css" rel="stylesheet">
		<link href="{{ store.assets.css }}" rel="stylesheet">

		{% if store.custom_css %}
			<style>{{ store.custom_css }}</style>
		{% endif %}

		<!--[if lt IE 9]>
			<link href="{{ store.assets.css|replace({'http://drwfxyu78e9uq.cloudfront.net/': 'http://cdn.shopk.it/'}) }}" rel="stylesheet">
			<script src="{{ site_url('bower_components/respondJs/dest/respond.min.js') }}"></script>
			<link href="http://cdn.shopk.it/respond-proxy.html" id="respond-proxy" rel="respond-proxy" />
			<link href="{{ site_url('bower_components/respondJs/cross-domain/respond.proxy.gif') }}" id="respond-redirect" rel="respond-redirect" />
			<script src="{{ site_url('bower_components/respondJs/cross-domain/respond.proxy.js') }}"></script>
		<![endif]-->

		<script src="{{ assets_url('js/common/modernizr-2.7.1.min.js')}}"></script>
		<script src="https://drwfxyu78e9uq.cloudfront.net/assets/common/vendor/jquery/1.11.2/jquery.min.js"></script>

		{{ head_content }}

	</head>

	<body class="{{ css_class }}">

		<header>

			<div class="store-notice clearfix">
				{% if store.notice %}
					<div class="small store-notice-text">
						{{ store.notice }}
					</div>
				{% endif %}

				{{ form_open(site_url('search'), { 'method' : 'get', 'class' : 'navbar-form navbar-right', 'role' : 'search' }) }}
					<div class="form-group">
						<div class="search-form hidden">
							<input type="search" name="q" value="{{ search ? search.query }}" class="form-control input-sm" placeholder="Pesquisa" required>
						</div>

					</div>
					<button type="submit" class="btn-search btn btn-link"><i class="fa fa-fw fa-search"></i></button>
				{{ form_close() }}

				{% if apps.google_translate %}
					{% set default_lang = apps.google_translate.default_language %}
					<div class="languages-dropdown btn-group pull-right">
						<button type="button" class="btn btn-sm btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
							<span class="current-language"><span class="flag-icon"></span></span> &nbsp;
							 <span class="caret"></span>
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

				<div class="user-auth">
					{% if store.settings.cart.users_registration != 'disabled' %}
						{% if user.is_logged_in %}
							<div class="user-loggedin">
								<a href="{{ site_url('account') }}" class="link-account"><i class="fa fa-fw fa-user"></i> Olá {{ user.name|first_word }}</a>
								<ul class="dropdown-menu" role="menu">
									<li class="{{ current_page == 'account-orders' ? 'active' }}"><a href="{{ site_url('account/orders')}}"><i class="fa fa-fw fa-shopping-bag" aria-hidden="true"></i> Encomendas</a></li>
									<li class="{{ current_page == 'account-profile' ? 'active' }}"><a href="{{ site_url('account/profile')}}"><i class="fa fa-fw fa-user" aria-hidden="true"></i> Dados de cliente</a></li>
									<li class="{{ current_page == 'account-wishlist' ? 'active' }}"><a href="{{ site_url('account/wishlist')}}"><i class="fa fa-fw fa-heart" aria-hidden="true"></i> Wishlist</a></li>
									<li><a href="{{ site_url('account/logout')}}"><i class="fa fa-fw fa-sign-out" aria-hidden="true"></i> Sair</a></li>
								</ul>
							</div>
						{% else %}
							<a href="#signin" class="trigger-shopkit-auth-modal link-signin"><i class="fa fa-fw fa-sign-in"></i> Login</a>
						{% endif %}
					{% endif %}

					<a href="{{ site_url('cart') }}" class="link-cart"><i class="fa fa-fw fa-shopping-cart"></i> {{ cart.subtotal | money_with_sign }}</a>
				</div>
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
				<div class="container">

					<div class="navbar-header">

						<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse">
							<span class="sr-only">Toggle navigation</span>
							<i class="fa fa-bars"></i>
						</button>

					</div>

					<div class="collapse navbar-collapse" id="navbar-collapse">
						<ul class="nav navbar-nav">
							<li class="menu-catalog {% if (current_page == 'catalog') %} active {% endif %}">
								<a href="{{ site_url('catalog') }}">Todos os produtos</a>
							</li>
							<li class="menu-categories {% if (current_page == 'categories') %} active {% endif %}">
								<a href="{{ site_url('categories') }}">Todas as categorias</a>
							</li>
							{% for products_category in categories %}
								<li class="{{ (category.id == products_category.id) ? 'active' }} {{ products_category.children ? 'dropdown' }} {{ 'menu-' ~ products_category.handle }}">

									{% if products_category.children %}
										<a class="dropdown-toggle" data-toggle="dropdown" href="#">
											{{ products_category.title }} <span class="caret"></span>
										</a>
										<ul class="dropdown-menu" role="menu">
											{% for sub_category in products_category.children %}
												<li class="{{ sub_category.children ? 'subdropdown' }} {{ (category.id == sub_category.id or category.parent == sub_category.id ? 'open') }} {{ (category.id == sub_category.id) ? 'active' }} {{ 'menu-' ~ sub_category.handle }}">

													{% if sub_category.children %}
														<a class="dropdown-toggle" data-toggle="dropdown" href="#">
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
						</ul>

					</div>

				</div>

			</nav>
			{# End site navigation #}

		</header>

		{# This is where content of each page will appear #}
		{% block content %}{% endblock %}

		{# Begin footer #}
		<footer>

			<div class="container">

				<nav>
					<ul>
						{% for primary_navigation in store.navigation.primary %}
							<li class="menu-{{ primary_navigation.menu_text|slug }}"><a href="{{ primary_navigation.menu_url }}" {{ primary_navigation.target_blank ? 'target="_blank"' }}>{{ primary_navigation.menu_text }}</a></li>
						{% endfor %}

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
							<img src="{{ payment.image }}" alt="{{ payment.title }}" title="{{ payment.title }}">
						{% endif %}
					{% endfor %}
				</div>

				{% if store.is_ssl %}
					<div class="text-center" style="margin-top:30px;"><img src="{{ assets_url('templates/assets/common/icons/secure-site-ssl.png') }}" alt="Site Seguro" title="Site Seguro" style="height: 35px;"></div>
				{% endif %}

				{% if store.show_branding %}
					<div class="powered-by">
						Powered by<br><a href="https://shopk.it/?utm_source={{ store.username }}&amp;utm_medium=referral&amp;utm_campaign=Shopkit-Stores-Branding" target="_blank"><img src="https://drwfxyu78e9uq.cloudfront.net/assets/frontend/img/logo-shopkit-black.png" alt="Shopkit" title="Powered by Shopkit" style="height:25px;" height="25" width="105"></a>
					</div>
				{% endif %}

			</div>

		</footer>
		{# End Footer #}

		{# Events #}
		{% if events.wishlist %}
			<div class="modal fade" id="wishlist-modal" tabindex="-1" role="dialog" aria-labelledby="wishlist-modalLabel">
				<div class="modal-dialog" role="document">
					<div class="modal-content">
						<div class="modal-body">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
							<div class="text-center">
								{% if events.wishlist.added %}
									<i class="fa fa-heart fa-4x text-light-gray"></i>
									<h3 class="text-muted">O produto foi adicionado à wishlist</h3>
								{% elseif events.wishlist.removed %}
									<i class="fa fa-heart-o fa-4x text-light-gray"></i>
									<h3 class="text-muted">O produto foi removido da wishlist</h3>
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
										<i class="fa fa-ban fa-4x text-light-gray"></i>
										<h3 class="text-muted">Não existe stock suficiente do produto</h3>
									{% endif %}
									{% if events.cart.stock_sold_single %}
										<i class="fa fa-ban fa-4x text-light-gray"></i>
										<h4 class="text-muted">Só é possível comprar <strong>1 unidade</strong> do produto <strong>{{ events.cart.stock_sold_single }}</strong></h4>
									{% endif %}
									{% if events.cart.no_stock %}
										<i class="fa fa-ban fa-4x text-light-gray"></i>
										<h3 class="text-muted">Existem produtos que não têm stock suficiente</h3>
									{% endif %}

								{% else %}

									{% if events.cart.added %}
										<i class="fa fa-check fa-4x text-light-gray"></i>
										<h3 class="text-muted">O produto foi adicionado ao carrinho</h3>
									{% elseif events.cart.error %}
										<i class="fa fa-times fa-4x text-light-gray"></i>
										<h3 class="text-muted">O produto não foi adicionado ao carrinho</h3>
									{% elseif events.cart.updated %}
										<i class="fa fa-refresh fa-4x text-light-gray"></i>
										<h3 class="text-muted">O carrinho de compras foi actualizado</h3>
									{% elseif events.cart.session_updated_items or events.cart.session_not_updated_items or events.cart.session_updated %}
										<i class="fa fa-refresh fa-4x text-light-gray"></i>
										<h3 class="text-muted">O carrinho de compras foi actualizado</h3>

										{% if events.cart.session_updated_items %}
											<h4 class="text-left margin-top">Produtos adicionados</h4>
											<ul class="text-left">
												{% for product in events.cart.session_updated_items %}
													<li><strong>{{ product.qty }}x</strong> - {{ product.title }}</li>
												{% endfor %}
											</ul>
										{% endif %}
										{% if events.cart.session_not_updated_items %}
											<h4 class="text-left margin-top">Produtos não adicionados</h4>
											<ul class="text-left">
												{% for product in events.cart.session_not_updated_items %}
													<li><strong>{{ product.qty }}x</strong> - {{ product.title }}</li>
												{% endfor %}
											</ul>
										{% endif %}
									{% elseif events.cart.deleted %}
										<i class="fa fa-trash-o fa-4x text-light-gray"></i>
										<h3 class="text-muted">O produto foi removido do carrinho.</h3>
									{% endif %}

								{% endif %}

							</div>
						</div>

						<div class="modal-footer">
							{% if events.cart.added or events.cart.session_updated_items or events.cart.session_not_updated_items %}
								<button type="button" class="btn btn-default" data-dismiss="modal">Continuar a comprar</button>
								<a href="{{ site_url('cart') }}" class="btn btn-gray">Ver carrinho</a>
							{% else %}
								<button type="button" class="btn btn-default" data-dismiss="modal">Fechar</button>
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

		{% if events.newsletter_error or events.newsletter_status_success or events.newsletter_status_error or events.newsletter_status_confirmation or events.newsletter_removal %}
			<div class="modal fade" id="newsletter-modal" tabindex="-1" role="dialog" aria-labelledby="newsletter-modalLabel">
				<div class="modal-dialog" role="document">
					<div class="modal-content">

						<div class="modal-body">
							<button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>

							<div class="text-center">
								<i class="fa fa-envelope-o fa-4x text-light-gray"></i>

								{% if events.newsletter_error %}
									<h3 class="text-muted">Não foi possível efectuar o registo na newsletter:</h3>
									<p>{{ events.newsletter_error }}</p>
								{% endif %}

								{% if events.newsletter_status_success %}
									<h3 class="text-muted">O seu e-mail foi inscrito com sucesso.</h3>
								{% endif %}

								{% if events.newsletter_status_error %}
									<h3 class="text-muted">O seu e-mail já se encontra inscrito na nossa newsletter.</h3>
								{% endif %}

								{% if events.newsletter_status_confirmation %}
									<h3 class="text-muted">Foi enviado um e-mail para confirmar o seu registo.</h3>
								{% endif %}

								{% if events.newsletter_removal %}
									<h3 class="text-muted">Newsletter</h3>
									<p>{{ events.newsletter_removal }}</p>
								{% endif %}
							</div>
						</div>

						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">Fechar</button>
						</div>

					</div>
				</div>
			</div>

			<script>
				$(document).ready(function(){
					$('#newsletter-modal').modal('show');
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
									<i class="fa fa-check fa-4x text-success"></i>
								{% elseif events.payment_status.success is same as (false) %}
									<i class="fa fa-times fa-4x text-light-gray"></i>
								{% else %}
									<i class="fa fa-check fa-4x text-light-gray"></i>
								{% endif %}

								<h3 class="text-muted">{{ events.payment_status.message }}</h3>
							</div>
						</div>

						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">Fechar</button>
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
									<i class="fa fa-envelope fa-4x text-light-gray"></i>
									<h3 class="text-muted">A sua mensagem foi enviada com sucesso.</h3>
									<p>Obrigado pelo contacto.</p>
								{% endif %}

								{% if events.contact_form_errors %}
									<i class="fa fa-envelope fa-4x text-light-gray"></i>
									<h3 class="text-muted">Não foi possivel enviar a sua mensagem:</h3>
									<p>{{ events.contact_form_errors }}</p>
								{% endif %}
							</div>
						</div>

						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">Fechar</button>
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

		{# //End Events #}

		<div id="fb-root"></div>

		<script>
			/* Facebook JS SDK */
			window.fbAsyncInit = function() {
				FB.init({
					appId : {{ apps.facebook_login.app_id|default(267439666615965) }},
					autoLogAppEvents : true,
					cookie: true,
					xfbml : true,
					version : 'v2.11'
				});
				{% if apps.facebook_login %}
					FB.getLoginStatus(function(){
						$('.shopkit-auth-btn-facebook').attr('disabled', false).removeClass('disabled');
					});
				{% endif %}
			};
			(function(d, s, id){
				var js, fjs = d.getElementsByTagName(s)[0];
				if (d.getElementById(id)) {return;}
				js = d.createElement(s); js.id = id;
				js.src = "https://connect.facebook.net/pt_PT/sdk/xfbml.customerchat.js";
				fjs.parentNode.insertBefore(js, fjs);
			}(document, 'script', 'facebook-jssdk'));
			/* End Facebook JS SDK */

			{% if not apps.google_analytics_ec %}
				/* Google Analytics */
				var _gaq = _gaq || [];
				_gaq.push(['_setAccount', 'UA-28055653-2']);
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