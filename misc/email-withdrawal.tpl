{# Settings and variables of the e-mail template #}
{% set show_logo = true %} {# Show logo #}
{% set logo_img_url = store.logo %} {# Logo image URL. Replace store.logo with an absolute URL if you want to use another logo #}

{# Direito de livre resolução — acusação de receção (comprador) / notificação (comerciante).
   email_data: name, email, order_number, scope, products, notes, datetime, is_buyer #}
{% set scope_label = email_data.scope == 'some' ? 'lang.storefront.withdrawal.scope.some'|t : 'lang.storefront.withdrawal.scope.all'|t %}

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>{{ email_subject }}</title>
        <style type="text/css">
        #outlook a {
            padding: 0
        }

        body {
            width: 100% !important;
            -webkit-text-size-adjust: 100%;
            -ms-text-size-adjust: 100%;
            margin: 0;
            padding: 0;
            font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
            background-color: #f5f5f5;
            color: #999
        }

        #backgroundTable {
            margin: 0;
            padding: 0;
            width: 100% !important;
            line-height: 100% !important;
            background-color: #f5f5f5
        }

        img {
            outline: none;
            text-decoration: none;
            -ms-interpolation-mode: bicubic;
            max-width: 100% !important
        }

        a img {
            border: none
        }

        p {
            margin: 1em 0
        }

        table td {
            border-collapse: collapse
        }

        table {
            border-collapse: collapse;
            mso-table-lspace: 0pt;
            mso-table-rspace: 0pt
        }

        a {
            color: #999
        }

        a.link-white,
        .link-white a {
            color: #fff
        }

        @media screen and (max-width:768px) {
            .table-width-wrapper {
                width: 100%
            }

            .table-width-inner {
                width: 95%
            }

            .table-hz-margin {
                width: 2.5%
            }
        }
        </style>
    </head>
    <body class="">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#f5f5f5" id="backgroundTable" style="background-color: #f5f5f5;font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;font-size:14px; color:#999;">
            <tbody>
                <tr>
                    <td align="center" valign="top" bgcolor="#f5f5f5" style="background-color: #f5f5f5">
                        <table width="620" border="0" cellpadding="0" cellspacing="0" align="center" class="table-width-wrapper">
                            <tbody>
                                <tr>
                                    <td width="20" class="table-hz-margin">&nbsp;</td>
                                    <td width="580" class="table-width-inner">
                                        <table width="580" border="0" align="center" cellpadding="0" cellspacing="0" class="table-width-inner">
                                            <tbody>
                                                <tr>
                                                    <td height="30" class="table-vt-margin">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td align="center">
                                                        {% if show_logo == true and logo_img_url %}
                                                            <a href="{{ store.url }}"><img src="{{ logo_img_url }}" height="60" alt="{{ store.name }}" title="{{ store.name }}" border="0" style="height:60px;"/></a>
                                                        {% else %}
                                                            <a href="{{ store.url }}" style="font-size:40px; color: #666; text-decoration: none; line-height: 40px;">{{ store.name }}</a>
                                                        {% endif %}
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="30">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td bgcolor="#ffffff">
                                                        <div style="border-radius: 3px;">
                                                            <div style="background-color:#ffffff;border-bottom:1px solid #eee;">
                                                                <table bgcolor="#ffffff" width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="width:100% !important;">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td width="100%" align="left" valign="top" style="line-height:18px;font-size:14px;color:#666;">
                                                                                <div style="margin:30px;">
                                                                                    <h1 style="margin-top: 0; margin-bottom: 30px; padding: 0; color: #000; font-weight: bold; font-size: 24px; line-height: 30px;">{{ email_subject }}</h1>

                                                                                    <p style="margin-top:0;">{{ email_data.is_buyer ? 'lang.email.withdrawal.body.intro_buyer'|t : 'lang.email.withdrawal.body.intro_merchant'|t }}</p>

                                                                                    <table width="100%" border="0" cellpadding="0" cellspacing="0" style="font-size:14px;line-height:20px;color:#666;">
                                                                                        <tbody>
                                                                                            <tr>
                                                                                                <td style="padding:4px 0;"><strong>{{ 'lang.email.withdrawal.body.label_name'|t }}:</strong> {{ email_data.name|e }}</td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td style="padding:4px 0;"><strong>{{ 'lang.email.withdrawal.body.label_email'|t }}:</strong> {{ email_data.email|e }}</td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td style="padding:4px 0;"><strong>{{ 'lang.email.withdrawal.body.label_order'|t }}:</strong> {{ email_data.order_number|e }}</td>
                                                                                            </tr>
                                                                                            <tr>
                                                                                                <td style="padding:4px 0;"><strong>{{ 'lang.email.withdrawal.body.label_scope'|t }}:</strong> {{ scope_label }}</td>
                                                                                            </tr>
                                                                                            {% if email_data.products %}
                                                                                                <tr>
                                                                                                    <td style="padding:4px 0;"><strong>{{ 'lang.email.withdrawal.body.label_products'|t }}:</strong> {{ email_data.products|e|nl2br }}</td>
                                                                                                </tr>
                                                                                            {% endif %}
                                                                                            {% if email_data.notes %}
                                                                                                <tr>
                                                                                                    <td style="padding:4px 0;"><strong>{{ 'lang.email.withdrawal.body.label_notes'|t }}:</strong> {{ email_data.notes|e|nl2br }}</td>
                                                                                                </tr>
                                                                                            {% endif %}
                                                                                            <tr>
                                                                                                <td style="padding:4px 0;"><strong>{{ 'lang.email.withdrawal.body.label_datetime'|t }}:</strong> {{ email_data.datetime }}</td>
                                                                                            </tr>
                                                                                        </tbody>
                                                                                    </table>

                                                                                    {% if email_data.is_buyer %}
                                                                                        <p style="margin-bottom:0;color:#999;font-size:13px;">{{ 'lang.email.withdrawal.body.disclaimer'|t }}</p>
                                                                                    {% else %}
                                                                                        <p style="margin-bottom:0;">{{ 'lang.email.withdrawal.body.merchant_cta'|t }}</p>
                                                                                    {% endif %}
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="30">&nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td align="center" style="font-size:14px;line-height:24px;color:#666666">
                                                        <strong>{{ store.name }}</strong><br />

                                                        {% if store.show_email %}
                                                            <a href="mailto:{{ store.email }}" style="color: #999">{{ store.email }}</a><br />
                                                        {% endif %}

                                                        {{ store.address|nl2br }}
                                                    </td>
                                                </tr>

                                                {% if store.show_branding %}
                                                    <tr>
                                                        <td height="30">&nbsp;</td>
                                                    </tr>
                                                    <tr>
                                                        <td align="center">
                                                            <div style="display:inline-block; border-top: 1px solid #ddd; padding-left:30px; padding-right:30px; padding-top:30px;">
                                                                <a href="https://shopk.it/?utm_source={{ store.username }}&amp;utm_medium=email&amp;utm_campaign=Shopkit-Email-Withdrawal" title="Powered by Shopkit e-commerce" target="_blank" rel="nofollow"><img class="logo-footer" src="{{ assets_url('assets/frontend/img/logo-shopkit-black-transparent.png') }}" title="Powered by Shopkit e-commerce" height="25" style="border:0;" border="0" alt="Powered by Shopkit e-commerce" /></a>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                {% endif %}
                                                <tr>
                                                    <td height="60" class="table-vt-margin">&nbsp;</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </td>
                                    <td width="20" class="table-hz-margin">&nbsp;</td>
                                </tr>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </tbody>
        </table>
    </body>
</html>
