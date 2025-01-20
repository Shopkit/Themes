{#
Description: Wishlist account page
#}

{% import 'account.tpl' as account_macros %}
{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    <div class="account-wishlist section">
        <div class="{{ layout_container }}">
            <h2 class="account-wishlist-title title title_mb-lg">{{ 'lang.storefront.account.my_account'|t }}</h2>

            <div class="row">
                <div class="col-lg-3">
                    {{ account_macros.account_navigation() }}
                </div>

                <div class="col-lg-9">
                    <h1 class="margin-top-0 margin-bottom">{{ 'lang.storefront.layout.greetings'|t }} <strong>{{ user.name|first_word }}</strong>.</h1>

                    <h3 class="margin-top-0 margin-bottom text-gray light">{{ 'lang.storefront.layout.wishlist.title'|t }}</h3>

                    {% if user.wishlist %}
                        <div class="wishlist">
                            <div class="wishlist-row">
                                <div class="wishlist-col">
                                    <div class="wishlist-list">
                                        {% for product in user.wishlist %}
                                            <div class="wishlist-item well-featured {{ store.theme_options.well_featured_shadow }}">
                                                <a class="item-preview" href="{{ product.url }}">
                                                    <img class="item-pic lazy" src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image }}" alt="{{ product.title|e }}" title="{{ product.title|e }}">
                                                </a>
                                                <div class="item-details">
                                                    <a class="item-product" href="{{ product.url }}">{{ product.title }}</a>

                                                    <div class="item-info margin-bottom-xs">
                                                        {% if (product.stock_qty and product.stock_show_info) %}
                                                            <span>{{ 'lang.storefront.account.wishlist.stock_units'|t([product.stock_qty]) }}</span><br>
                                                        {% endif %}

                                                        <span class="text-muted">{{ 'lang.storefront.account.wishlist.add_date'|t([product.created_at|format_datetime('long','none')]) }}</span>
                                                    </div>
                                                    <div class="item-control">
                                                        <a href="{{ product.remove_wishlist_url }}" class="small item-add" title="{{ 'lang.storefront.layout.button.remove'|t }}"><i data-feather="trash-2"></i></a> &nbsp;
                                                        <a href="{{ product.add_cart_url }}" class="small item-remove" title="{{ 'lang.storefront.layout.button.add_to_cart'|t }}"><i data-feather="shopping-bag"></i></a>

                                                    </div>
                                                </div>
                                            </div>
                                        {% endfor %}
                                    </div>
                                </div>
                            </div>
                        </div>
                    {% else %}
                        <p>{{ 'lang.storefront.account.wishlist.no_products'|t }}</p>
                    {% endif %}
                </div>
            </div>
        </div>
    </div>

{% endblock %}