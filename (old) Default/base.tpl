{# 
Template Name: Shopkit Default Template
Author: Shopkit
Version: 2.4.2
Description: This is the base layout. It is included in every page with this code {% extends 'base.tpl' %}
Github: https://github.com/Shopkit/Default
#}

<!DOCTYPE html>
<!--[if lt IE 7]> <html class="no-js lt-ie9 lt-ie8 lt-ie7" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="no-js lt-ie9 lt-ie8" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="no-js lt-ie9" lang="en"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
<head>
	<meta charset="utf-8">
	<title>{{ title }}</title>
	
	<meta name="description" content="{{ description }}">
	<meta name="keywords" content="{{ tags }}">
	<meta name="author" content="Shopkit">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	
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
	 
	{% if store.favicon %}
		<link rel="shortcut icon" href="{{ store.favicon }}">
	{% endif %}
	
	<link rel="alternate" href="{{ site_url('rss') }}" type="application/rss+xml" title="{{ store.name }}">
	<link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="{{ store.assets.css }}">
    
	{% set darkencolor = colour_brightness(store.basecolor, -0.90) %} 
	
	<style>
		a, h1 { color: {{ store.basecolor }}; } 
		.product:hover .box, .table-cart th { background: {{ store.basecolor }}; }
		.col-left h3 { background-color:{{ store.basecolor }};background-image:-moz-linear-gradient(top,{{ store.basecolor }},{{ darkencolor }});background-image:-webkit-gradient(linear,0 0,0 100%,from({{ store.basecolor }}),to({{ darkencolor }}));background-image:-webkit-linear-gradient(top,{{ store.basecolor }},{{ darkencolor }});background-image:-o-linear-gradient(top,{{ store.basecolor }},{{ darkencolor }});background-image:linear-gradient(to bottom,{{ store.basecolor }},{{ darkencolor }});background-repeat:repeat-x;filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='{{ store.basecolor }}',endColorstr='{{ darkencolor }}',GradientType=0); }
		.table-cart th:first-child { border-left: 1px solid {{ store.basecolor }}; }
		.col-left h3:before { border-top: 7px solid {{ darkencolor }}; }

		.data-product-on-request { display: none; }
		.price-on-request .data-product-on-request { display: block; }
		.price-on-request .data-product-info { display: none; }

		{% if store.custom_css %}
			{{ store.custom_css }}
		{% endif %}
	</style>
	
	<script src="{{ assets_url('js/common/modernizr-2.5.3.min.js')}}"></script>

	{{ store.custom_html }}

	{{ head_content }}
	
