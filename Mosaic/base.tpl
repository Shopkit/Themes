{#
Template Name: Mosaic
Author: Shopkit
Version: 1.2
Description: This is the base layout. It's included in every page with this code: {% extends 'base.tpl' %}
#}

<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<title>{{ title }}</title>
	<meta name="description" content="{{ description }}">
	<meta name="keywords" content="{{ tags }}">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">

	{% if store.show_branding %}
		<meta name="author" content="Shopkit">
	{% endif %}

	{% if store.translate_meta %}
		<meta name="google-translate-customization" content="{{ store.translate_meta }}">
	{% endif %}

	<!-- Facebook Meta -->
	<meta property="og:site_name" content="{{ store.name }}">
	<meta property="og:type" content="website">
	<meta property="og:title" content="{{ title }}">
	<meta property="og:description" content="{{ description }}">
	<meta property="og:url" content="{{ current_url() }}">

	{% if image %}
		<meta property="og:image" content="{{ image }}">
	{% endif %}

	{% if apps.facebook_comments.username %}
		<meta property="fb:admins" content="{{ apps.facebook_comments.username }}">
	{% endif %}
	<!-- End Facebook Meta -->

	<link rel="alternate" href="{{ site_url('rss') }}" type="application/rss+xml" title="{{ store.name }}">

	{% if store.favicon %}
		<link rel="shortcut icon" href="{{ store.favicon }}">
	{% endif %}

	<link rel="stylesheet" href="//fonts.googleapis.com/css?family=Roboto:400,100,100italic,300,300italic,400italic,500,500italic,700,700italic">
	<link rel="stylesheet" href="{{ store.assets.css }}">
	<link rel="stylesheet" href="//netdna.bootstrapcdn.com/font-awesome/4.6.0/css/font-awesome.min.css">

	{% if store.custom_css %}
		<style>{{ store.custom_css }}</style>
	{% endif %}

	<script src="{{ assets_url('js/common/modernizr-2.7.1.min.js')}}"></script>

	{{ store.custom_html }}

	{{ head_content }}

</head>
<body class="template-mosaic {{ css_class }} {{ product.price_on_request ? 'price-on-request' }}">

	<section class="sidebar">

		<header>

			<a href="{{ site_url('cart') }}" class="btn-cart btn-slide" data-target=".cart">
				<span>{{ cart.item_count }}</span>
				<i class="fa fa-shopping-cart"></i>
			</a>

			{% if apps.newsletter %}
				<a href="#" class="btn-newsletter btn-slide" data-target=".newsletter">
					<i class="fa fa-envelope"></i>
				</a>
			{% endif %}

			<a href="#" class="btn-navbar">
				<i class="fa fa-bars"></i>
			</a>

			<div class="inner-header">

				{% if store.logo %}
					<a href="/" class="logo"><img src="{{ store.logo }}" alt="{{ store.name }}"></a>
				{% else %}
					<h1 class="logo"><a href="/">{{ store.name }}</a></h1>
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
						<input type="search" placeholder="PESQUISAR" name="q">
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
					{% if store.facebook %}<li><a target="_blank" href="{{ store.facebook }}"><i class="fa fa-facebook"></i></a></li>{% endif %}
					{% if store.twitter %}<li><a target="_blank" href="{{ store.twitter }}"><i class="fa fa-twitter"></i></a></li>{% endif %}
					{% if store.instagram %}<li><a target="_blank" href="{{ store.instagram }}"><i class="fa fa-instagram"></i></a></li>{% endif %}
					{% if store.pinterest %}<li><a target="_blank" href="{{ store.pinterest }}"><i class="fa fa-pinterest"></i></a></li>{% endif %}
					<li><a href="{{ site_url('rss') }}"><i class="fa fa-rss"></i></a></li>
					{% if apps.google_translate %}<li><a href="#modal-language" role="button" data-toggle="modal"><i class="fa fa-language"></i></a></li>{% endif %}
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
                {% if store.payments.paypal.active %}
                    <img src="{{ assets_url('templates/assets/common/icons/payments/paypal.png') }}" alt="Paypal" title="Paypal" height="35">
                {% endif %}

                {% if store.payments.multibanco.active %}
                    <img src="{{ assets_url('templates/assets/common/icons/payments/multibanco.png') }}" alt="Multibanco" title="Multibanco" height="35">
                {% endif %}

                {% if store.payments.on_delivery.active %}
                    <img src="{{ assets_url('templates/assets/common/icons/payments/contra-reembolso.png') }}" alt="Contra Reembolso" title="Contra Reembolso" height="35">
                {% endif %}

                {% if store.payments.bank_transfer.active %}
                    <img src="{{ assets_url('templates/assets/common/icons/payments/transferencia-bancaria.png') }}" alt="Transferência Bancária" title="Transferência Bancária" height="35">
                {% endif %}

                {% if store.payments.pick_up.active %}
                    <img src="{{ assets_url('templates/assets/common/icons/payments/levantamento.png') }}" alt="Levantamento nas instalações" title="Levantamento nas instalações" height="35">
                {% endif %}
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
				<li {% if (current_page == 'catalog') %} class="active" {% endif %}>
					<a href="{{ site_url('catalog') }}">Todos os produtos</a>
				</li>
				{% for products_category in categories %}
					<li {% if (category.id == products_category.id) %}class="active"{% endif %}><a href="{% if products_category.total_products > 0 or products_category.children == false %}{{ products_category.url }} {% else %}#{% endif %}" data-toggle="collapse" data-target="#category_{{ products_category.id }}">{% if products_category.children %}<i class="fa fa-chevron-circle-down"></i> &nbsp; {% endif %}{{ products_category.title }}</a>
						{% if products_category.children %}
							<ul id="category_{{ products_category.id }}" class="collapse {% if (category.parent == products_category.id or product.categories[0].parent == products_category.id or category.id == products_category.id or category.id == products_category.id or products_category.id == product.categories[0].id) %}in{% endif %}">
								{% for children in products_category.children %}
									<li {% if (category.id== children.id or product.categories[0].id== children.id) %}class="active"{% endif %}><a href="{{ children.url }}"><i class="fa fa-angle-right"></i> {{ children.title }}</a></li>
								{% endfor %}
							</ul>
						{% endif %}
					</li>
				{% endfor %}
			</ul>

			<div class="text-center"><a class="close" href="#" data-target=".categories">&times;</a></div>
		</section>

	</div>

	{% if apps.newsletter %}
		<div class="newsletter slide-bar">

			<header>
				<h3>Newsletter</h3>
			</header>

			<section class="padding">
				<p>Inscreva-se na nossa newsletter para receber todas as novidades no seu e-mail.</p>
				<br>

				{{ form_open('newsletter/register') }}
					<input name="nome_newsletter" type="text" placeholder="Nome" class="input-block-level" required="">
					<input name="email_newsletter" type="email" placeholder="E-mail" class="input-block-level" required="">
					<button class="btn btn-inverse" type="submit">Registar</button>
				{{ form_close() }}

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

	{% if notices.newsletter_error or notices.newsletter_status_success or notices.newsletter_status_error or notices.newsletter_removal %}
		<div class="modal hide fade modal-alert">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">×</button>
				<h3>Newsletter</h3>
			</div>
			<div class="modal-body">

				{% if notices.newsletter_error %}
					<h5>Não foi possível efectuar o registo na newsletter:</h5>
					<p>{{ notices.newsletter_error }}</p>
				{% endif %}

				{% if notices.newsletter_status_success %}
					<p>O seu e-mail foi inscrito com sucesso.</p>
				{% endif %}

				{% if notices.newsletter_status_error %}
					<p>O seu e-mail já se encontra inscrito na nossa newsletter.</p>
				{% endif %}

				{% if notices.newsletter_removal %}
					<p>{{ notices.newsletter_removal }}</p>
				{% endif %}

			</div>
			<div class="modal-footer">
				<a href="#" class="btn" data-dismiss="modal">Fechar</a>
			</div>
		</div>
	{% endif %}

	{% if notices.paypal_success %}
		<div class="modal hide fade modal-alert">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">×</button>
				<h3>Paypal</h3>
			</div>
			<div class="modal-body">

				<p>O pagamento Paypal foi registado e processado com sucesso.</p>

			</div>
			<div class="modal-footer">
				<a href="#" class="btn" data-dismiss="modal">Fechar</a>
			</div>
		</div>
	{% endif %}

	{% if notices.cart %}
		<div class="modal hide fade modal-alert">
	  		<div class="modal-header">
	    		<button type="button" class="close" data-dismiss="modal">×</button>
	    		<h3>Carrinho de Compras</h3>
	  		</div>
	  		<div class="modal-body">

	  			{% set button_label = 'Fechar' %}

	  			{% if notices.cart.added %}
	    			<p>O produto <strong>{{ notices.cart.added }}</strong> foi adicionado ao carrinho.</p>
	    			{% set button_label = 'Continuar a comprar' %}
	    		{% endif %}

	    		{% if notices.cart.error %}
	    			<p>O produto não foi adicionado ao carrinho.</p>
	    			{% set button_label = 'Continuar a comprar' %}
	    		{% endif %}

	    		{% if notices.cart.updated %}
	    			<p>O carrinho de compras foi actualizado</p>
	    		{% endif %}

	    		{% if notices.cart.deleted %}
	    			<p>O produto foi removido do carrinho.</p>
	    		{% endif %}

	    		{% if notices.cart.stock_qty %}
	    			<p>Não existe stock suficiente do produto</p>
	    		{% endif %}

	    		{% if notices.cart.stock_sold_single %}
	    			<p>Só é possível comprar <strong>1 unidade</strong> do produto <strong>{{ notices.cart.stock_sold_single }}</strong></p>
	    		{% endif %}

	    		{% if notices.cart.no_stock %}
					<p>Existem produtos que não têm stock suficiente</p>
				{% endif %}

	  		</div>
	  		<div class="modal-footer">
	    		<a href="#" class="btn" data-dismiss="modal">{{ button_label }}</a>
	    		{% if notices.cart.added %}
	    			<a class="btn btn-inverse" href="{{ site_url('cart') }}"><i class="fa fa-shopping-cart"></i> Ver Carrinho</a>
	    		{% endif %}
	  		</div>
		</div>
	{% endif %}

	{% if notices.contact_form_success or notices.contact_form_errors %}
		<div class="modal hide fade modal-alert">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal">×</button>
				<h3>Formulário de Contacto</h3>
			</div>
			<div class="modal-body">

				{% if notices.contact_form_success %}
					<p>A sua mensagem foi enviada com sucesso. Obrigado pelo contacto.</p>
				{% endif %}

				{% if notices.contact_form_errors %}
					<p>Não foi possivel enviar a sua mensagem:</p>
					<p>{{ notices.contact_form_errors }}</p>
				{% endif %}

			</div>
			<div class="modal-footer">
				<a href="#" class="btn" data-dismiss="modal">Fechar</a>
			</div>
		</div>
	{% endif %}

	{% if apps.google_translate %}
		<div class="modal hide fade" id="modal-language" role="dialog" aria-labelledby="modal-languageLabel" aria-hidden="true">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h3 id="modal-languageLabel">Language</h3>
			</div>
			<div class="modal-body">
				<div id="google_translate_element"></div>
			</div>
			<div class="modal-footer">
				<button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
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

	<script src="//drwfxyu78e9uq.cloudfront.net/assets/common/vendor/jquery/1.9.1/jquery.min.js"></script>

	<script src="{{ store.assets.plugins }}"></script>
	<script src="{{ store.assets.scripts }}"></script>

	<script>

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

		Modernizr.load([
			{load: '//connect.facebook.net/pt_PT/all.js#xfbml=1&appId=267439666615965'}
			{% if apps.google_translate %} ,{load: '//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit'}{% endif %}
		]);

		{% if apps.google_translate %}
			function googleTranslateElementInit()
			{
				new google.translate.TranslateElement({pageLanguage: 'pt', includedLanguages: '{{ apps.google_translate.languages }}', gaTrack: true, gaId: 'UA-28055653-2'}, 'google_translate_element');
			}
		{% endif %}

		{% if store.custom_js %}
			{{ store.custom_js }}
		{% endif %}

	</script>

	{{ footer_content }}

</body>
</html>