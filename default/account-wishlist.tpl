{#
Description: Wishlist account page
#}

{% import 'account.tpl' as account_macros %}
{% import 'macros.tpl' as generic_macros %}

{% extends 'base.tpl' %}

{% block content %}

    <ul class="breadcrumb well-default">
        <li><a href="{{ site_url() }}">{{ 'lang.storefront.layout.breadcrumb.home'|t }}</a><span class="divider">›</span></li>
        <li><a href="{{ site_url('account') }}">{{ 'lang.storefront.account.my_account'|t }}</a><span class="divider">›</span></li>
        <li class="active">{{ 'lang.storefront.layout.wishlist.title'|t }}</li>
    </ul>

    <h1>{{ 'lang.storefront.layout.greetings'|t }} <strong>{{ user.name|first_word }}</strong>.</h1>

    <br>

    <div class="row-fluid">
        <div class="span12">

            <h3 class="margin-top-0 text-gray light">{{ 'lang.storefront.layout.wishlist.title'|t }}</h3>

            {% if user.wishlist %}
                <table class="table table-wishlist well-featured {{ store.theme_options.well_featured_shadow }} table-hover margin-top-sm">
                    <tbody>
                        {% for product in user.wishlist %}
                            <tr>
                                <td width="50">
                                    <a href="{{ product.url }}"><img src="{{ assets_url('assets/store/img/no-img.png') }}" data-src="{{ product.image }}" alt="{{ product.title|e_attr }}" title="{{ product.title|e_attr }}" width="60" class="lazy"></a>
                                </td>
                                <td>
                                    <a href="{{ product.url }}"><strong>{{ product.title }}</strong></a><br>
                                    {% if (product.stock_qty and product.stock_show_info) %}
                                        <small>{{ 'lang.storefront.account.wishlist.stock_units'|t([product.stock_qty]) }}</small><br>
                                    {% endif %}
                                    <small class="text-muted">{{ 'lang.storefront.account.wishlist.add_date'|t([product.created_at|format_datetime('long','none')]) }}</small>
                                </td>
                                <td class="text-right nowrap">
                                    <a href="{{ product.remove_wishlist_url }}" class="text-muted small" title="{{ 'lang.storefront.layout.button.remove'|t }}">{{ icons('trash', 'fa-lg') }}</a> &nbsp;
                                    <a href="{{ product.add_cart_url }}" class="text-muted small" title="{{ 'lang.storefront.layout.button.add_to_cart'|t }}">{{ icons('cart-plus', 'fa-lg') }}</a>
                                </td>
                            </tr>
                        {% endfor %}
                    </tbody>
                </table>
            {% else %}
                <p>{{ 'lang.storefront.account.wishlist.no_products'|t }}</p>
            {% endif %}
        </div>
    </div>

{% endblock %}