</head>
<body class="{{ css_class }} {{ product.price_on_request ? 'price-on-request' }}">
	
	<div class="container">
	
		<header>

			{% if store.notice %}
				<div class="store-notice">{{ store.notice }}</div>
			{% endif %}
			
			<div class="clearfix">
				{% if store.logo %}
					<p class="logo pull-left"><a href="/"><img src="{{ store.logo }}" alt="{{ store.name }}"></a></p>
				{% else %}
					<h1 class="logo pull-left"><a href="/">{{ store.name }}</a></h1>
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
		        	
		        	<p class="cart-header-totals"><span class="pull-left">Total: <strong class="price">{{ cart.subtotal | money_with_sign }}</strong></span> <span class="pull-right"><a href="{{ site_url('cart') }}">Ver Carrinho ›</a></span></p>
				</aside>
	        	<!-- END CART -->
        	</div>
        	
        	
        	<div class="navbar navbar-inverse">
    			<div class="navbar-inner">
	    			<div class="container">
	    				<a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
          					<i class="fa fa-bars fa-lg"></i>
        				</a>
	    				<div class="nav-collapse">
          					<ul class="nav">
          						{% for primary_navigation in store.navigation.primary %}
					            	<li class="menu-{{ primary_navigation.menu_text|slug }}"><a href="{{ primary_navigation.menu_url }}" {{ primary_navigation.target_blank ? 'target="_blank"' }}>{{ primary_navigation.menu_text }}</a></li>
					            	<li class="divider-vertical divider-{{ primary_navigation.menu_text|slug }}"></li>
					            {% endfor %}
					  		</ul>
					  		<form action="{{ site_url('search') }}" class="navbar-search pull-right">
            					<input type="text" name="q" placeholder="Pesquisar" class="search-query span2">
          					</form>
        				</div>
	    			</div>
    			</div>
    		</div>
    		
    		{% if store.image_header_1 %}

	    		<div class="slideshow-wrapper visible-desktop">

	    			{% if store.description %}
	    				<p class="slideshow-description">{{ store.description }}</p>
	    			{% endif %}

		    		<div class="slideshow">
		    			<div>
		    				<img src="{{ store.image_header_1 }}" alt="{{ store.name }}">
		    			</div>
		        	</div>
		        </div>

        	{% endif %}
        	
		</header>
	
		<div class="main" role="main">
			
			<div class="row show-grid">
				
			    <aside class="span3 col-left">
			    	
			    	<h3>Produtos</h3>
			    	
			    	<nav>
				    	<ul>
				    		{% for products_category in categories %} 
				    		
				      			<li {% if (category.id == products_category.id) %}class="active"{% endif %}>
				      				<h4 data-toggle="collapse" data-target="#category_{{ products_category.id }}">
				      					<a href="{% if products_category.total_products > 0 or products_category.children == false %}{{ products_category.url }} {% else %}#{% endif %}">{{ products_category.title }}</a>
				      				</h4>
				      				
				      				{% if products_category.children %}
					      				<ul id="category_{{ products_category.id }}" class="collapse {% if (category.parent == products_category.id or category.id == products_category.id or category.id == products_category.id) %}in{% endif %}">
					      					{% for children in products_category.children %}
					      						<li {% if (category.id== children.id) %}class="active"{% endif %}>
					      							<a href="{{ children.url }}">{{ children.title }}</a>
					      						</li>
					      					{% endfor %}
					      				</ul>
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

							{{ form_open('newsletter/register') }}
								<input name="nome_newsletter" type="text" placeholder="Nome" class="span3" required>
								<input name="email_newsletter" type="text" placeholder="E-mail" class="span3" required>
								<button class="btn btn-inverse" type="submit">Registar</button>
							{{ form_close() }}

						</section>
					{% endif %}

					{% if apps.facebook_page %}
						<hr>
						<div class="fb-like-box hidden-phone" data-href="{{ apps.facebook_page.facebook_url }}"  data-show-faces="true" data-show-border="false" data-stream="false" data-header="false"></div>
					{% endif %}

					<hr>

					<div class="payment-logos" style="text-align:center">
						{% spaceless %}
							{% if payment.paypal %}
								<img src="{{ assets_url('templates/assets/common/icons/payments/paypal.png') }}" alt="Paypal" title="Paypal" style="margin: 0px 4px 8px 4px; width: 55px; opacity: 0.8">
							{% endif %}

							{% if payment.multibanco %}
								<img src="{{ assets_url('templates/assets/common/icons/payments/multibanco.png') }}" alt="Multibanco" title="Multibanco" style="margin: 0px 4px 8px 4px; width: 55px; opacity: 0.8">
							{% endif %}

							{% if payment.on_delivery %}
								<img src="{{ assets_url('templates/assets/common/icons/payments/contra-reembolso.png') }}" alt="Contra Reembolso" title="Contra Reembolso" style="margin: 0px 4px 8px 4px; width: 55px; opacity: 0.8">
							{% endif %}

							{% if payment.bank_transfer %}
								<img src="{{ assets_url('templates/assets/common/icons/payments/transferencia-bancaria.png') }}" alt="Transferência Bancária" title="Transferência Bancária" style="margin: 0px 4px 8px 4px; width: 55px; opacity: 0.8">
							{% endif %}

							{% if payment.pick_up %}
								<img src="{{ assets_url('templates/assets/common/icons/payments/levantamento.png') }}" alt="Levantamento nas instalações" title="Levantamento nas instalações" style="margin: 0px 4px 8px 4px; width: 55px; opacity: 0.8">
							{% endif %}
						{% endspaceless %}
					</div>

			    </aside>
			    	
			    <aside class="span9  col-right">
			    	
			    	{% block content %}{% endblock %} 
			    	
			    </aside>
			    
  			</div>
			
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

	    	{% if store.show_branding %}
	    		<p style="margin-top:40px; text-align: center; opacity:0.25; color: #000; font-size: 9px">Powered by<br><a href="https://shopk.it/?utm_source={{ store.username }}&amp;utm_medium=referral&amp;utm_campaign=Shopkit-Stores-Branding" target="_blank"><img src="https://drwfxyu78e9uq.cloudfront.net/assets/frontend/img/logo-shopkit-black.png" alt="Shopkit" title="Powered by Shopkit" style="height:25px;"></a></p>
	    	{% endif %}

		</footer>
		
	</div>
	
	
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
		<a class="btn-language visible-desktop" href="#modal-language" role="button"  data-toggle="modal"></a>
	{% endif %}
	
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
	
	<script src="//drwfxyu78e9uq.cloudfront.net/assets/common/vendor/jquery/1.7.2/jquery.min.js"></script>

	<script src="{{ store.assets.plugins }}"></script>
	<script src="{{ store.assets.scripts }}"></script>

	<script>

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

		{{ cross_slide_js(store.images_header) }}

		Modernizr.load([
			{load: '//platform.twitter.com/widgets.js'},
			{load: '//apis.google.com/js/plusone.js'},
			{load: '//connect.facebook.net/pt_PT/all.js#xfbml=1&appId=267439666615965'},
			{load: '//assets.pinterest.com/js/pinit.js'}
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
