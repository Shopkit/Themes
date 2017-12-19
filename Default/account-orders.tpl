{#
Description: Orders account page
#}

{% import 'account.tpl' as account_macros %}

{% extends 'base.tpl' %}

{% block content %}

    <ul class="breadcrumb">
        <li><a href="/">Home</a><span class="divider">›</span></li>
        <li><a href="{{ site_url('account') }}">A minha conta</a><span class="divider">›</span></li>
        <li class="active">Encomendas</li>
    </ul>

    <h1>Olá <strong>{{ user.name|first_word }}</strong>.</h1>

    <br>

    {% if user.order_detail %}
        {# Template for order detail #}

        <div class="row-fluid">
            <div class="span12">
                <h3>Encomenda #{{ user.order_detail.id }}</h3>

                {% if user.order_detail.tracking_url %}<a href="{{ user.order_detail.tracking_url }}" target="_blank" class="btn btn-outline"><i class="fa fa-fw fa-map-marker" aria-hidden="true"></i> Seguir envio</a> &nbsp; {% endif %}
                {% if user.order_detail.invoice_url %}<a href="{{ user.order_detail.invoice_url }}" target="_blank" class="btn btn-outline"><i class="fa fa-fw fa-file-text" aria-hidden="true"></i> Ver factura</a>{% endif %}

                <div class="list-group list-group-horizontal margin-top margin-bottom-0 order-status order-status-{{ user.order_detail.status_alias }} {{ user.order_detail.paid ? 'order-paid' : 'order-not-paid' }}">
                    <div class="row-fluid">
                        <div class="span2 list-group-item">
                            <h4>Pago</h4>
                            <span class="order-status-payment">{{ user.order_detail.paid ? '<i class="fa fa-fw fa-check text-success" aria-hidden="true"></i>' : '<i class="fa fa-fw fa-times" aria-hidden="true"></i>' }}</span>
                        </div>
                        <div class="span4 list-group-item">
                            <h4>Estado</h4>
                            <span class="order-status-description">{{  user.order_detail.status_description }}</span>
                        </div>
                        <div class="span3 list-group-item">
                            <h4>Data</h4>
                            <span class="order-status-date">{{  user.order_detail.created_at|date("j F Y") }}</span>
                        </div>
                        <div class="span3 list-group-item">
                            <h4>Total</h4>
                            <span class="order-status-total">{{  user.order_detail.total|money_with_sign(user.order_detail.currency) }}</span>
                        </div>
                    </div>
                </div>
                <p class="margin-bottom margin-top-xxs"><a href='{{ site_url("contatos?p=") ~ "Encomenda ##{user.order_detail.id}"|url_encode }}' class="text-underline" target="_blank"><small>Contactar acerca desta encomenda</small></a></p>

                {% if user.order_detail.client_note %}
                    <div class="well">
                        <h4 class="margin-bottom-xxs">Nota de {{ store.name }}</h4>
                        {{ user.order_detail.client_note|nl2br }}
                    </div>
                {% endif %}

                {% if user.order_detail.observations %}
                    <div class="well">
                        <h4 class="margin-bottom-xxs">Observações</h4>
                        {{ user.order_detail.observations|nl2br }}
                    </div>
                {% endif %}

                <div class="row-fluid margin-bottom-sm">
                    <div class="span6">
                        <h4 class="margin-bottom-xxs">Pagamento</h4>
                        <p>{{ user.order_detail.payment.description }}</p>

                        {% if not user.order_detail.paid %}
                            <h5 class="margin-bottom-xxs">Dados para pagamento</h5>
                            <div class="row-fluid">
                                <div class="span9">
                                    <p>{{ user.order_detail.payment.data_html }}</p>
                                </div>
                            </div>
                        {% endif %}
                    </div>
                    <div class="span6">
                        {% if user.order_detail.shipment_method %}
                            <h4 class="margin-bottom-xxs">Transporte</h4>
                            <p>{{ user.order_detail.shipment_method }}</p>
                        {% endif %}
                    </div>
                </div>

                <div class="row-fluid margin-bottom-sm">
                    <div class="span6">
                        <h4 class="margin-top-0 margin-bottom-xxs">Dados de cliente</h4>
                        {{ user.order_detail.client.email }}<br>
                        NIF: {{ user.order_detail.client.fiscal_id ? user.order_detail.client.fiscal_id : 'n/a' }}<br>
                        Empresa: {{ user.order_detail.client.company ? user.order_detail.client.company : 'n/a' }}
                    </div>
                </div>

                <div class="row-fluid margin-bottom">
                    <div class="span6">
                        <h4 class="margin-bottom-xxs">Morada de envio</h4>
                        <p>
                            {{ user.order_detail.client.delivery.name }}<br>
                            {{ user.order_detail.client.delivery.address }} {{ user.order_detail.client.delivery.address_extra }}<br>
                            {{ user.order_detail.client.delivery.zip_code }} {{ user.order_detail.client.delivery.city }}<br>
                            {{ user.order_detail.client.delivery.country }}
                        </p>
                        <p>
                            {{ user.order_detail.client.delivery.phone ? 'Telefone: ' ~ user.order_detail.client.delivery.phone : '' }}
                        </p>
                    </div>
                    <div class="span6">
                        <h4 class="margin-bottom-xxs">Morada de facturação</h4>
                        <p>
                            {{ user.order_detail.client.billing.name }}<br>
                            {{ user.order_detail.client.billing.address }} {{ user.order_detail.client.billing.address_extra }}<br>
                            {{ user.order_detail.client.billing.zip_code }} {{ user.order_detail.client.billing.city }}<br>
                            {{ user.order_detail.client.billing.country }}
                        </p>
                        <p>
                            {{ user.order_detail.client.billing.phone ? 'Telefone: ' ~ user.order_detail.client.billing.phone ~ '<br>' : '' }}
                        </p>
                    </div>
                </div>

                {% if user.order_detail.products %}
                    <table class="table table-cart">
                        <tbody>
                            {% for product in user.order_detail.products %}
                                <tr>
                                    <td width="40">
                                        <a href="{{ product.url }}"><img src="{{ product.image.square }}" alt="{{ product.title }}" title="{{ product.title }}" class="border-radius" width="40"></a>
                                    </td>
                                    <td>
                                        <a href="{{ product.url }}">{{ product.title }}</a><br>
                                        <small class="text-muted">{{ product.option }}</small>
                                    </td>
                                    <td class="text-right nowrap">
                                        <span class="text-muted">{{ product.quantity }}x {{ product.price|money_with_sign(user.order_detail.currency) }}</span><br>
                                        {% set product_subtotal = product.price * product.quantity %}
                                        {{ product_subtotal|money_with_sign(user.order_detail.currency) }}
                                    </td>
                                </tr>
                            {% endfor %}
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="2">Envio / Transporte</td>
                                <td class="text-right">{{ user.order_detail.shipping.value|money_with_sign(user.order_detail.currency) }}</td>
                            </tr>

                            {% if user.order_detail.total_tax > 0 %}
                                <tr>
                                    <td colspan="2">Taxa (IVA)</td>
                                    <td class="text-right">{{ user.order_detail.total_tax|money_with_sign(user.order_detail.currency) }}</td>
                                </tr>
                            {% endif %}

                            {% if user.order_detail.coupon_code %}
                                <tr>
                                    <td colspan="2">Desconto <small class="text-muted">({{user.order_detail.coupon_code}})</small></td>
                                    <td class="text-right">- {{ user.order_detail.discount|money_with_sign(user.order_detail.currency) }}</td>
                                </tr>
                            {% endif %}

                            <tr>
                                <td colspan="2" class="subtotal"><strong>Total</strong></td>
                                <td class="subtotal text-right"><strong>{{ user.order_detail.total|money_with_sign(user.order_detail.currency) }}</strong></td>
                            </tr>
                        </tfoot>
                    </table>
                {% endif %}

                {% if user.order_detail.custom_field %}
                    <div class="well">
                        {% for custom_field in user.order_detail.custom_field|json_decode %}
                            <h4 class="margin-bottom-xxs">{{ custom_field.title }}</h4>
                            <p><strong>{{ custom_field.key }}</strong>: {{ custom_field.value }}</p>
                            {{ loop.last ? '' : '<hr>' }}
                        {% endfor %}
                    </div>
                {% endif %}

            </div>
        </div>

    {% else %}
        {# Template for order list #}
        <h3>Encomendas</h3>
        {{ account_macros.order_table_list(user.orders) }}
    {% endif %}

{% endblock %}