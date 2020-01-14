{#
Template Name: Mosaic
Author: Shopkit
Version: 4.0
Description: This is the base layout. It's included in every page with this code: {% extends 'base.tpl' %}
#}

{% macro category_list(category, show_number_products = true) %}
	{% import _self as generic_macros %}

	{% set category_title = category.title|e_attr %}
	{% set category_url = category.url %}

	<li class="category-id-{{ category.id }}">
		<img src="{{ category.image.square }}" alt="{{ category_title }}" title="{{ category_title }}">
		<div class="description">
			<h3><a href="{{ category_url }}">{{ category_title }}</a></h3>
			{% if not category.parent == 0 and category.children and show_number_products %}
				<p>{{ category.children|length }} Categorias</p>
			{% elseif show_number_products %}
				<p>{{ category.total_products }} Produtos</p>
			{% endif %}
			<a href="{{ category_url }}" class="button white"><span>Explorar</span></a>
		</div>
	</li>
{% endmacro %}

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

	<link rel="alternate" href="{{ site_url('rss') }}" type="application/rss+xml" title="{{ store.name|e_attr }}">

	{% if store.favicon %}
		<link rel="shortcut icon" href="{{ store.favicon }}">
	{% endif %}

	<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:400,100,100italic,300,300italic,400italic,500,500italic,700,700italic">
	<link rel="stylesheet" href="{{ store.assets.css }}">
	<link rel="stylesheet" href="https://netdna.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">

	{% if store.custom_css %}
		<style>{{ store.custom_css }}</style>
	{% endif %}

	<script src="{{ assets_url('js/common/modernizr-2.7.1.min.js')}}"></script>
	<script src="https://drwfxyu78e9uq.cloudfront.net/assets/common/vendor/jquery/1.9.1/jquery.min.js"></script>

	{{ head_content }}

</head>
<body class="template-mosaic {{ css_class }}">

	<section class="sidebar">

		<header>

			{% if store.settings.cart.users_registration != 'disabled' %}
				{% if user.is_logged_in %}
					<a href="{{ site_url('account') }}" class="link-account btn-slide" data-target=".account"><i class="fa fa-user"></i></a>
				{% else %}
					<a href="#signin" class="trigger-shopkit-auth-modal link-signin"><i class="fa fa-sign-in"></i></a>
				{% endif %}
			{% endif %}

			<a href="{{ site_url('cart') }}" class="btn-cart btn-slide" data-target=".cart">
				<span>{{ cart.item_count }}</span>
				<i class="fa fa-shopping-cart"></i>
			</a>

			<a href="#" class="btn-navbar">
				<i class="fa fa-bars"></i>
			</a>

			{% if apps.newsletter %}
				<a href="#" class="btn-newsletter btn-slide" data-target=".newsletter">
					<i class="fa fa-envelope"></i>
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

					<form action="{{ site_url('search') }}">
						<input type="search" value="{{ search ? search.query }}" placeholder="PESQUISAR" name="q">
					</form>
				</div>

			</div>

			<nav class="secondary-nav">
				<ul class="unstyled">
					<li><a href="#" class="btn-slide" data-target=".categories">Categorias</a></li><li><a href="#" class="btn-slide" data-target=".pages">Páginas</a></li>
				</ul>
			</nav>

		</header>

		<footer>

			<nav class="social-nav">
				<ul class="unstyled">
					{% if apps.newsletter %}<li><a href="#" class="btn-newsletter btn-slide" data-target=".newsletter"><i class="fa fa-envelope"></i></a></li>{% endif %}
					{% if store.facebook %}<li><a target="_blank" href="{{ store.facebook }}"><i class="fa fa-facebook"></i></a></li>{% endif %}
					{% if store.twitter %}<li><a target="_blank" href="{{ store.twitter }}"><i class="fa fa-twitter"></i></a></li>{% endif %}
					{% if store.instagram %}<li><a target="_blank" href="{{ store.instagram }}"><i class="fa fa-instagram"></i></a></li>{% endif %}
					{% if store.pinterest %}<li><a target="_blank" href="{{ store.pinterest }}"><i class="fa fa-pinterest"></i></a></li>{% endif %}
					<li><a href="{{ site_url('rss') }}"><i class="fa fa-rss"></i></a></li>
					{% if apps.google_translate %}
						<li>
							{% set default_lang = apps.google_translate.default_language %}
							<div class="languages-dropdown btn-group">
								<button type="button" class="dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
									<span class="current-language"><span class="flag-icon"></span></span>
								</button>
								<ul class="dropdown-menu">
									<li class="googtrans-{{ default_lang }}"><a href="{{ current_url() }}" lang="{{ default_lang }}"><span class="flag-icon flag-icon-{{ apps.google_translate.flags[default_lang] }}"></span></a></li>
									{% for lang in apps.google_translate.languages|split(',') if lang != default_lang %}
										<li class="googtrans-{{ lang }}"><a href="#googtrans({{ lang }})" lang="{{ lang }}"><span class="flag-icon flag-icon-{{ apps.google_translate.flags[lang] }}"></span></a></li>
									{% endfor %}
								</ul>
							</div>
						</li>
					{% endif %}
				</ul>
			</nav>

			{% if store.is_ssl %}
				<div class="text-center" style="margin-bottom:30px;"><img src="{{ assets_url('templates/assets/common/icons/secure-site-ssl.png') }}" alt="Site Seguro" title="Site Seguro" style="height: 30px;"></div>
			{% endif %}

			<p>&copy; <strong>{{ store.name }}</strong> {{ "now"|date("Y") }}. Todos os direitos reservados.</p>
			{% if store.footer_info %}<p>{{ store.footer_info|nl2br }}</p>{% endif %}

		</footer>

	</section>

	<div class="cart slide-bar">

		<header>
			<h3>Carrinho</h3>
			<span class="price">{{ cart.subtotal | money_with_sign }}</span>
		</header>

		<section>
			{% if cart.items %}

				{% for item in cart.items %}
					<p><strong>{{ item.qty }}x</strong> {{ item.title }} &ndash; <strong>{{ item.price | money_with_sign }}</strong></p>
				{% endfor %}

				<hr>

				<h3><a href="{{ site_url('cart') }}">Ver carrinho</a></h3>

			{% else %}
				<p>Não existem produtos no carrinho</p>
			{% endif %}

			<div class="payment-logos">
				{% for payment in store.payments %}
					{% if payment.active and payment.image %}
						<img src="{{ payment.image }}" alt="{{ payment.title }}" title="{{ payment.title }}">
					{% endif %}
				{% endfor %}
			</div>

			<div class="text-center"><a class="close" href="#" data-target=".cart">&times;</a></div>

		</section>

	</div>

	<div class="categories slide-bar">

		<header>
			<h3>Categorias</h3>
		</header>

		<section>

			<ul class="unstyled list">
				<li class="menu-catalog {% if (current_page == 'catalog') %} active {% endif %}">
					<a href="{{ site_url('catalog') }}">Todos os produtos</a>
				</li>
				<li class="menu-categories {% if (current_page == 'categories') %} active {% endif %}">
					<a href="{{ site_url('categories') }}">Todas as categorias</a>
				</li>
				{% for products_category in categories %}
					<li class="{{ (category.id == products_category.id) ? 'active' }} {{ 'menu-' ~ products_category.handle }}">

						{% if products_category.children %}
							<a href="{{ '#category_' ~ products_category.id }}" data-toggle="collapse" target="{{ '#category_' ~ products_category.id }}">{{ products_category.title }} &nbsp; <i class="fa fa-chevron-circle-down"></i></a>

							<ul id="{{ 'category_' ~ products_category.id }}" class="sub-categories collapse {{ (category.parent == products_category.id or product.categories[0].parent == products_category.id or category.id == products_category.id or products_category.id == product.categories[0].id) ? 'in' }}">
								{% for sub_category in products_category.children %}
									<li class="{{ (category.id == sub_category.id or product.categories[0].id == sub_category.id) ? 'active' }} {{ 'menu-' ~ sub_category.handle }}">

										{% if sub_category.children %}
											<a href="{{ '#sub_category_' ~ sub_category.id }}" data-toggle="collapse" target="{{ '#sub_category_' ~ sub_category.id }}">{{ sub_category.title }} &nbsp; <i class="fa fa-chevron-circle-down"></i></a>

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
		<div class="account slide-bar">
			<header>
				<h3>Olá {{ user.name|first_word }}</h3>
			</header>
			<section>
				<ul class="unstyled list">
					<li class="{{ current_page == 'account' ? 'active' }}"><a href="{{ site_url('account') }}">A minha conta</a></li>
					<li class="{{ current_page == 'account-orders' ? 'active' }}"><a href="{{ site_url('account/orders')}}">Encomendas</a></li>
					<li class="{{ current_page == 'account-profile' ? 'active' }}"><a href="{{ site_url('account/profile')}}">Dados de cliente</a></li>
					<li class="{{ current_page == 'account-wishlist' ? 'active' }}"><a href="{{ site_url('account/wishlist')}}">Wishlist</a></li>
					<li><a href="{{ site_url('account/logout')}}">Sair</a></li>
				</ul>
				<div class="text-center"><a class="close" href="#" data-target=".account">&times;</a></div>
			</section>
		</div>
	{% endif %}

	{% if apps.newsletter %}
		<div class="newsletter slide-bar">
			<header>
				<h3>Newsletter</h3>
			</header>

			<section class="padding">
				<p>Inscreva-se na nossa newsletter para receber todas as novidades no seu e-mail.</p>
				<br>

				<input name="nome_newsletter" type="text" placeholder="Nome" class="input-block-level" required="">
				<input name="email_newsletter" type="email" placeholder="E-mail" class="input-block-level" required="">
				<button class="btn btn-inverse submit-newsletter" type="button">Registar</button>

				<div class="text-center"><a class="close" href="#" data-target=".categories">&times;</a></div>
			</section>
		</div>
	{% endif %}

	<div class="pages slide-bar">

		<header>
			<h3>Páginas</h3>
		</header>

		<section>

			<ul class="unstyled list">
				{% for secondary_navigation in store.navigation.secondary %}
					<li class="menu-{{ secondary_navigation.menu_text|slug }}"><a href="{{ secondary_navigation.menu_url }}" {{ secondary_navigation.target_blank ? 'target="_blank"' }}>{{ secondary_navigation.menu_text }}</a></li>
				{% endfor %}
			</ul>

			<div class="text-center"><a class="close" href="#" data-target=".categories">&times;</a></div>

		</section>

	</div>

	<section class="main">

		{% block content %}{% endblock %}

	</section>

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

	{% if events.newsletter_error or events.newsletter_status_success or events.newsletter_status_error or events.newsletter_status_confirmation or events.newsletter_removal %}
		<div class="modal hide fade modal-alert">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">×</button>
				<h3>Newsletter</h3>
			</div>
			<div class="modal-body">
				{% if events.newsletter_error %}
					<h5>Não foi possível efectuar o registo na newsletter:</h5>
					<p>{{ events.newsletter_error }}</p>
				{% endif %}

				{% if events.newsletter_status_success %}
					<h5 class="text-normal">O seu e-mail foi inscrito com sucesso.</h5>
				{% endif %}

				{% if events.newsletter_status_error %}
					<h5 class="text-normal">O seu e-mail já se encontra inscrito na nossa newsletter.</h5>
				{% endif %}

				{% if events.newsletter_status_confirmation %}
					<h5 class="text-normal">Foi enviado um e-mail para confirmar o seu registo.</h5>
				{% endif %}

				{% if events.newsletter_removal %}
					<h5 class="text-normal">{{ events.newsletter_removal }}</h5>
				{% endif %}
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
					<h5>Não foi possivel enviar a sua mensagem:</h5>
					<p>{{ events.contact_form_errors }}</p>
				{% endif %}
			</div>
			<div class="modal-footer">
				<a href="#" class="btn" data-dismiss="modal">Fechar</a>
			</div>
		</div>
	{% endif %}

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
			<a href="#" class="btn" data-dismiss="modal">Fechar</a>
		</div>
	</div>
	<![endif]-->

	<div id="fb-root"></div>

	<script src="{{ store.assets.plugins }}"></script>
	<script src="{{ store.assets.scripts }}"></script>

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

		var basecolor = '{{ store.basecolor }}';

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

	{{ footer_content }}

</body>
</html>