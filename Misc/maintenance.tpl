<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{{ store.name }}</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css">
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
			padding: 60px;
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

		.cogs {
			position: relative;
			display: inline-block;
			width: 175px;
			height: 175px;
			border-radius: 50%;
		}

		.cogs i {
			color: #fff;
		}

		.cog-big {
			position: absolute;
			top:37px;
			left: 21px;
			display: block;
			font-size: 100px;
			line-height: 100%;
			-webkit-animation-name:spin;-moz-animation-name:spin;-ms-animation-name:spin;-o-animation-name:spin;animation-name:spin;-webkit-animation-duration:3000ms;-moz-animation-duration:3000ms;-ms-animation-duration:3000ms;-o-animation-duration:3000ms;animation-duration:3000ms;-webkit-animation-timing-function:linear;-moz-animation-timing-function:linear;-ms-animation-timing-function:linear;-o-animation-timing-function:linear;animation-timing-function:linear;-webkit-animation-iteration-count:infinite;-moz-animation-iteration-count:infinite;-ms-animation-iteration-count:infinite;-o-animation-iteration-count:infinite;animation-iteration-count:infinite;
		}

		.cog-small {
			position: absolute;
			top:37px;
			left: 111px;
			display: block;
			font-size: 50px;
			line-height: 100%;
			-webkit-animation-name:spin;-moz-animation-name:spin;-ms-animation-name:spin;-o-animation-name:spin;animation-name:spin;-webkit-animation-duration:4000ms;-moz-animation-duration:4000ms;-ms-animation-duration:4000ms;-o-animation-duration:4000ms;animation-duration:4000ms;-webkit-animation-timing-function:linear;-moz-animation-timing-function:linear;-ms-animation-timing-function:linear;-o-animation-timing-function:linear;animation-timing-function:linear;-webkit-animation-iteration-count:infinite;-moz-animation-iteration-count:infinite;-ms-animation-iteration-count:infinite;-o-animation-iteration-count:infinite;animation-iteration-count:infinite;
		}

		.cog-small-2 {
			position: absolute;
			top:87px;
			left: 111px;
			display: block;
			font-size: 50px;
			line-height: 100%;
			-webkit-animation-name:spin-inverse;-moz-animation-name:spin-inverse;-ms-animation-name:spin-inverse;-o-animation-name:spin-inverse;animation-name:spin-inverse;-webkit-animation-duration:2000ms;-moz-animation-duration:2000ms;-ms-animation-duration:2000ms;-o-animation-duration:2000ms;animation-duration:2000ms;-webkit-animation-timing-function:linear;-moz-animation-timing-function:linear;-ms-animation-timing-function:linear;-o-animation-timing-function:linear;animation-timing-function:linear;-webkit-animation-iteration-count:infinite;-moz-animation-iteration-count:infinite;-ms-animation-iteration-count:infinite;-o-animation-iteration-count:infinite;animation-iteration-count:infinite;
		}

		@keyframes "spin"{from{-webkit-transform:rotate(0);-moz-transform:rotate(0);-ms-transform:rotate(0);-o-transform:rotate(0);transform:rotate(0);}to{-webkit-transform:rotate(360deg);-moz-transform:rotate(360deg);-ms-transform:rotate(360deg);-o-transform:rotate(360deg);transform:rotate(360deg);}}@-moz-keyframes spin{from{-moz-transform:rotate(0);transform:rotate(0);}to{-moz-transform:rotate(360deg);transform:rotate(360deg);}}@-webkit-keyframes "spin"{from{-webkit-transform:rotate(0);transform:rotate(0);}to{-webkit-transform:rotate(360deg);transform:rotate(360deg);}}@-ms-keyframes "spin"{from{-ms-transform:rotate(0);transform:rotate(0);}to{-ms-transform:rotate(360deg);transform:rotate(360deg);}}@-o-keyframes "spin"{from{-o-transform:rotate(0);transform:rotate(0);}to{-o-transform:rotate(360deg);transform:rotate(360deg);}}@keyframes "spin-inverse"{from{-webkit-transform:rotate(0);-moz-transform:rotate(0);-ms-transform:rotate(0);-o-transform:rotate(0);transform:rotate(0);}to{-webkit-transform:rotate(-360deg);-moz-transform:rotate(-360deg);-ms-transform:rotate(-360deg);-o-transform:rotate(-360deg);transform:rotate(-360deg);}}@-moz-keyframes spin-inverse{from{-moz-transform:rotate(0);transform:rotate(0);}to{-moz-transform:rotate(-360deg);transform:rotate(-360deg);}}@-webkit-keyframes "spin-inverse"{from{-webkit-transform:rotate(0);transform:rotate(0);}to{-webkit-transform:rotate(-360deg);transform:rotate(-360deg);}}@-ms-keyframes "spin-inverse"{from{-ms-transform:rotate(0);transform:rotate(0);}to{-ms-transform:rotate(-360deg);transform:rotate(-360deg);}}@-o-keyframes "spin-inverse"{from{-o-transform:rotate(0);transform:rotate(0);}to{-o-transform:rotate(-360deg);transform:rotate(-360deg);}}
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
  			<div class="cogs">
				<i class="fa fa-cog cog-big"></i>
				<i class="fa fa-cog cog-small"></i>
				<i class="fa fa-cog cog-small-2"></i>
			</div>
  		</div>
  	</div>

  	<div class="text-center content">
  		<div class="container">
  			{% if store.logo %}
  				<a href="{{ site_url() }}"><img src="{{ store.logo }}" alt="{{ store.name }}" class="logo"></a>
			{% else %}
				<h1 class="logo"><a href="{{ site_url() }}">{{ store.name }}</a></h1>
			{% endif %}
	  		<h2>Estamos em manutenção</h2>
	  		<p>Voltamos dentro de instantes</p>
	  	</div>
  	</div>

	{% if store.show_branding %}
	  	<footer class="text-center">
	  		<div class="container">
				<a href="https://shopk.it/?utm_source={{ store.username }}&amp;utm_medium=referral&amp;utm_campaign=Shopkit-Stores-Branding" target="_blank"><img class="logo-footer" src="https://drwfxyu78e9uq.cloudfront.net/assets/frontend/img/logo-shopkit-black-transparent.png" title="Powered by Shopkit" height="25" style="border:0;" border="0" alt="Powered by Shopkit" /></a>
			</div>
	  	</footer>
  	{% endif %}

  </body>
</html>