<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ store.page_title }}</title>
	{% if store.favicon %}
		<link rel="shortcut icon" href="{{ store.favicon }}">
	{% endif %}
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <style type="text/css">
		.jumbotron {
			text-align: center;
			color: #fff;
			margin-bottom: 0;
			padding-top:90px;
			padding-bottom:90px;
			background-color: {{ store.basecolor }};
		}
		.jumbotron h4 {
			font-size: 72px;
			font-weight: 100;
			margin: 0;
		}
		.content {
			padding-top:60px;
			padding-bottom:60px;
			background-color: #fff;
		}
		.content h2 {
			color: #666;
			margin-bottom: 15px;
			margin-top: 0;
		}
		.content p {
			color: #999;
		}
		.content .btn-lg {
			margin-top: 30px;
		}
		footer {
			background-color: #fff;
			padding: 60px 0;
			border-top: 1px solid #eee;
		}
		img.logo {
			height: 60px;
			margin-bottom: 60px;
		}
		h1.logo {
			margin-top: 0;
			margin-bottom: 60px;
			font-weight: 100;
			font-size: 48px;
		}
		h1.logo a {
			color: #000;
		}
    </style>
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
    <![endif]-->
  </head>
  <body>

  	<div class="jumbotron">
  		<div class="container">
  			<h4>{{ 'lang.storefront.page_not_found.ops.title'|t }}</h4>
  		</div>
  	</div>

  	<div class="text-center content">
  		<div class="container">
  			{% if store.logo %}
  				<a href="{{ site_url() }}"><img src="{{ store.logo }}" alt="{{ store.name }}" class="logo"></a>
			{% else %}
				<h1 class="logo"><a href="{{ site_url() }}">{{ store.name }}</a></h1>
			{% endif %}
	  		<h2>{{ 'lang.storefront.page_not_found.title'|t }}</h2>
	  		<p>{{ 'lang.storefront.page_not_found.text'|t }}</p>
	  		<a href="{{ site_url() }}" class="btn btn-lg btn-default">{{ 'lang.storefront.page_not_found.button'|t }}</a>
	  	</div>
  	</div>

	{% if store.show_branding %}
	  	<footer class="text-center">
	  		<div class="container">
				<a href="https://shopk.it/?utm_source={{ store.username }}&amp;utm_medium=referral&amp;utm_campaign=Shopkit-Stores-Branding" title="Powered by Shopkit e-commerce" target="_blank" rel="nofollow"><img class="logo-footer" src="{{ assets_url('assets/frontend/img/logo-shopkit-black-transparent.png') }}" title="Powered by Shopkit e-commerce" height="25" style="border:0;" border="0" alt="Powered by Shopkit e-commerce" /></a>
			</div>
	  	</footer>
  	{% endif %}

  </body>
</html>