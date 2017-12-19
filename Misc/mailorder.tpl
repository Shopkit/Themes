{# Settings and variables of the e-mail template #}
{% set show_logo = true %} {# Show logo #}
{% set logo_img_url = store.logo %} {# Logo image URL. Replace store.logo with an absolute URL if you want to use another logo #}

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>Encomenda #{{ order.id }}</title>
		<style type="text/css">
			/* Based on The MailChimp Reset INLINE: Yes. */
			/* Client-specific Styles */
			#outlook a {
				padding: 0;
			}
			/* Force Outlook to provide a "view in browser" menu link. */
			body {
				 width: 100% !important;
				 -webkit-text-size-adjust: 100%;
				 -ms-text-size-adjust: 100%;
				 margin: 0;
				 padding: 0;
				 font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
				 background-color: #f5f5f5;
				 color:#999;
			}
			/* Forces Hotmail to display normal line spacing.  More on that: http://www.emailonacid.com/forum/viewthread/43/ */
			#backgroundTable {
				 margin: 0;
				 padding: 0;
				 width: 100% !important;
				 line-height: 100% !important;
				 background-color: #f5f5f5;
			}
			/* End reset */
			/* Some sensible defaults for images
			Bring inline: Yes. */
			img {
				 outline: none;
				 text-decoration: none;
				 -ms-interpolation-mode: bicubic;
			}
			a img {
				border: none;
			}
			/* Yahoo paragraph fix
			Bring inline: Yes. */
			p {
				margin: 1em 0;
			}
			/* Outlook 07, 10 Padding issue fix
			Bring inline: No.*/
			table td {
				border-collapse: collapse;
			}
			/* Remove spacing around Outlook 07, 10 tables
			Bring inline: Yes */
			table {
				 border-collapse: collapse;
				 mso-table-lspace: 0pt;
				 mso-table-rspace: 0pt;
			}
			/* Styling your links has become much simpler with the new Yahoo.  In fact, it falls in line with the main credo of styling in email and make sure to bring your styles inline.  Your link colors will be uniform across clients when brought inline.
			Bring inline: Yes. */
			a {
				color: #999999;
			}

			a.link-white, .link-white a {
				color: #ffffff;
			}
			/* Mediaqueries */
			@media screen and (max-width: 768px) {
				.table-width-wrapper {
					width: 100%;
					/*min-width: 380px;*/
				}

				.table-width-inner {
					width: 95%;
				}

				.table-hz-margin {
					width: 2.5%;
				}
			}
			@media screen and (max-width: 480px) {
                .td-payment-img-sep, .td-payment-img  {
                    display: none !important;
                    visibility: hidden;
                }
                .order-total {
                    font-size: 20px !important;
                    text-align: left;
                }
                .btn-header {
                	padding: 10px !important;
                }

                .td-img-order-status, .img-order-status {
                	width: 30px !important;
                }
            }
		</style>

		{{ order_schema }}
	</head>
	<body>
		<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#f5f5f5" id="backgroundTable" style="background-color: #f5f5f5;font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif;font-size:14px; color:#999;">
			<tr>
				<td align="center" valign="top" bgcolor="#f5f5f5" style="background-color: #f5f5f5">
					<table width="620" border="0" cellpadding="0" cellspacing="0" align="center" class="table-width-wrapper">
						<tbody>
							<tr>
								<td width="20" class="table-hz-margin">&nbsp;</td>
								<td width="580" class="table-width-inner">
									<table width="580" border="0" align="center" cellpadding="0" cellspacing="0" class="table-width-inner">
										<tr>
											<td height="60" class="table-vt-margin">&nbsp;</td>
										</tr>
										<tr>
											<td align="center">
												{% if show_logo == true and logo_img_url %}
													<a href="/"><img src="{{ logo_img_url }}" height="60" alt="{{ store.name }}" title="{{ store.name }}" border="0" style="height:60px;"/></a>
												{% else %}
													<a href="/" style="font-size:40px; color: #666; text-decoration: none;">{{ store.name }}</a>
												{% endif %}
											</td>
										</tr>
										<tr>
											<td height="30">&nbsp;</td>
										</tr>
										{% if is_email %}
											<tr>
												<td align="center" style="color:#ccc;font-size:12px;"><a href="{{ order.permalink }}" target="_blank">Não consegue ver o e-mail?</a></td>
											</tr>
										{% endif %}
										<tr>
											<td height="30">&nbsp;</td>
										</tr>
										<tr>
											<td>
												<div style="border-radius: 3px;">

													{% if order.status_alias == 'canceled' %}
														{% set have_top_bar = true %}
														<div style="background-color:#d9534f;padding:15px 20px;border-top-left-radius: 3px;border-top-right-radius: 3px;">
															<table width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;">
																<tr>
																	<td width="40" class="td-img-order-status"><img src="https://drwfxyu78e9uq.cloudfront.net/assets/store/img/cancel.png" width="40" alt="canceled" border="0" class="img-order-status"/></td>
																	<td width="20">
																		<p>&nbsp;</p>
																	</td>
																	<td><span style="color:#fff; text-transform:uppercase;font-size:18px;line-height:130%;">Encomenda cancelada</span></td>
																</tr>
															</table>
														</div>

													{% elseif order.status_alias == 'sent' %}
														{% set have_top_bar = true %}
														<div style="background-color:#00d4ed;padding:15px 20px;border-top-left-radius: 3px;border-top-right-radius: 3px;">
															<table width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;">
																<tr>
																	<td width="40" class="td-img-order-status"><img src="https://drwfxyu78e9uq.cloudfront.net/assets/store/img/sent.png" width="40" alt="paid" border="0" class="img-order-status"/></td>
																	<td width="20">
																		<p>&nbsp;</p>
																	</td>
																	<td><span style="color:#fff; text-transform:uppercase;font-size:18px;line-height:130%;">Encomenda enviada</span></td>
																	<td align="right" class="link-white">
																		{% if order.tracking_url %}
																			<a href="{{ order.tracking_url }}" target="_blank" class="link-white btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff;text-align:center;">Seguir envio</a>
																		{% elseif order.invoice_permalink %}
																			<a href="{{ order.invoice_permalink }}" target="_blank" class="link-white btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff;text-align:center;">Ver factura</a>
																		{% endif %}
																	</td>
																</tr>
															</table>
														</div>

													{% elseif order.status_alias == 'delivered' %}
														{% set have_top_bar = true %}
														<div style="background-color:#8dc059;padding:15px 20px;border-top-left-radius: 3px;border-top-right-radius: 3px;">
															<table width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;">
																<tr>
																	<td width="40" class="td-img-order-status"><img src="https://drwfxyu78e9uq.cloudfront.net/assets/store/img/delivered.png" width="40" alt="delivered" border="0" class="img-order-status"/></td>
																	<td width="20">
																		<p>&nbsp;</p>
																	</td>
																	<td><span style="color:#fff; text-transform:uppercase;font-size:18px;line-height:130%;">Encomenda entregue</span></td>
																	<td align="right" class="link-white">
																		{% if order.invoice_permalink %}
																			<a href="{{ order.invoice_permalink }}" target="_blank" class="link-white btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff;text-align:center;">Ver factura</a>
																		{% endif %}
																	</td>
																</tr>
															</table>
														</div>

													{% elseif order.paid == true %}
														{% set have_top_bar = true %}
														<div style="background-color:#8dc059;padding:15px 20px;border-top-left-radius: 3px;border-top-right-radius: 3px;">
															<table width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;">
																<tr>
																	<td width="40" class="td-img-order-status"><img src="https://drwfxyu78e9uq.cloudfront.net/assets/store/img/check.png" width="40" alt="paid" border="0" class="img-order-status"/></td>
																	<td width="20">
																		<p>&nbsp;</p>
																	</td>
																	<td><span style="color:#fff; text-transform:uppercase;font-size:18px;line-height:130%;">Encomenda paga</span></td>
																	<td align="right" class="link-white">
																		{% if order.invoice_permalink %}
																			<a href="{{ order.invoice_permalink }}" target="_blank" class="link-white btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff;text-align:center;">Ver factura</a>
																		{% elseif order.tracking_url %}
																			<a href="{{ order.tracking_url }}" target="_blank" class="link-white btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff;text-align:center;">Seguir envio</a>
																		{% endif %}
																	</td>
																</tr>
															</table>
														</div>
													{% endif %}

													<div style="background-color:#ffffff;padding:30px 20px;border-bottom:1px solid #eee; {% if have_top_bar != true %} border-top-left-radius: 3px;border-top-right-radius: 3px;{% endif %}">
														<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="font-size:18px;color:#999;width:100% !important;">
															<tr>
																<td width="50%" align="left" valign="middle">#{{ order.id }}</td>
																<td width="50%" align="right" valign="middle"><span style="white-space:nowrap;">{{ order.created_at|date("j \\d\\e F \\d\\e Y") }}</span></td>
															</tr>
														</table>
													</div>

													{% if order.client_note %}
														<div style="background-color:#eeeeee;padding:15px 20px;">
															<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="width:100% !important;">
																<tr>
																	<td>
																		<span style="color:#999999;font-size:14px;">{{ order.client_note }}</span>
																	</td>
																</tr>
															</table>
														</div>
													{% endif %}

													<div style="background-color:#ffffff;border-bottom:1px solid #eee;">
														<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="width:100% !important;">
															<tr>
																<td width="50%" align="left" valign="top" style="border-right:1px solid #eee;padding:30px 20px;line-height:24px;font-size:14px;">

																	<p style="margin:0 0 15px 0;color:#999;">
																		<strong style="color:#666;">Estado</strong>
																		<br /><span class="order-status-description">{{ order.status_description }}</span>
																	</p>

																	<p style="margin:0 0 15px 0;color:#999;">
																		<strong style="color:#666;">Envio</strong>
																		<br />{{ order.shipment_method ?: 'n/a' }}
																	</p>

																	{% if order.tracking_code %}
																	<p style="margin:0 0 0 0;color:#999;">
																		<strong style="color:#666;">Tracking</strong>
																		<br /><a href="{{ order.tracking_url }}" target="_blank">{{ order.tracking_code }}</a>
																	</p>
																	{% endif %}
																</td>
																<td width="50%" align="right" valign="top" style="padding:30px 20px;">

																	{% if order.payment.type == 'on_delivery' %}
																		{% set payment_img = 'https://drwfxyu78e9uq.cloudfront.net/templates/assets/common/icons/payments/contra-reembolso.png' %}
																		{% set payment_data = '<p style="color:#999;line-height:18px;font-size:12px;">' ~ store.payments.on_delivery.message|nl2br ~ '</p>' %}

																	{% elseif order.payment.type == 'pick_up' %}
																		{% set payment_img = 'https://drwfxyu78e9uq.cloudfront.net/templates/assets/common/icons/payments/levantamento.png' %}
																		{% set payment_data = '<p style="color:#999;line-height:18px;font-size:12px;">' ~ store.payments.pick_up.message|nl2br ~ '</p>' %}

																	{% elseif order.payment.type == 'multibanco' %}
																		{% set payment_img = 'https://drwfxyu78e9uq.cloudfront.net/templates/assets/common/icons/payments/multibanco.png' %}
																		{% set multibanco_reference = order.payment.data.reference|split('', 3) %}
																		{% set payment_data = '<p style="margin:0 0 5px 0;color:#999;line-height:24px;font-size:14px;"><strong style="color:#666;">Entidade:</strong> ' ~ order.payment.data.entity ~ '</p><p style="margin:0 0 5px 0;color:#999;line-height:24px;font-size:14px;"><strong style="color:#666;">Referência:</strong> <span style="padding: 0px 2px">' ~ multibanco_reference[0] ~ '</span><span style="padding: 0px 2px">' ~ multibanco_reference[1] ~ '</span><span style="padding: 0px 2px">' ~ multibanco_reference[2] ~ '</span></p><p style="margin:0 0 0 0;color:#999;line-height:24px;font-size:14px;"><strong style="color:#666;">Valor:</strong> ' ~ order.payment.data.value|money_with_sign(order.currency) ~ '</p>' %}

																	{% elseif order.payment.type == 'paypal' %}
																		{% set payment_img = 'https://drwfxyu78e9uq.cloudfront.net/templates/assets/common/icons/payments/paypal.png' %}
																		{% set payment_data = '<p style="margin:5px 0 5px 0"><a href="' ~ order.payment.data ~ '" target="_blank" style="display: inline-block; padding:10px 20px; line-height:100%; color:#fff; border-radius:3px; text-decoration:none; font-size:14px; background-color: #009cde;" class="link-white">Pagar via Paypal</a></p>' %}

																	{% elseif order.payment.type == 'bank_transfer' %}
																		{% set payment_img = 'https://drwfxyu78e9uq.cloudfront.net/templates/assets/common/icons/payments/transferencia-bancaria.png' %}
																		{% set payment_data = '<p style="color:#999;line-height:18px;font-size:12px;">' ~ store.payments.bank_transfer.message|nl2br ~ '</p>' %}
																	{% endif %}

																	<table width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;">
																		<tr>
																			<td width="70" align="left" valign="top" class="td-payment-img">
																				{% if payment_img %}
																					<img class="payment-img" src="{{ payment_img }}" width="70" style="opacity:0.5;display:block" alt="{{ payment_method }}" border="0" />
																				{% endif %}
																			</td>
																			<td width="20" align="left" valign="top" class="td-payment-img-sep">&nbsp;</td>
																			<td align="right" valign="middle" style="line-height:100%; font-size:24px; font-weight:bold; color:#000;">
																				<p class="order-total" style="margin:0 0 0 0; font-size:24px; white-space:nowrap;">{{ order.total|money_with_sign(order.currency) }}</p>
																			</td>
																		</tr>
																		<tr>
																			<td height="20" colspan="2">&nbsp;</td>
																		</tr>
																		<tr>
																			<td colspan="3">

																				{% if order.status_alias == 'delivered' %}
																					<p style="color:#999;line-height:20px;font-size:13px;"><strong>Encomenda entregue</strong> em {{ order.sent_at|date("j \\d\\e F \\d\\e Y \\à\\s H:i:s") }}</p>
																				{% elseif order.status_alias == 'sent' %}
																					<p style="color:#999;line-height:20px;font-size:13px;"><strong>Encomenda enviada</strong> em {{ order.sent_at|date("j \\d\\e F \\d\\e Y \\à\\s H:i:s") }}</p>
																				{% elseif order.status_alias == 'canceled' %}
																					<p style="color:#999;line-height:20px;font-size:13px;"><strong>Encomenda cancelada</strong> em {{ order.update_at|date("j \\d\\e F \\d\\e Y \\à\\s H:i:s") }}</p>
																				{% elseif order.paid == false %}
																					{{ payment_data }}
																				{% elseif order.paid == true %}
																					<p style="color:#999;line-height:20px;font-size:13px;"><strong>Encomenda paga</strong> em {{ order.paid_at|date("j \\d\\e F \\d\\e Y \\à\\s H:i:s") }}</p>
																				{% endif %}
																			</td>
																		</tr>
																	</table>
																</td>
															</tr>
														</table>
													</div>
													<div style="background-color:#ffffff;border-bottom:1px solid #eee;line-height: 140%; padding:30px 20px;">

														{% if order.products %}
															<table width="100%" border="0" cellpadding="0" cellspacing="0" style="border-bottom:2px solid #eee;width:100% !important;">

																{% for product in order.products %}
																	<tr>
																		<td width="50"><img src="{{ product.image.square }}" alt="{{ product.title }}" width="50" height="50" style="display:block;border-radius:5px;" border="0" /></td>
																		<td width="20">&nbsp;</td>
																		<td valign="middle" style="font-size: 14px;line-height:24px;">
																			<strong style="color:#666;">{{ product.title }}</strong>
																			<br />{{ product.option }}&nbsp;
																		</td>
																		<td align="right" valign="middle" style="font-size: 14px;line-height:24px;">
																			<span style="color:#ccc; white-space:nowrap;">{{ product.quantity }}x {{ product.price|money_with_sign(order.currency) }}</span><br />

																			{% set product_subtotal = product.price * product.quantity %}
																			<span style="color:#666; white-space:nowrap;">{{ product_subtotal|money_with_sign(order.currency) }}</span>
																		</td>
																	</tr>
																	<tr>
																		<td height="30" colspan="4">&nbsp;

																		</td>
																	</tr>
																{% endfor %}

															</table>
														{% endif %}

														<table width="100%" border="0" cellpadding="0" cellspacing="0" style="line-height:100%;width:100% !important;">
															<tr>
																<td height="20" colspan="2" align="left">&nbsp;</td>
															</tr>
															<tr>
																<td height="30" align="left" valign="middle" style="font-size: 14px;line-height:24px;color:#999999">Subtotal</td>
																<td height="30" align="right" valign="middle" style="font-size: 14px;line-height:24px;color:#999999"><span style="white-space:nowrap;">{{ order.subtotal|money_with_sign(order.currency) }}</span></td>
															</tr>
															<tr>
																<td width="50%" height="30" align="left" valign="middle" style="font-size: 14px;line-height:24px;color:#999999">Envio / Transporte</td>
																<td width="50%" height="30" align="right" valign="middle" style="font-size: 14px;line-height:24px;color:#999999"><span style="white-space:nowrap;">{{ order.shipping.value|money_with_sign(order.currency) }}</span></td>
															</tr>

															{% if order.coupon %}
																<tr>
																	<td height="30" align="left" valign="middle" style="font-size: 14px;line-height:24px;color:#999999">Desconto</td>
																	<td height="30" align="right" valign="middle" style="font-size: 14px;line-height:24px;color:#999999"><span style="white-space:nowrap;">- {{ order.discount|money_with_sign(order.currency) }}</span></td>
																</tr>
															{% endif %}

															{% if order.total_tax > 0 %}
																<tr>
																	<td height="30" align="left" valign="middle" style="font-size: 14px;line-height:24px;color:#999999">Taxa (IVA)</td>
																	<td height="30" align="right" valign="middle" style="font-size: 14px;line-height:24px;color:#999999"><span style="white-space:nowrap;">{{ order.total_tax|money_with_sign(order.currency) }}</span></td>
																</tr>
															{% endif %}

															<tr>
																<td height="30" align="left" valign="middle" style="font-size: 14px;line-height:24px;color:#333333"><strong style="color:#333;">Total</strong></td>
																<td height="30" align="right" valign="middle" style="font-size: 14px;line-height:24px;color:#333333"><strong style="color:#333;white-space:nowrap;">{{ order.total|money_with_sign(order.currency) }}</strong></td>
															</tr>
														</table>
													</div>
													<div style="background-color:#ffffff;border-bottom:1px solid #eee;line-height: 160%;">
														<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="width:100% !important;">
															<tr>
																<td width="50%" align="left" valign="top" style="padding:30px 20px;">
																	<p style="margin: 0 0 10px 0; line-height:24px;">
																		<strong style="color:#666; display:block; font-size:24px;">{{ order.client.name }}</strong>
																	</p>
																	<p style="margin: 0 0 0 0;font-size:14px;line-height:24px;">
																		<a href="mailto:{{ order.client.email }}" style="text-decoration:underline;color:#333">{{ order.client.email }}</a>
																	</p>
																</td>
																<td width="50%" align="left" valign="top" style="padding:30px 20px;">
																	<p style="margin: 0 0 0 0;font-size:14px;line-height:24px;color:#999999;">
																		<strong style="color: #666">Empresa:</strong> {{ order.client.company ?: 'n/a' }}<br>
																		<strong style="color: #666">NIF:</strong> {{ order.client.fiscal_id ?: 'n/a' }}
																	</p>
																</td>
															</tr>
															<tr>
																<td colspan="2" height="1" style="border-bottom:1px solid #eee"></td>
															</tr>
															<tr>
																<td width="50%" align="left" valign="top" style="padding:30px 20px;font-size:14px;line-height:24px;color:#999999;border-right:1px solid #eee;">
																	<p style="margin:0 0 0 0;color:#666"><strong>Morada de envio</strong></p>
																	<p style="margin:0 0 0 0">{{ order.client.delivery.name }}</p>
																	<p style="margin:0 0 0 0">{{ order.client.delivery.address }} {{ order.client.delivery.address_extra }}</p>
																	<p style="margin:0 0 0 0">{{ order.client.delivery.zip_code }} {{ order.client.delivery.city }}</p>
																	<p style="margin:0 0 0 0">{{ order.client.delivery.country }}</p>
																	<p style="margin:0 0 0 0">Telefone: {{ order.client.delivery.phone ?: 'n/a' }}</p>
																	{% if order.tracking_url %}
																		<p><a href="{{ order.tracking_url }}" target="_blank" class="link-white" style="display: inline-block; padding:10px 15px; line-height:100%; color:#666; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #eee;text-align:center; background-color: #eee">Seguir envio</a></p>
																	{% endif %}
																</td>
																<td width="50%" align="left" valign="top" style="padding:30px 20px;font-size:14px;line-height:24px;color:#999999;">
																	<p style="margin:0 0 0 0;color:#666"><strong>Morada de facturação</strong></p>
																	<p style="margin:0 0 0 0">{{ order.client.billing.name }}</p>
																	<p style="margin:0 0 0 0">{{ order.client.billing.address }} {{ order.client.billing.address_extra }}</p>
																	<p style="margin:0 0 0 0">{{ order.client.billing.zip_code }} {{ order.client.billing.city }}</p>
																	<p style="margin:0 0 0 0">{{ order.client.billing.country }}</p>
																	<p style="margin:0 0 0 0">Telefone: {{ order.client.billing.phone ?: 'n/a' }}</p>
																	{% if order.invoice_permalink %}
																		<p><a href="{{ order.invoice_permalink }}" target="_blank" class="link-white" style="display: inline-block; padding:10px 15px; line-height:100%; color:#666; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #eee;text-align:center; background-color: #eee">Ver factura</a></p>
																	{% endif %}
																</td>
															</tr>
														</table>
													</div>

													{% if order.custom_field %}
														<div style="padding:30px 20px;background-color:#fff;border-bottom-left-radius: 3px;border-bottom-right-radius: 3px;font-size:14px;line-height:24px;color:#999999;{% if order.observations %}border-bottom:1px solid #eee;border-bottom-left-radius: 0px;border-bottom-right-radius: 0px{% endif %}">
															{% for custom_field in order.custom_field|json_decode %}
																<p style="margin: 0 0 5px 0;"><strong>{{ custom_field.title }}</strong></p>
																<p style="margin: {{ loop.last ? '0 0 0 0' : '0 0 15px 0' }};"><strong>{{ custom_field.key }}</strong>: {{ custom_field.value }}</p>
															{% endfor %}
														</div>
													{% endif %}

													{% if order.observations %}
														<div style="padding:30px 20px;background-color:#fff;border-bottom-left-radius: 3px;border-bottom-right-radius: 3px;font-size:14px;line-height:24px;color:#999999">
															<p style="margin: 0 0 10px 0;"><strong>Observações:</strong></p>
															<p style="margin: 0 0 0 0;">{{ order.observations }}</p>
														</div>
													{% endif %}
												</div>
											</td>
										</tr>
										<tr>
											<td height="60">&nbsp;</td>
										</tr>
										<tr>
											<td align="center" style="font-size:14px;line-height:24px;color:#999999">
												<strong>{{ store.name }}</strong><br />

												{% if store.show_email %}
													<a href="mailto:{{ store.email }}" style="color: #999">{{ store.email }}</a><br />
												{% endif %}

												{{ store.address|nl2br }}
											</td>
										</tr>
										<tr>
											<td height="30">&nbsp;</td>
										</tr>
										<tr>
											<td align="center" style="color:#ccc;font-size:12px;">Encomenda efetuada em {{ order.created_at|date("j \\d\\e F \\d\\e Y \\à\\s H:i:s") }}</td>
										</tr>

										{% if store.show_branding %}
											<tr>
												<td height="30">&nbsp;</td>
											</tr>
											<tr>
												<td align="center">
													<div style="display:inline-block; border-top: 1px solid #ddd; padding-left:30px; padding-right:30px; padding-top:30px;">
														<a href="https://shopk.it/?utm_source={{ store.username }}&amp;utm_medium=email&amp;utm_campaign=Shopkit-Email-Order" target="_blank"><img class="logo-footer" src="https://drwfxyu78e9uq.cloudfront.net/assets/frontend/img/logo-shopkit-black-transparent.png" title="Powered by Shopkit" height="25" style="border:0;" border="0" alt="Powered by Shopkit" /></a>
													</div>
												</td>
											</tr>
										{% endif %}
										<tr>
											<td height="60" class="table-vt-margin">&nbsp;</td>
										</tr>
									</table>
								</td>
								<td width="20" class="table-hz-margin">&nbsp;</td>
							</tr>
						</tbody>
					</table>

				</td>
			</tr>
		</table>
	</body>
</html>