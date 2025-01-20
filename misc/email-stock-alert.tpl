{# Settings and variables of the e-mail template #}
{% set show_logo = true %} {# Show logo #}
{% set logo_img_url = store.logo %} {# Logo image URL. Replace store.logo with an absolute URL if you want to use another logo #}

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

        @media screen and (max-width:480px) {
            .order-total {
                font-size: 20px !important;
                text-align: left
            }

            .btn-header {
                padding: 10px !important
            }

            .td-img-order-status,
            .img-order-status {
                width: 30px !important
            }

            table[class="column_table"],
            table.column_table {
                width: 100% !important;
                border-left: none !important
            }

            td[class="fix-padding-bottom"],
            td.fix-padding-bottom {
                padding-bottom: 15px !important
            }

            td[class="column-order-status"],
            td.column-order-status {
                padding-bottom: 0px !important
            }

            td[class="fix-padding-top"],
            td.fix-padding-top {
                padding-top: 15px !important
            }

            td[class="column-order-payment-detail"],
            td.column-order-payment-detail {
                padding-top: 0px !important
            }

            p[class="visible-mobile"],
            p.visible-mobile {
                display: block !important
            }

            p[class="order-id"],
            p.order-id,
            p[class="order-date"],
            p.order-date {
                font-size: 14px !important
            }

            p[class="order-date"],
            p.order-date {
                text-align: left !important
            }

            td[class="td-product-image"],
            td.td-product-image {
                width: 40px !important;
                padding-top: 33px !important
            }

            td[class="td-product-image"] img,
            td.td-product-image img {
                width: 40px !important;
                height: 40px !important
            }

            td[class="product-vt-margin"],
            td.product-vt-margin {
                width: 10px !important
            }

            td[class="td-product-title"],
            td.td-product-title,
            td[class="td-product-price"],
            td.td-product-price {
                line-height: 18px !important
            }

            td[class="fix-line-height-mobile"],
            td.fix-line-height-mobile {
                line-height: 24px !important
            }

            [class="remove-border-bottom-mobile"],
            .remove-border-bottom-mobile {
                border-bottom: 0 !important
            }

            td[class="padding-bottom-mobile-0"],
            td.padding-bottom-mobile-0 {
                padding-bottom: 0 !important
            }

            td[class="padding-top-mobile-0"],
            td.padding-top-mobile-0 {
                padding-top: 0 !important
            }

            td[class="padding-top-mobile-15"],
            td.padding-top-mobile-15 {
                padding-top: 15px !important
            }
        }

        @media screen and (min-width:481px) and (max-width:768px) {

            table[class="column_table"],
            table.column_table {
                width: 50% !important
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
                                                                            <td width="100%" align="left" valign="top" style="line-height:18px;font-size:14px;">
                                                                                <div style="margin:20px;">
                                                                                    {% set product_title_with_option = '{product_title_with_option}' %}
                                                                                    <p style="color:#666;font-size:14px;">{{ 'lang.email.stock_alert.text'|t([product_title_with_option]) }}</p>
                                                                                </div>
                                                                            </td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                            <div style="background-color:#ffffff;line-height: 140%;">
                                                                <table bgcolor="#ffffff" width="100%" border="0" cellpadding="0" cellspacing="0" style="border-bottom:1px solid #eee;width:100% !important;">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td class="td-product-image" valign="top" width="50" style="padding-top:30px;padding-left:20px;padding-bottom:30px;"><img src="{product_image}" alt="{product_title}" width="50" height="50" style="display:block;border-radius:5px;" border="0"></td>
                                                                            <td class="product-vt-margin" width="20" style="padding-top:30px;padding-bottom:30px;">&nbsp;</td>
                                                                            <td class="td-product-title" valign="top" style="font-size: 14px;line-height:24px;padding-top:30px;padding-bottom:30px;"> <strong style="color:#666;">{product_title}</strong> {product_option}</td>
                                                                            <td class="product-vt-margin" width="20" style="padding-top:30px;padding-bottom:30px;">&nbsp;</td>
                                                                            <td class="td-product-price" align="right" valign="top" style="font-size: 14px;line-height:24px;padding-top:30px;padding-right:20px;padding-bottom:30px;"> <span style="color:#666; white-space:nowrap;">{product_price}</span></td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>
                                                            </div>
                                                            <div style="background-color:#ffffff;border-bottom:1px solid #eee;line-height: 160%;">
                                                                <table bgcolor="#ffffff" width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="width:100% !important;">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td width="100%" align="left" valign="top">
                                                                                <div style="margin:30px 20px;">
                                                                                    <p style="text-align:center">
                                                                                        <a href="{product_url}" target="_blank" class="link-white" style="display: inline-block; padding:15px 30px; line-height:100%; color:{{ get_contrast_color(store.basecolor) }}; border-radius:3px; text-decoration:none; font-size:16px; border:0;text-align:center; background-color: {{ store.basecolor }}; font-weight: bold;">{{ 'lang.email.stock_alert.button'|t }}</a>
                                                                                    </p>
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
                                                                <a href="https://shopk.it/?utm_source={{ store.username }}&amp;utm_medium=email&amp;utm_campaign=Shopkit-Email-Stock-Alert" title="Powered by Shopkit e-commerce" target="_blank" rel="nofollow"><img class="logo-footer" src="{{ assets_url('assets/frontend/img/logo-shopkit-black-transparent.png') }}" title="Powered by Shopkit e-commerce" height="25" style="border:0;" border="0" alt="Powered by Shopkit e-commerce" /></a>
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
