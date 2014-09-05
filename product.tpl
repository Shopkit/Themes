{# 
Description: Product Page
#}

{% extends 'base.tpl' %}

{% block content %}

	<script>
		//Javascript object with product information
		var product = {{ json_encode(product) }};
	</script>
	
	<article itemscope itemtype="http://schema.org/Product">

		<ul class="breadcrumb">
			<li><a href="/">Home</a><span class="divider">›</span></li>
			<li class="active">{{ product.title }}</li>
		</ul>

		<div class="row">

			<div class="span4">

				<a href="{{ product.image.full }}" class="box-medium fancy" rel="{{ product.id }}"><img src="{{ product.image.full }}" alt="{{ product.title }}" itemprop="image"></a>

				{% if product.images %}

					<div class="row thumbs hidden-phone">
						{% for thumb in product.images %}
							<div class="span1"><a href="{{ thumb.full }}" class="fancy" rel="{{ product.id }}"><img src="{{ thumb.square }}" alt="{{ product.title }}"></a></div>
						{% endfor %}
					</div>

				{% endif %}

				{% if product.video_embed_url %}

					<hr>
					<div class="row hidden-phone">
						<div class="span4 video-wrapper">
							<div class="video-iframe" data-src="{{ product.video_embed_url }}">Video</div>
						</div>
					</div>

				{% endif %}

			</div>

			<div class="span5">

				<h1 itemprop="name">{{ product.title }}</h1>

				<div itemprop="offers" itemscope itemtype="http://schema.org/Offer">
					<meta itemprop="priceCurrency" content="{{ store.currency }}" />
					<h4 class="price">
						{% if product.promo == true %}
							<del>{{ product.price | money_with_sign }}</del> &nbsp; <span itemprop="price" class="data-product-price">{{ product.price_promo | money_with_sign }}</span>
						{% else %}
							<span itemprop="price" class="data-product-price">{{ product.price | money_with_sign }}</span>
						{% endif %}
					</h4>

				</div>

				<br>

				{{ form_open_cart(product.id, { 'class' : 'well form-inline form-cart' }) }}

					<h4>Adicionar ao carrinho</h4>
					
					{% if product.reference %}
						<h6><small>Referência: <span itemprop="sku">{{ product.reference }}</span></small></h6>
					{% endif %}
					
					<br>
					
					{% if product.status == 1 or (product.status == 3 and product.stock.stock_backorder) %}
						
						{% if product.option_groups %}
							{% for option_groups in product.option_groups %}

								<h6>{{ option_groups.title }}</h6>

								<select class="span3 select-product-options" name="option[]">
									{% for option in option_groups.options %}
										<option value="{{ option.id }}">{{ option.title }}</option>
									{% endfor %}
								</select>

							{% endfor %}

							<hr>

						{% endif %}

						Quantidade &nbsp;
						<input type="text" class="span1" name="qtd" value="1" {% if product.stock.stock_sold_single %} data-toggle="tooltip" data-placement="bottom" data-original-title="Só é possível comprar 1 unidade deste produto." title="Só é possível comprar 1 unidade deste produto." readonly {% endif %}>
						<button class="btn btn-inverse" type="submit">
							<i class="icon-shopping-cart icon-white"></i> Comprar
						</button>

						{% if store.taxes_included == false and product.tax > 0 %}
							<hr>
							<span class="muted">Ao preço do produto acresce IVA de {{ product.tax }}%</span>
						{% endif %}

						{% if product.stock.stock_show %}
							<hr>
							<h6>Stock</h6>
							<em class="muted"><span class="data-product-stock_qty">{{ product.stock.stock_qty }}</span> unidades em stock</em>
						{% endif %}
					
					{% elseif product.status == 3 %}
						<div class="alert alert-info">O produto encontra-se sem stock.</div>
					
					{% elseif product.status == 4 %}
						<div class="alert alert-info">O produto estará disponível brevemente.</div>
					
					{% endif %}
				
				{{ form_close() }}

				<p itemprop="description" content="{{ description }}">{{ product.description }}</p>

				{% if product.file %}
					<div class="well well-small">
						<h6 style="margin-top:0">Ficheiro Anexo</h6>
						<a class="btn" href="{{ product.file }}" target="_blank"><i class="icon-download"></i> <strong>Download</strong> <span class="muted">({{ file_size(product.file) }})</span></a>
					</div>
				{% endif %}

				<hr>

				<div class="row visible-desktop">
					<div class="span2">
						<div class="fb-like" data-send="true" data-width="" data-show-faces="false" data-font="tahoma" data-layout="button_count" data-action="like"></div>
					</div>

					<div class="span1">
						<g:plusone size="medium"></g:plusone>
					</div>

					<div class="span1">
						<a href="http://twitter.com/share" class="twitter-share-button" data-count="none" data-lang="pt">Tweet</a>
					</div>

					<div class="span1">
						<a href="http://pinterest.com/pin/create/button/?url={{ product.url }}&media={{ product.image.full }}&description={{ clean(product.description) }}" class="pin-it-button" count-layout="horizontal"><img border="0" src="//assets.pinterest.com/images/PinExt.png" title="Pin It" /></a>
					</div>
				</div>

			</div>

		</div>

	</article>

	{% if store.facebook_comments_product %}

		<div class="hidden-phone">
			<hr>
			<h6>Comentários</h6>
			<br>
			<div class="fb-comments" data-href="{{ product.permalink }}" data-num-posts="5"></div>
		</div>

	{% endif %}

{% endblock %}