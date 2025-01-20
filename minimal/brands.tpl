{#
Description: Brands list page
#}

{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

	{% set brands = brands("order:#{store.brands_sorting} limit:#{brands_per_page}") %}

	<div class="{{ layout_container }}">

		<div class="row">
			<div class="col-lg-3">
				<h1 class="margin-top-0 margin-bottom">{{ 'lang.storefront.brands.title'|t }}</h1>
			</div>

			<div class="col-lg-9">
				<div class="brands margin-top-0">
					<div class="row">

						{% set card_hover_effect = store.theme_options.card_hover_effect != 'none' ? store.theme_options.card_hover_effect : '' %}
						{% set card_thumbnail_type = store.theme_options.catalog_thumbail_type == 'square' ? 'square' : 'thumb' %}
						{% for brand in brands %}
							<div class="col-xs-{{ 12 / mobile_brands_per_row }} col-sm-4 col-md-{{ 12 / brands_per_row }}">
								<article class="brand brand-id-{{ brand.id }} {{ card_hover_effect }}">

									<div class="{{ store.theme_options.card_shadow }}">
										<a href="{{ brand.url }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ brand.image[card_thumbnail_type] }}" class="img-responsive lazy" alt="{{ brand.title }}" title="{{ brand.title }}" width="400" height="400"></a>

										<div class="brand-info">
											<a class="brand-details" href="{{ brand.url }}">
												<div>
													<h2>{{ brand.title }}</h2>
												</div>
											</a>
										</div>
									</div>

								</article>
							</div>

							{% if loop.index0 % brands_per_row == (brands_per_row - 1) %}
								<div class="clearfix hidden-xs"></div>
							{% endif %}
							{% if mobile_brands_per_row == 2 and (loop.index % 2 == 0) %}
                        		<div class="clearfix visible-xs"></div>
                    		{% endif %}
						{% else %}
							<div class="col-xs-12">
								<h3 class="margin-bottom-lg margin-top-0 text-muted-dark light">{{ 'lang.storefront.brands.no_brands'|t }}</h3>
							</div>
						{% endfor %}

					</div>
				</div>

				<nav class="text-center">
					{{ pagination("brands limit:#{brands_per_page}") }}
				</nav>

			</div>
		</div>

	</div>

{% endblock %}
