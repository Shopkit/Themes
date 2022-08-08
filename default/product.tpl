{#
Description: Product Page
#}

{% extends 'base.tpl' %}

{% block content %}

	<article>

		<ul class="breadcrumb">
			<li><a href="{{ site_url() }}">Home</a><span class="divider">›</span></li>
			<li class="active">{{ product.title }}</li>
		</ul>

		<div class="row">

			<div class="span4">

				<a href="{{ product.image.full }}" class="box-medium fancy" rel="{{ product.id }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image.full }}" alt="{{ product.title|e_attr }}" class="product-image lazy"></a>

				{% if product.images %}

					<div class="row thumbs hidden-phone">
						<div class="span1"><a href="{{ product.image.full }}" class="fancy" rel="{{ product.id }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image.square }}" alt="{{ product.title|e_attr }}" class="lazy"></a></div>
						{% for thumb in product.images %}
							<div class="span1"><a href="{{ thumb.full }}" class="fancy" rel="{{ product.id }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ thumb.square }}" alt="{{ product.title|e_attr }}" class="lazy"></a></div>
						{% endfor %}
					</div>

				{% endif %}

			</div>

			<div class="span5">

				<h1 class="product-title">{{ product.title }}</h1>

				<div>
					<h4 class="price">

						{% if product.price_on_request == true %}
							<span class="data-product-price">Preço sob consulta</span> &nbsp;
							<del></del>
						{% else %}
							{% if product.promo == true %}
								<span class="data-product-price">{{ product.price_promo | money_with_sign }}</span> &nbsp;
								<del>{{ product.price | money_with_sign }}</del>
							{% else %}
								<span class="data-product-price">{{ product.price | money_with_sign }}</span> &nbsp;
								<del></del>
							{% endif %}
						{% endif %}

					</h4>

					{% if user.wholesale is same as(true) and product.wholesale == true and store.settings.wholesale.show_regular_price %}
						<p><small class="muted">
							Preço normal: <span class="data-price-non-wholesale">{{ product.price_non_wholesale | money_with_sign }}</span>
						</small></p>
                    {% elseif product.price_promo_percentage == true %}
						<p><small class="muted data-promo-percentage">
							Desconto de {{ product.price_promo_percentage }}%
						</small></p>
					{% endif %}
				</div>

				<br>

				{{ form_open_cart(product.id, { 'class' : 'well form-inline form-cart add-cart' }) }}

					<h4>Adicionar ao carrinho</h4>

					{% if product.reference %}
						<h6><small>Referência: <span class="sku">{{ product.reference }}</span></small></h6>
					{% endif %}

					<br>

					{% if product.status == 1 or (product.status == 3 and product.stock.stock_backorder) %}

						{% if product.option_groups %}
							{% for option_groups in product.option_groups %}

								<h6>{{ option_groups.title }}</h6>

								<select class="span3 select-product-options" name="option[]">
									{% for option in option_groups.options %}

										<option value="{{ option.id }}" data-title="{{ option.title }}">
											{{ option.title }}
										</option>

									{% endfor %}
								</select>

							{% endfor %}

							<hr>

						{% endif %}

						<div class="data-product-info">
							Quantidade &nbsp;
							<input type="number" class="span1" name="qtd" value="1" min="1" {% if product.stock.stock_sold_single %} data-toggle="tooltip" data-placement="bottom" data-original-title="Só é possível comprar 1 unidade deste produto." title="Só é possível comprar 1 unidade deste produto." readonly {% endif %}>
							<button class="btn btn-inverse" type="submit">
								<i class="fa fa-shopping-cart fa-lg fa-fw"></i> Comprar
							</button>

							{% if product.tax > 0 %}
								<hr>
								{% if store.taxes_included == false %}
									<span class="muted">Ao preço acresce {{ user.l10n.tax_name }} a {{ product.tax }}%</span>
								{% else %}
									<span class="muted">{{ user.l10n.tax_name }} incluído</span>
								{% endif %}
							{% endif %}

							{% if product.stock.stock_show %}
								<hr>
								<h6>Stock</h6>
								<em class="muted"><span class="data-product-stock_qty">{{ product.stock.stock_qty }}</span> unidades em stock</em>
							{% endif %}
						</div>

						<div class="data-product-on-request">
							<a class="btn btn-inverse price-on-request" href="{{ site_url("contact?p=") ~ "Produto #{product.title}"|url_encode }}">
								<i class="fa fa-envelope-o fa-lg fa-fw"></i> Contactar
							</a>
						</div>

					{% elseif product.status == 3 %}
						<div class="alert alert-info">O produto encontra-se sem stock.</div>

					{% elseif product.status == 4 %}
						<div class="alert alert-info">O produto estará disponível brevemente.</div>

					{% endif %}

					{% if user.is_logged_in %}
						<div class="wishlist margin-top-sm">
							{% if not product.wishlist.status %}
								<a href="{{ product.wishlist.add_url }}" class="text-muted"><i class="fa fa-heart fa-fw"></i> Adicionar à wishlist</a>
							{% else %}
								<a href="{{ product.wishlist.remove_url }}" class="text-muted"><i class="fa fa-heart-o fa-fw"></i> Remover da wishlist</a>
							{% endif %}
						</div>
					{% endif %}

				{{ form_close() }}

			</div>

			<div class="span9">
				<div class="tabbable margin-top"> <!-- Only required for left/right tabs -->
					<ul class="nav nav-tabs">
						{% if product.description %}
							<li class="active">
								<a href="#tab-description" data-toggle="tab">Descrição</a>
							</li>
						{% endif %}
						{% if product.tabs %}
							{% for tab in product.tabs %}
								<li>
									<a href="#tab-{{ tab.slug }}" data-toggle="tab">{{ tab.title }}</a>
								</li>
							{% endfor %}
						{% endif %}
						{% if product.video_embed_url %}
							<li>
								<a href="#tab-video" data-toggle="tab">Vídeo</a>
							</li>
						{% endif %}
						{% if apps.facebook_comments.comments_products %}
							<li>
								<a href="#tab-comments" data-toggle="tab">Comentários</a>
							</li>
						{% endif %}
					</ul>

					<div class="tab-content">
						{% if product.description %}
							<div class="tab-pane active" id="tab-description">
								{{ product.description }}


							</div>
						{% endif %}
						{% if product.tabs %}
							{% for tab in product.tabs %}
								<div class="tab-pane" id="tab-{{ tab.slug }}">
									{{ tab.content }}
								</div>
							{% endfor %}
						{% endif %}
						{% if product.video_embed_url %}
							<div class="tab-pane" id="tab-video">
								<div class="row">
									<div class="span9 video-wrapper">
										<div class="video-iframe" data-src="{{ product.video_embed_url }}">Video</div>
									</div>
								</div>
							</div>
						{% endif %}
						{% if apps.facebook_comments.comments_products %}
							<div class="tab-pane" id="tab-comments">
								<div class="fb-comments" data-href="{{ product.permalink }}" data-num-posts="5" data-colorscheme="light" data-width="100%"></div>
							</div>
						{% endif %}

						<div class="well well-small margin-top">
							{% if product.file %}
								<div class="file inline-block">
									<h6 style="margin-top:0">Ficheiro Anexo</h6>
									<a class="btn file-download" href="{{ product.file }}" target="_blank"><i class="fa fa-download"></i> <strong>Download</strong></a>
								</div>
							{% endif %}

							<div class="share {{ product.file ? 'pull-right' }}">
								<h6 style="margin-top:0">Partilhar</h6>
								<a target="_blank" href="http://www.facebook.com/sharer.php?u={{ product.url }}" class="text-muted"><i class="fa fa-lg fa-facebook fa-fw"></i></a> &nbsp;
								<a target="_blank" href="https://wa.me/?text={{ "#{product.title}: #{product.url}"|url_encode }}" class="text-muted"><i class="fa fa-lg fa-whatsapp fa-fw"></i></a> &nbsp;
								<a target="_blank" href="https://twitter.com/share?url={{ product.url }}&text={{ character_limiter(description, 100)|url_encode }}" class="text-muted"><i class="fa fa-lg fa-twitter fa-fw"></i></a> &nbsp;
								<a target="_blank" href="https://pinterest.com/pin/create/bookmarklet/?media={{ product.image.full }}&url={{ product.url }}&description={{ product.title|url_encode }}" class="text-muted"><i class="fa fa-lg fa-pinterest fa-fw"></i></a>
							</div>
						</div>
					</div>
				</div>

				<hr>

				{% if product.custom_fields or product.brand or product.tags %}
					<div class="table-product-attributes margin-top">
						<div class="table-responsive">
							<table class="table">
								{% if product.brand %}
									<tr class="product-brand">
										<th>Marca</th>
										<td><a href="{{ product.brand.url }}" class="text-underline">{{ product.brand.title }}</a></td>
									</tr>
								{% endif %}

								{% if product.tags %}
									<tr class="product-tags">
										<th>Tags</th>
										<td>
											<ul class="inline unstyled">
												{% for tag in product.tags %}<li><a href="{{ tag.url }}" class="product-tag label label-outline">{{ tag.title }}</a></li>{% endfor %}
											</u>
										</td>
									</tr>
								{% endif %}

								{% for custom_field in product.custom_fields %}
									<tr class="product-custom-fields" id="custom_field_{{ custom_field.alias }}">
										<th>{{ custom_field.title }}</th>
										<td>{{ custom_field.value }}</td>
									</tr>
								{% endfor %}
							</table>
						</div>
					</div>
				{% endif %}

				<div class="related-products margin-top hidden" data-load="related-products" data-products="{{ product.id }}" data-num-products="3" data-products-per-row="3" data-css-class-wrapper="product-related-products">
					<div class="text-center">
						<h3 class="products-title margin-bottom">{{ product.related_products.title }}</h3>
						<div class="related-products-placement"></div>
					</div>
				</div>
			</div>

		</div>

	</article>

{% endblock %}