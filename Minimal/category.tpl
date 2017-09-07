{#
Description: Product category page
#}

{% extends 'base.tpl' %}

{% block content %}

	{% set products_per_page = 9 %}

	{#  Parent category #}
	{% if category.parent %}
		{% set parent_category = category(category.parent) %}
	{% else %}
		{% set parent_category = category %}
	{% endif %}

	<div class="container">

		<div class="row">
			<div class="col-lg-3">

				<h1 class="margin-top-0 margin-bottom"><a href="{{ category.url }}" class="link-inherit">{{ category.title }}</a></h1>

				{% if category.parent %}
					<ol class="breadcrumb" itemscope itemtype="http://schema.org/BreadcrumbList">

						<li itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
							<a href="{{ parent_category.url }}" itemprop="item"><span itemprop="name">{{ parent_category.title }}</span></a>
							<meta itemprop="position" content="1" />
						</li>

						<li class="active" itemprop="itemListElement" itemscope itemtype="http://schema.org/ListItem">
							<a href="{{ category.url }}" itemprop="item"><span itemprop="name">{{ category.title }}</span></a>
							<meta itemprop="position" content="2" />
						</li>

					</ol>
				{% endif %}

				{% if category.description %}
					<div>{{ category.description }}</div>
				{% endif %}

				{#  Setup order #}
				{% set order_options = { 'position' : 'Relevância', 'title' : 'Título', 'newest' : 'Mais recentes', 'sales' : 'Mais vendidos', 'price_asc' : 'Mais baratos', 'price_desc' : 'Mais caros' } %}

				{% if not get.order_by in order_options|keys %}
					{% set get = {'order_by': store.category_default_order|default('position')} %}
				{% endif %}

				{% set products = products("order:#{get.order_by} category:#{category.id} limit:#{products_per_page}") %}

				{% if products %}
					<div class="order-options">
						<small>Ordenar por</small> &nbsp; 

						<div class="btn-group">
							<button type="button" class="btn btn-default btn-sm dropdown-toggle" data-toggle="dropdown">
								{% if get.order_by and order_options[get.order_by] %}
									{{ order_options[get.order_by] }}
								{% else %}
									{{ order_options['position'] }}
								{% endif %}
								<span class="caret"></span>
							</button>

							<ul class="dropdown-menu" role="menu">
								{% for order_option, order_title in order_options %}
									{% if order_option != get.order_by %}
										<li><a href="{{ category.url }}?order_by={{ order_option }}">{{ order_title }}</a></li>
									{% endif %}
								{% endfor %}
							</ul>
						</div>
					</div>
				{% endif %}

				{% if parent_category.children %}
					<div class="panel panel-default margin-bottom">

						<div class="panel-heading">
							<a href="{{ parent_category.url }}" class="link-inherit">{{ parent_category.title }}</a>
						</div>

						<div class="list-group">

							{% for product_category in categories %}
								{% if product_category.id == parent_category.id and product_category.children %}
									{% for children in product_category.children %}
										<a href="{{ children.url }}" class="list-group-item {% if children.id == category.id %}active{% endif %}">
											{{ children.title }} <span class="text-muted">({{ children.total_products }})</span>
										</a>
									{% endfor %}
								{% endif %}
							{% endfor %}

						</div>
					</div>
				{% endif %}
			</div>

			<div class="col-lg-9">
				<div class="products margin-top-0">
					<div class="row">

						{% for product in products %}
							<div class="col-sm-4">
								<article class="product product-id-{{ product.id }}">

									{% if product.promo == true %}
										<span class="badge promo">Promoção</span>
									{% endif %}

									<a href="{{ product.url }}"><img src="{{ product.image.square }}" class="img-responsive" alt="{{ product.title }}" title="{{ product.title }}" width="400" height="400"></a>

									<div class="product-info">
										<a class="product-details" href="{{ product.url }}">
											<div>
												<h2>{{ product.title }}</h2>

												<span class="price">
													{% if product.price_on_request == true %}
														Preço sob consulta
													{% else %}
														{% if product.promo == true %}
															 {{ product.price_promo | money_with_sign }} <del>{{ product.price | money_with_sign }}</del>
														{% else %}
															{{ product.price | money_with_sign }}
														{% endif %}
													{% endif %}
												</span>
											</div>
										</a>
									</div>

								</article>
							</div>
						{% else %}
							<div class="col-xs-12">
								<h3 class="margin-bottom-lg margin-top-0 text-gray light">Não existem produtos</h3>
							</div>
						{% endfor %}

					</div>
				</div>

				<nav class="text-center">
					{{ pagination("category:#{category.id} limit:#{products_per_page}") }}
				</nav>

			</div>
		</div>

	</div>

{% endblock %}