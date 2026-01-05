{#
Description: Home Page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	<div class="{{ layout_container }}">

		<ul class="social">
			{% if store.facebook %}
				<li><a href="{{ store.facebook }}" target="_blank" title="{{ 'lang.storefront.layout.social.facebook'|t }}">{{ icons('facebook-f') }}</a></li>
			{% endif %}

			{% if store.twitter %}
				<li><a href="{{ store.twitter }}" target="_blank" title="{{ 'lang.storefront.layout.social.twitter'|t }}">{{ icons('twitter') }}</a></li>
			{% endif %}

			{% if store.instagram %}
				<li><a href="{{ store.instagram }}" target="_blank" title="{{ 'lang.storefront.layout.social.instagram'|t }}">{{ icons('instagram') }}</a></li>
			{% endif %}

			{% if store.pinterest %}
				<li><a href="{{ store.pinterest }}" target="_blank" title="{{ 'lang.storefront.layout.social.pinterest'|t }}">{{ icons('pinterest') }}</a></li>
			{% endif %}

			{% if store.youtube %}
				<li><a href="{{ store.youtube }}" target="_blank" title="{{ 'lang.storefront.layout.social.youtube'|t }}">{{ icons('youtube') }}</a></li>
			{% endif %}

			{% if store.linkedin %}
				<li><a href="{{ store.linkedin }}" target="_blank" title="{{ 'lang.storefront.layout.social.linkedin'|t }}">{{ icons('linkedin-square') }}</a></li>
			{% endif %}

			{% if store.tiktok %}
				<li><a href="{{ store.tiktok }}" target="_blank" title="{{ 'lang.storefront.layout.social.tiktok'|t }}">{{ icons('tiktok') }}</a></li>
			{% endif %}

			<li class="link-social-rss"><a href="{{ site_url('rss') }}" target="_blank" title="{{ 'lang.storefront.layout.social.rss'|t }}">{{ icons('rss') }}</a></li>
		</ul>

		{{ generic_macros.gallery() }}

		{% if categories and store.theme_options.home_num_categories > 0 %}
			<section class="categories">
				<div class="row">
					{% for products_category in categories %}
						{% if loop.index0 < (store.theme_options.home_num_categories ? store.theme_options.home_num_categories : 4) %}
							<div class="col-xs-{{ 12 / mobile_categories_per_row }} {{ loop.first ? 'col-sm-offset-' ~ (12 - ((12 / store.theme_options.home_categories_per_row) * min(categories|length, store.theme_options.home_num_categories) )) / 2 }} {{ 'col-sm-' ~ (12 / store.theme_options.home_categories_per_row) }}">
								{{ generic_macros.category_list(products_category, false) }}
							</div>
							{% if loop.index0 % store.theme_options.home_categories_per_row == (store.theme_options.home_categories_per_row - 1) %}
								<div class="clearfix hidden-xs"></div>
							{% endif %}
							{% if mobile_categories_per_row == 2 and (loop.index % 2 == 0) %}
                        		<div class="clearfix visible-xs"></div>
                    		{% endif %}
						{% endif %}
					{% endfor %}
				</div>
			</section>
		{% endif %}

		{% set products_per_page_home = store.products_per_page_home %}
		{% set featured_products = products("order:featured limit:#{products_per_page_home}") %}
		{% if products_per_page_home %}
			<div class="products">
				<div class="row">

					{% for product in featured_products %}
						<div class="col-xs-{{ mobile_products_per_row }} col-sm-4 col-md-{{ 12 / products_per_row }}">
							{{ generic_macros.product_list(product) }}
						</div>
						{% if loop.index0 % products_per_row == (products_per_row - 1) %}
							<div class="clearfix hidden-xs hidden-sm"></div>
						{% endif %}
						{% if loop.index0 % 3 == 2 %}
							<div class="clearfix visible-sm"></div>
						{% endif %}
						{% if mobile_products_per_row == '6' and (loop.index % 2 == 0) %}
							<div class="clearfix visible-xs"></div>
						{% endif %}
					{% endfor %}

				</div>
			</div>
		{% endif %}

	</div>

	{% if store.featured_blocks %}
		<section class="featured-blocks">
			<div class="{{ layout_container }}">
				<div class="row">
					{% for featured_block in store.featured_blocks %}
						<div class="{{ loop.first ? 'col-sm-offset-' ~ (12 - 4 * store.featured_blocks|length) / 2 }} col-sm-4 col-featured-block">
							<div class="featured-block">
								<div style="-webkit-mask-image: url('{{ featured_block.icon }}');mask-image: url('{{ featured_block.icon }}');"></div>
								<h4 class="bold">{{ featured_block.title }}</h4>
								<p>{{ featured_block.description }}</p>
							</div>
						</div>
					{% endfor %}
				</div>
			</div>
		</section>
	{% endif %}

	<div class="{{ layout_container }}">

		{% set brands = brands("order:#{store.theme_options.home_brands_sorting} limit:6") %}
		{% if brands %}
			<section class="brands-block">
				<h3>{{ 'lang.storefront.home.block.brands.title'|t }}</h3>
				<div class="row">
					{% for brand in brands %}
						<div class="col-xs-2">
							<a href="{{ brand.url }}" class="img-frame"><img src="{{ brand.image.thumb }}" alt="{{ brand.image.alt ? brand.image.alt : brand.title }}" title="{{ brand.title }}"></a>
						</div>
					{% endfor %}
				</div>
				<p class="small margin-top"><a href="{{ site_url('brands') }}" class="text-underline">{{ 'lang.storefront.brands.title'|t }}</a></p>
			</section>
		{% endif %}

	</div>

{% endblock %}
