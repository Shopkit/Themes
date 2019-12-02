{#
Description: Wishlist account page
#}

{% import 'account.tpl' as account_macros %}

{% extends 'base.tpl' %}

{% block content %}

    <ul class="breadcrumb">
        <li><a href="{{ site_url() }}">Home</a><span class="divider">›</span></li>
        <li><a href="{{ site_url('account') }}">A minha conta</a><span class="divider">›</span></li>
        <li class="active">Wishlist</li>
    </ul>

    <h1>Olá <strong>{{ user.name|first_word }}</strong>.</h1>

    <br>

    <div class="row-fluid">
        <div class="span12">

            <h3 class="margin-top-0 text-gray light">Wishlist</h3>

            {% if user.wishlist %}
                <table class="table table-wishlist table-hover margin-top-sm">
                    <tbody>
                        {% for product in user.wishlist %}
                            <tr>
                                <td width="50">
                                    <a href="{{ product.url }}"><img src="{{ product.image }}" alt="{{ product.title|e_attr }}" title="{{ product.title|e_attr }}" width="60"></a>
                                </td>
                                <td>
                                    <a href="{{ product.url }}"><strong>{{ product.title }}</strong></a><br>
                                    {% if (product.stock_qty and product.stock_show_info) %}
                                        <small>{{ product.stock_qty }} unidades em stock</small><br>
                                    {% endif %}
                                    <small class="text-muted">Adicionado em {{ product.created_at|date("d \\d\\e F \\d\\e Y") }}</small>
                                </td>
                                <td class="text-right nowrap">
                                    <a href="{{ product.remove_wishlist_url }}" class="text-muted small" title="Remover"><i class="fa fa-fw fa-trash fa-lg"></i></a> &nbsp;
                                    <a href="{{ product.add_cart_url }}" class="text-muted small" title="Adicionar ao carrinho"><i class="fa fa-fw fa-cart-plus fa-lg"></i></a>
                                </td>
                            </tr>
                        {% endfor %}
                    </tbody>
                </table>
            {% else %}
                <p>Não existem produtos na wishlist.</p>
            {% endif %}
        </div>
    </div>

{% endblock %}