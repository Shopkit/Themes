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
				 max-width: 100% !important;
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
			@media screen and (max-width:768px) {
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
			@media screen and (max-width:480px) {
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

            	table[class="column_table"], table.column_table {
					width: 100% !important;
					border-left: none !important;
				}

				td[class="fix-padding-bottom"], td.fix-padding-bottom {
					padding-bottom: 15px !important;
				}

				td[class="column-order-status"], td.column-order-status {
					padding-bottom: 0px !important;
				}

				td[class="fix-padding-top"], td.fix-padding-top {
					padding-top: 15px !important;
				}

				td[class="column-order-payment-detail"], td.column-order-payment-detail {
					padding-top: 0px !important;
				}

				p[class="visible-mobile"], p.visible-mobile {
					display: block !important;
				}

				p[class="order-id"], p.order-id, p[class="order-date"], p.order-date {
					font-size: 14px !important;
				}

				p[class="order-date"], p.order-date {
					text-align: left !important;
				}

				td[class="td-product-image"], td.td-product-image {
					width: 40px !important;
					padding-top: 33px !important;
				}

				td[class="td-product-image"] img, td.td-product-image img {
					width: 40px !important;
					height: 40px !important;
				}

				td[class="product-vt-margin"], td.product-vt-margin {
					width: 10px !important;
				}

				td[class="td-product-title"], td.td-product-title, td[class="td-product-price"], td.td-product-price {
					line-height: 18px !important;
				}

				td[class="fix-line-height-mobile"], td.fix-line-height-mobile {
					line-height: 24px !important;
				}

				[class="remove-border-bottom-mobile"], .remove-border-bottom-mobile {
					border-bottom: 0 !important;
				}

				td[class="padding-bottom-mobile-0"], td.padding-bottom-mobile-0 {
					padding-bottom: 0 !important;
				}

				td[class="padding-top-mobile-0"], td.padding-top-mobile-0 {
					padding-top: 0 !important;
				}

				td[class="padding-top-mobile-15"], td.padding-top-mobile-15 {
					padding-top: 15px !important;
				}

				p[class="tracking-code-block"], p.tracking-code-block {
					margin-bottom: 15px !important;
				}

				[class="border-top-right-radius-mobile"], .border-top-right-radius-mobile {
					border-top-right-radius: 5px;
				}
            }
            @media screen and (min-width:481px) and (max-width:768px) {
            	table[class="column_table"], table.column_table {
					width: 50% !important;
				}

				p[class="order-id"], p.order-id, p[class="order-date"], p.order-date {
					font-size: 16px !important;
				}
            }
		</style>

		{{ order_schema }}
	</head>
	<body class="{{ css_class }}">
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
											<td height="{{ is_email ? 30 : 60 }}" class="table-vt-margin">&nbsp;</td>
										</tr>
										<tr>
											<td align="center">
												{% if show_logo == true and logo_img_url %}
													<a href="{{ store.url }}"><img src="{{ logo_img_url }}" height="60" alt="{{ store.name }}" title="{{ store.name }}" border="0" style="height:60px;"/></a>
												{% else %}
													<a href="{{ store.url }}" style="font-size:40px; color: #666; text-decoration: none;">{{ store.name }}</a>
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
											<td bgcolor="#ffffff" style="border-radius:5px;">
												<div style="border-radius:5px;">

													{% if order.status_alias == 'canceled' %}
														{% set have_top_bar = true %}
														<div style="background-color:#d9534f;border-top-left-radius: 5px;border-top-right-radius: 5px;">
															<table bgcolor="#d9534f" width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;border-top-left-radius: 5px;border-top-right-radius: 5px;">
																<tr>
																	<td width="40" class="td-img-order-status" style="padding-top:15px;padding-bottom:15px;padding-left:20px;"><img src="{{ assets_url('assets/store/img/cancel.png') }}" width="40" alt="canceled" border="0" class="img-order-status"/></td>
																	<td width="20" style="padding-top:15px;padding-bottom:15px;">
																		<p>&nbsp;</p>
																	</td>
																	<td style="padding-top:15px;padding-bottom:15px;padding-right:20px;"><span style="color:#fff; text-transform:uppercase;font-size:18px;line-height:130%;">Encomenda cancelada</span></td>
																</tr>
															</table>
														</div>

													{% elseif order.status_alias == 'sent' %}
														{% set have_top_bar = true %}
														<div style="background-color:#00d4ed;border-top-left-radius: 5px;border-top-right-radius: 5px;">
															<table bgcolor="#00d4ed" width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;border-top-left-radius: 5px;border-top-right-radius: 5px;">
																<tr>
																	<td width="40" class="td-img-order-status" style="padding-top:15px;padding-bottom:15px;padding-left:20px;"><img src="{{ assets_url('assets/store/img/sent.png') }}" width="40" alt="paid" border="0" class="img-order-status"/></td>
																	<td width="20" style="padding-top:15px;padding-bottom:15px;">
																		<p>&nbsp;</p>
																	</td>
																	<td style="padding-top:15px;padding-bottom:15px;"><span style="color:#fff; text-transform:uppercase;font-size:18px;line-height:130%;">Encomenda enviada</span></td>
																	<td align="right" class="link-white" style="padding-top:15px;padding-bottom:15px;padding-right:20px;">
																		{% if order.tracking_code or order.tracking_url %}
																			<a href="{{ order.tracking_url ?: 'https://track.aftership.com/' ~ order.tracking_code }}" target="_blank" class="link-white btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff;text-align:center;">Seguir envio</a>
																		{% elseif order.invoice_permalink %}
																			<a href="{{ order.invoice_permalink }}" target="_blank" class="link-white btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff;text-align:center;">Ver factura</a>
																		{% endif %}
																	</td>
																</tr>
															</table>
														</div>

													{% elseif order.status_alias == 'delivered' %}
														{% set have_top_bar = true %}
														<div style="background-color:#8dc059;border-top-left-radius: 5px;border-top-right-radius: 5px;">
															<table bgcolor="#8dc059" width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;border-top-left-radius: 5px;border-top-right-radius: 5px;">
																<tr>
																	<td width="40" class="td-img-order-status" style="padding-top:15px;padding-bottom:15px;padding-left:20px;"><img src="{{ assets_url('assets/store/img/delivered.png') }}" width="40" alt="delivered" border="0" class="img-order-status"/></td>
																	<td width="20" style="padding-top:15px;padding-bottom:15px;">
																		<p>&nbsp;</p>
																	</td>
																	<td style="padding-top:15px;padding-bottom:15px;"><span style="color:#fff; text-transform:uppercase;font-size:18px;line-height:130%;">Encomenda entregue</span></td>
																	<td align="right" class="link-white" style="padding-top:15px;padding-bottom:15px;padding-right:20px;">
																		{% if order.invoice_permalink %}
																			<a href="{{ order.invoice_permalink }}" target="_blank" class="link-white btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff;text-align:center;">Ver factura</a>
																		{% endif %}
																	</td>
																</tr>
															</table>
														</div>

													{% elseif order.status_alias == 'returned' %}
														{% set have_top_bar = true %}
														<div style="background-color:#f0ad4e;border-top-left-radius: 5px;border-top-right-radius: 5px;">
															<table bgcolor="#f0ad4e" width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;border-top-left-radius: 5px;border-top-right-radius: 5px;">
																<tr>
																	<td width="40" class="td-img-order-status" style="padding-top:15px;padding-bottom:15px;padding-left:20px;"><img src="{{ assets_url('assets/store/img/undo.png') }}" width="40" alt="returned" border="0" class="img-order-status"/></td>
																	<td width="20" style="padding-top:15px;padding-bottom:15px;">
																		<p>&nbsp;</p>
																	</td>
																	<td style="padding-top:15px;padding-bottom:15px;"><span style="color:#fff; text-transform:uppercase;font-size:18px;line-height:130%;">Encomenda devolvida</span></td>
																	<td align="right" class="link-white" style="padding-top:15px;padding-bottom:15px;padding-right:20px;">
																		{% if order.tracking_code or order.tracking_url %}
																			<a href="{{ order.tracking_url ?: 'https://track.aftership.com/' ~ order.tracking_code }}" target="_blank" class="link-white btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff;text-align:center;">Seguir envio</a>
																		{% endif %}
																	</td>
																</tr>
															</table>
														</div>

													{% elseif order.status_alias == 'pickup_available' %}
														{% set have_top_bar = true %}
														<div style="background-color:#f0ad4e;border-top-left-radius: 5px;border-top-right-radius: 5px;">
															<table bgcolor="#999" width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;border-top-left-radius: 5px;border-top-right-radius: 5px;">
																<tr>
																	<td width="40" class="td-img-order-status" style="padding-top:15px;padding-bottom:15px;padding-left:20px;"><img src="{{ assets_url('assets/store/img/pickup_available.png') }}" width="40" alt="returned" border="0" class="img-order-status"/></td>
																	<td width="20" style="padding-top:15px;padding-bottom:15px;">
																		<p>&nbsp;</p>
																	</td>
																	<td style="padding-top:15px;padding-bottom:15px;"><span style="color:#fff; text-transform:uppercase;font-size:18px;line-height:130%;">Encomenda disponível para levantamento</span></td>
																	<td align="right" class="link-white" style="padding-top:15px;padding-bottom:15px;padding-right:20px;">
																		{% if order.tracking_code or order.tracking_url %}
																			<a href="{{ order.tracking_url ?: 'https://track.aftership.com/' ~ order.tracking_code }}" target="_blank" class="link-white btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff;text-align:center;">Seguir envio</a>
																		{% endif %}
																	</td>
																</tr>
															</table>
														</div>

													{% elseif order.paid == true %}
														{% set have_top_bar = true %}
														<div style="background-color:#8dc059;border-top-left-radius: 5px;border-top-right-radius: 5px;">
															<table bgcolor="#8dc059" width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;border-top-left-radius: 5px;border-top-right-radius: 5px;">
																<tr>
																	<td width="40" class="td-img-order-status" style="padding-top:15px;padding-bottom:15px;padding-left:20px;"><img src="{{ assets_url('assets/store/img/check.png') }}" width="40" alt="paid" border="0" class="img-order-status"/></td>
																	<td width="20" style="padding-top:15px;padding-bottom:15px;">
																		<p>&nbsp;</p>
																	</td>
																	<td style="padding-top:15px;padding-bottom:15px;"><span style="color:#fff; text-transform:uppercase;font-size:18px;line-height:130%;">Encomenda paga</span></td>
																	<td align="right" class="link-white" style="padding-top:15px;padding-bottom:15px;padding-right:20px;">
																		{% if order.invoice_permalink %}
																			<a href="{{ order.invoice_permalink }}" target="_blank" class="link-white btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff;text-align:center;">Ver factura</a>
																		{% elseif order.tracking_code or order.tracking_url %}
																			<a href="{{ order.tracking_url ?: 'https://track.aftership.com/' ~ order.tracking_code }}" target="_blank" class="link-white btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff;text-align:center;">Seguir envio</a>
																		{% endif %}
																	</td>
																</tr>
															</table>
														</div>
													{% endif %}

													{% if order.client_note %}
														{% set have_client_note = true %}
														<div style="background-color:#eeeeee;{% if have_top_bar != true %} border-top-left-radius: 5px;border-top-right-radius: 5px;{% endif %}">
															<table bgcolor="#eeeeee" width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="width:100% !important;{% if have_top_bar != true %} border-top-left-radius: 5px;border-top-right-radius: 5px;{% endif %}">
																<tr>
																	<td style="padding-top:15px;padding-bottom:15px;padding-left:20px;padding-right:20px;">
																		<span style="color:#999999;font-size:14px;">{{ order.client_note }}</span>
																	</td>
																</tr>
															</table>
														</div>
													{% endif %}

													<div class="remove-border-bottom-mobile" style="background-color:#ffffff;border-bottom:1px solid #eee; {% if have_top_bar != true and have_client_note != true %} border-top-left-radius: 5px;border-top-right-radius: 5px;{% endif %}">
														<table bgcolor="#ffffff" width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="font-size:18px;color:#999;width:100% !important;{% if have_top_bar != true and have_client_note != true %} border-top-left-radius: 5px;border-top-right-radius: 5px;{% endif %}">
															<tr>
																<td class="fix-line-height-mobile" width="100%" align="left" valign="top" style="line-height:14px;font-size:18px;">
																	<!--[if (gte mso 9)|(IE)]>
																		<table width="100%" align="center">
																			<tr>
																				<td width="50%">
																	<![endif]-->
																	<table bgcolor="#ffffff" width="290" align="left" border="0" cellpadding="0" cellspacing="0" class="column_table {% if have_top_bar != true and have_client_note != true %}border-top-right-radius-mobile{% endif %}" {% if have_top_bar != true and have_client_note != true %}style="border-top-left-radius: 5px;"{% endif %}>
																		<tr>
																			<td class="column-table-cell fix-padding-bottom padding-bottom-mobile-0" style="padding:30px 20px;">
																				<p class="visible-mobile" style="margin:0 0 0 0;color:#999;display:none;font-size:14px;">
																					<strong style="color:#666;">Encomenda</strong>
																				</p>
																				<p class="order-id" style="margin:0 0 0 0;">#{{ order.id }}</p>
																			</td>
																		</tr>
																	</table>
																	<!--[if (gte mso 9)|(IE)]>
																		</td>
																		<td width="50%">
																	<![endif]-->
																	<table bgcolor="#ffffff" width="290" border="0" cellpadding="0" cellspacing="0" class="column_table" {% if have_top_bar != true and have_client_note != true %}style="border-top-right-radius: 5px;"{% endif %}>
																		<tr>
																			<td class="column-table-cell fix-padding-top padding-bottom-mobile-0" style="padding:30px 20px;">
																				<p class="visible-mobile" style="margin:0 0 0 0;color:#999;display:none;font-size:14px;">
																					<strong style="color:#666;">Data</strong>
																				</p>
																				<p class="order-date" style="margin:0 0 0 0;text-align:right;"><span style="white-space:nowrap;">{{ order.created_at|date("j \\d\\e F \\d\\e Y") }}</span></p>
																			</td>
																		</tr>
																	</table>
																	<!--[if (gte mso 9)|(IE)]>
																			</td>
																		</tr>
																	</table>
																	<![endif]-->
																</td>
															</tr>
														</table>
													</div>

													<div style="background-color:#ffffff;border-bottom:1px solid #eee;">
														<table bgcolor="#ffffff" width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="width:100% !important;">
															<tr>
																<td width="100%" align="left" valign="top" style="line-height:24px;font-size:14px;">
																	<!--[if (gte mso 9)|(IE)]>
																		<table width="100%" align="center">
																			<tr>
																				<td width="50%">
																	<![endif]-->
																		<table bgcolor="#ffffff" width="290" align="left" border="0" cellpadding="0" cellspacing="0" class="column_table">
																			<tr>
																			<td class="column-table-cell column-order-status fix-padding-bottom padding-top-mobile-15" style="padding:30px 20px;">
																				<p style="margin:0 0 15px 0;color:#999;">
																					<strong style="color:#666;">Estado</strong>
																					<br /><span class="order-status-description">{{ order.status_description }}</span>
																				</p>

																				<p style="margin:0 0 15px 0;color:#999;">
																					<strong style="color:#666;">Envio</strong>
																					<br />{{ order.shipment_method ?: 'n/a' }}
																				</p>

																				{% if order.tracking_code or order.tracking_url %}
																					<p class="tracking-code-block" style="margin:0 0 0 0;color:#999;">
																						<strong style="color:#666;">Tracking</strong>
																						<br /><a href="{{ order.tracking_url ?: 'https://track.aftership.com/' ~ order.tracking_code }}" target="_blank">{{ order.tracking_code ?: 'Seguir envio' }}</a>
																					</p>
																				{% endif %}
																			</td>
																		</tr>
																	</table>
																	<!--[if (gte mso 9)|(IE)]>
																		</td>
																		<td width="50%">
																	<![endif]-->
																	<table bgcolor="#ffffff" width="290" align="right" border="0" cellpadding="0" cellspacing="0" class="column_table" style="border-left:1px solid #eee;">
																		<tr>
																			<td class="column-table-cell column-order-payment-detail fix-padding-top" style="padding:30px 20px;">
																				{% if order.payment.type == 'on_delivery' %}
																					{% set payment_img = store.payments.on_delivery.image %}
																					{% set payment_data = '<p style="color:#999;line-height:18px;font-size:12px;margin:5px 0 5px 0">' ~ store.payments.on_delivery.message|nl2br ~ '</p>' %}

																				{% elseif order.payment.type == 'pick_up' %}
																					{% set payment_img = store.payments.pick_up.image %}
																					{% set pickup_address = order.payment.data ? '<p style="line-height:18px;margin:5px 0 10px 0;"><strong>Morada de levantamento</strong><br>' ~ order.payment.data.name ~ '<br>' ~ order.payment.data.address ~ ' ' ~ order.payment.data.address_extra ~ '<br>' ~ order.payment.data.zip_code ~ ' ' ~ order.payment.data.city ~ '<br>' ~ order.payment.data.country ~ '<br></p>' : '' %}
																					{% set payment_data = pickup_address ~ '<p style="color:#999;line-height:18px;font-size:12px;margin:5px 0 5px 0">' ~ store.payments.pick_up.message|nl2br ~ '</p>' %}

																				{% elseif order.payment.type == 'multibanco' %}
																					{% set payment_img = store.payments.multibanco.image %}
																					{% set multibanco_reference = order.payment.data.reference|split('', 3) %}
																					{% set payment_data = '<p style="margin:0 0 0 0; line-height:24px;"><strong style="color:#666;">Entidade:</strong> ' ~ order.payment.data.entity ~ '</p><p style="margin:0 0 0 0; line-height:24px;"><strong style="color:#666;">Referência:</strong> <span style="padding: 0px 2px">' ~ multibanco_reference[0] ~ '</span><span style="padding: 0px 2px">' ~ multibanco_reference[1] ~ '</span><span style="padding: 0px 2px">' ~ multibanco_reference[2] ~ '</span></p><p style="margin:0 0 0 0; line-height:24px;"><strong style="color:#666;">Valor:</strong> ' ~ order.payment.data.value|money_with_sign(order.currency) ~ '</p>' %}

																				{% elseif order.payment.type == 'mbway' %}
																					{% set payment_img = store.payments.mbway.image %}
																					{% set payment_data = '<p style="margin:0 0 0 0; line-height:24px;">Telemóvel: <strong>' ~ order.payment.data.phone ~ '</strong></p>' %}

																				{% elseif order.payment.type == 'paypal' %}
																					{% set payment_img = store.payments.paypal.image %}
																					{% set payment_data = '<p style="margin:5px 0 5px 0;"><a href="' ~ order.payment.data.url ~ '" target="_blank" style="display: inline-block; padding:10px 20px; line-height:100%; color:#fff; border-radius:3px; text-decoration:none; font-size:14px; background-color: #009cde;" class="link-white">Pagar via Paypal</a></p>' %}

																				{% elseif order.payment.type == 'bank_transfer' %}
																					{% set payment_img = store.payments.bank_transfer.image %}
																					{% set bank_transfer_iban = order.payment.data ? '<p style="line-height:24px;margin:5px 0 10px 0;"><strong>IBAN</strong>: ' ~ order.payment.data ~ '</p>' : '' %}
																					{% set payment_data = bank_transfer_iban ~ '<p style="color:#999;line-height:18px;font-size:12px;margin:5px 0 5px 0">' ~ store.payments.bank_transfer.message|nl2br ~ '</p>' %}

																				{% elseif order.payment.type == 'credit_card' %}
																					{% set payment_img = store.payments.credit_card.image|replace({'credit_card': slug(order.payment.data.brand)}) %}
																					{% set payment_data = '<p style="line-height:24px;margin:5px 0 5px 0">Cartão <strong>' ~ order.payment.data.brand ~ '</strong> terminado em <strong>'~ order.payment.data.last4 ~ '</strong><br>Expira em '~ order.payment.data.exp_month ~'/' ~ order.payment.data.exp_year ~ '</p>' %}

																				{% elseif order.payment.type == 'custom' %}
																					{% set payment_data = '<p style="color:#999;line-height:18px;font-size:12px;">' ~ store.payments.custom.message|nl2br ~ '</p>' %}

																				{% endif %}

																				<p class="visible-mobile" style="margin:0 0 10px 0;color:#999;display:none;">
																					<strong style="color:#666;">Pagamento</strong>
																				</p>

																				<table width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;">
																					<tr>
																						<td width="70" align="left" valign="middle" class="td-payment-img">
																							{% if payment_img %}
																								<img class="payment-img" src="{{ payment_img }}" height="40" style="display:block;height:40px;" alt="{{ order.payment.title }}" border="0" />
																							{% else %}
																								<strong>{{ order.payment.title }}</strong>
																							{% endif %}
																						</td>
																						<td width="20" align="left" valign="middle" class="td-payment-img-sep">&nbsp;</td>
																						<td align="right" valign="middle" style="line-height:100%; font-size:24px; font-weight:bold; color:#000;">
																							<p class="order-total" style="margin:0 0 0 0; font-size:24px; white-space:nowrap;text-align:right;">{{ order.total|money_with_sign(order.currency) }}</p>
																						</td>
																					</tr>
																					<tr>
																						<td height="20" colspan="2">&nbsp;</td>
																					</tr>
																					<tr>
																						<td colspan="3">

																							{% if order.paid == false %}
																								{% if order.payment.type == 'multibanco' and not order.payment.data.reference %}
																									<p><small>Ocorreu um erro a gerar a referência Multibanco. <a href="{{ store.url ~ 'order/payment/' ~ order.hash }}">Tente novamente</a></small></p>
																								{% else %}
																									{{ payment_data }}

																									{% if order.payment.type != 'on_delivery' and order.payment.type != 'pick_up' %}
																										<p><small><a href="{{ store.url ~ 'order/payment/' ~ order.hash }}">Alterar método de pagamento</a></small></p>
																									{% endif %}
																								{% endif %}
																							{% elseif order.paid == true %}
																								<p style="color:#999;line-height:20px;font-size:13px;"><img src="{{ assets_url('assets/store/img/check-green.png') }}" width="15" height="15" alt="paid" border="0" class="img-order-status" style="vertical-align: text-bottom; width: 15px; height: 15px;"/> <strong>Encomenda paga</strong> em {{ order.paid_at|date("j \\d\\e F \\d\\e Y \\à\\s H:i") }}</p>
																							{% endif %}
																						</td>
																					</tr>
																				</table>
																			</td>
																		</tr>
																	</table>
																	<!--[if (gte mso 9)|(IE)]>
																			</td>
																		</tr>
																	</table>
																	<![endif]-->
																</td>
															</tr>
														</table>
													</div>
													<div style="background-color:#ffffff;border-bottom:1px solid #eee;line-height: 140%;">

														{% if order.products %}
															<table bgcolor="#ffffff" width="100%" border="0" cellpadding="0" cellspacing="0" style="border-bottom:1px solid #eee;width:100% !important;">

																{% for product in order.products %}
																	{% set last_product = loop.last %}
																	<tr>
																		<td class="td-product-image" valign="top" width="50" style="padding-top:30px;padding-left:20px;{% if last_product %}padding-bottom:30px;{% endif %}"><img src="{{ product.image.square }}" alt="{{ product.title }}" width="50" height="50" style="display:block;border-radius:5px;" border="0" /></td>
																		<td class="product-vt-margin" width="20" style="padding-top:30px;{% if last_product %}padding-bottom:30px;{% endif %}">&nbsp;</td>
																		<td class="td-product-title" valign="top" style="font-size: 14px;line-height:24px;padding-top:30px;{% if last_product %}padding-bottom:30px;{% endif %}">
																			<strong style="color:#666;">{{ product.title }}</strong>
																			{% if product.option %}
																				<br />{{ product.option }}&nbsp;
																			{% endif %}
																		</td>
																		<td class="product-vt-margin" width="20" style="padding-top:30px;{% if last_product %}padding-bottom:30px;{% endif %}">&nbsp;</td>
																		<td class="td-product-price" align="right" valign="top" style="font-size: 14px;line-height:24px;padding-top:30px;padding-right:20px;{% if last_product %}padding-bottom:30px;{% endif %}">
																			<span style="color:#ccc; white-space:nowrap;">{{ product.quantity }}x {{ product.price|money_with_sign(order.currency) }}</span><br />

																			{% set product_subtotal = product.price * product.quantity %}
																			<span style="color:#666; white-space:nowrap;">{{ product_subtotal|money_with_sign(order.currency) }}</span>
																		</td>
																	</tr>
																{% endfor %}

															</table>
														{% endif %}

														<table bgcolor="#ffffff" width="100%" border="0" cellpadding="0" cellspacing="0" style="line-height:100%;width:100% !important;">
															<tr>
																<td height="20" colspan="2" align="left">&nbsp;</td>
															</tr>
															<tr>
																<td height="30" align="left" valign="middle" style="font-size: 14px;line-height:24px;color:#999999;padding-left:20px;">Subtotal</td>
																<td height="30" align="right" valign="middle" style="font-size: 14px;line-height:24px;color:#999999;padding-right:20px;"><span style="white-space:nowrap;">{{ order.subtotal|money_with_sign(order.currency) }}</span></td>
															</tr>
															<tr>
																<td width="50%" height="30" align="left" valign="middle" style="font-size: 14px;line-height:24px;color:#999999;padding-left:20px;">Envio / Transporte</td>
																<td width="50%" height="30" align="right" valign="middle" style="font-size: 14px;line-height:24px;color:#999999;padding-right:20px;"><span style="white-space:nowrap;">{{ order.shipping.value|money_with_sign(order.currency) }}</span></td>
															</tr>

															{% if order.coupon %}
																<tr>
																	<td height="30" align="left" valign="middle" style="font-size: 14px;line-height:24px;color:#999999;padding-left:20px;">Desconto</td>
																	<td height="30" align="right" valign="middle" style="font-size: 14px;line-height:24px;color:#999999;padding-right:20px;"><span style="white-space:nowrap;">- {{ order.discount|money_with_sign(order.currency) }}</span></td>
																</tr>
															{% endif %}

															<tr>
																<td height="30" align="left" valign="middle" style="font-size: 14px;line-height:24px;color:#999999;padding-left:20px;">Imposto ({{ order.l10n.tax_name }})</td>
																<td height="30" align="right" valign="middle" style="font-size: 14px;line-height:24px;color:#999999;padding-right:20px;"><span style="white-space:nowrap;">{{ order.total_tax|money_with_sign(order.currency) }}</span></td>
															</tr>

															<tr>
																<td height="30" align="left" valign="middle" style="font-size: 14px;line-height:24px;color:#333333;padding-left:20px;"><strong style="color:#333;">Total</strong></td>
																<td height="30" align="right" valign="middle" style="font-size: 14px;line-height:24px;color:#333333;padding-right:20px;"><strong style="color:#333;white-space:nowrap;">{{ order.total|money_with_sign(order.currency) }}</strong></td>
															</tr>

															{% if order.tax_exemption %}
																<tr>
																	<td colspan="2" height="20" align="left" valign="middle" style="font-size: 11px;line-height:16px;color:#bbb;padding-left:20px;">Foi aplicada uma isenção de imposto: {{ order.tax_exemption|upper }}</td>
																</tr>
															{% endif %}

															<tr>
																<td height="20" colspan="2" align="left">&nbsp;</td>
															</tr>
														</table>
													</div>
													<div style="background-color:#ffffff;border-bottom:1px solid #eee;line-height: 160%;">
														<table bgcolor="#ffffff" width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="width:100% !important;">
															<tr>
																<td width="100%" align="left" valign="top">
																	<!--[if (gte mso 9)|(IE)]>
																		<table width="100%" align="center">
																			<tr>
																				<td width="50%">
																	<![endif]-->
																	<table bgcolor="#ffffff" width="290" align="left" border="0" cellpadding="0" cellspacing="0" class="column_table">
																		<tr>
																			<td class="column-table-cell fix-padding-bottom" style="padding:30px 20px;">
																				<p style="margin: 0 0 10px 0; line-height:24px;">
																					<strong style="color:#666; display:block; font-size:24px;">{{ order.client.name }}</strong>
																				</p>
																				<p style="margin: 0 0 0 0;font-size:14px;line-height:24px;">
																					<a href="mailto:{{ order.client.email }}" style="text-decoration:underline;color:#333">{{ order.client.email }}</a>
																				</p>
																			</td>
																		</tr>
																	</table>
																	<!--[if (gte mso 9)|(IE)]>
																		</td>
																		<td width="50%">
																	<![endif]-->
																	<table bgcolor="#ffffff" width="290" align="right" border="0" cellpadding="0" cellspacing="0" class="column_table">
																		<tr>
																			<td class="column-table-cell fix-padding-top" style="padding:30px 20px;">
																				<p style="margin: 0 0 0 0;font-size:14px;line-height:24px;color:#999999;">
																					<strong style="color: #666">Empresa:</strong> {{ order.client.company ?: 'n/a' }}<br>
																					<strong style="color: #666">{{ order.l10n.tax_id_abbr }}:</strong> {{ order.client.fiscal_id ?: 'n/a' }}
																				</p>
																			</td>
																		</tr>
																	</table>
																	<!--[if (gte mso 9)|(IE)]>
																			</td>
																		</tr>
																	</table>
																	<![endif]-->
																</td>
															</tr>
															<tr>
																<td colspan="2" height="1" style="border-bottom:1px solid #eee"></td>
															</tr>
															<tr>
																<td width="100%" align="left" valign="top" style="font-size:14px;line-height:24px;color:#999999;">
																	<!--[if (gte mso 9)|(IE)]>
																		<table width="100%" align="center">
																			<tr>
																				<td width="50%">
																	<![endif]-->
																	<table bgcolor="#ffffff" width="290" align="left" border="0" cellpadding="0" cellspacing="0" class="column_table">
																		<tr>
																			<td class="column-table-cell fix-padding-bottom" style="padding:30px 20px;">
																				<p style="margin:0 0 0 0;color:#666"><strong>Morada de envio</strong></p>
																				<p style="margin:0 0 0 0">{{ order.client.delivery.name }}</p>
																				<p style="margin:0 0 0 0">{{ order.client.delivery.address }} {{ order.client.delivery.address_extra }}</p>
																				<p style="margin:0 0 0 0">{{ order.client.delivery.zip_code }} {{ order.client.delivery.city }}</p>
																				<p style="margin:0 0 0 0">{{ order.client.delivery.country }}</p>
																				<p style="margin:0 0 0 0">Telefone: {{ order.client.delivery.phone ?: 'n/a' }}</p>
																				{% if order.tracking_code or order.tracking_url %}
																					<p><a href="{{ order.tracking_url ?: 'https://track.aftership.com/' ~ order.tracking_code }}" target="_blank" class="link-white" style="display: inline-block; padding:10px 15px; line-height:100%; color:#666; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #eee;text-align:center; background-color: #eee">Seguir envio</a></p>
																				{% endif %}
																			</td>
																		</tr>
																	</table>
																	<!--[if (gte mso 9)|(IE)]>
																		</td>
																		<td width="50%">
																	<![endif]-->
																	<table bgcolor="#ffffff" width="290" align="right" border="0" cellpadding="0" cellspacing="0" class="column_table" style="border-left:1px solid #eee;">
																		<tr>
																			<td class="column-table-cell fix-padding-top" style="padding:30px 20px;">
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
																	<!--[if (gte mso 9)|(IE)]>
																			</td>
																		</tr>
																	</table>
																	<![endif]-->
																</td>
															</tr>
														</table>
													</div>

													{% if order.custom_field %}
														<div style="background-color:#fff;border-bottom-left-radius: 5px;border-bottom-right-radius: 5px;font-size:14px;line-height:24px;color:#999999;{% if order.observations %}border-bottom:1px solid #eee;border-bottom-left-radius: 0px;border-bottom-right-radius: 0px{% endif %}">
															<table bgcolor="#ffffff" width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="width:100% !important;border-bottom-left-radius: 5px;border-bottom-right-radius: 5px;{% if order.observations %}border-bottom:1px solid #eee;border-bottom-left-radius: 0px;border-bottom-right-radius: 0px{% endif %}">
																<tr>
																	<td style="padding:30px 20px;">
																		{% for custom_field in order.custom_field|json_decode %}
																			<p style="margin: 0 0 5px 0;color:#666666;"><strong>{{ custom_field.title }}</strong></p>
																			{% if custom_field.data %}
																				{% for data in custom_field.data %}
																					<p style="margin: {{ not loop.parent.loop.last and not loop.last ? '0 0 0 0' : '0 0 15px 0' }};"><strong>{{ data.key }}</strong>: {{ data.value }}</p>
																				{% endfor %}
																			{% else %}
																				<p style="margin: {{ loop.last ? '0 0 0 0' : '0 0 15px 0' }};"><strong>{{ custom_field.key }}</strong>: {{ custom_field.value }}</p>
																			{% endif %}
																		{% endfor %}
																	</td>
																</tr>
															</table>
														</div>
													{% endif %}

													{% if order.observations %}
														<div style="background-color:#fff;border-bottom-left-radius: 5px;border-bottom-right-radius: 5px;font-size:14px;line-height:24px;color:#999999">
															<table bgcolor="#ffffff" width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="width:100% !important;border-bottom-left-radius: 5px;border-bottom-right-radius: 5px;">
																<tr>
																	<td style="padding:30px 20px;">
																		<p style="margin: 0 0 10px 0;color:#666666;"><strong>Observações:</strong></p>
																		<p style="margin: 0 0 0 0;">{{ order.observations }}</p>
																	</td>
																</tr>
															</table>
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
														<a href="https://shopk.it/?utm_source={{ store.username }}&amp;utm_medium=email&amp;utm_campaign=Shopkit-Email-Order" target="_blank"><img class="logo-footer" src="{{ assets_url('assets/frontend/img/logo-shopkit-black-transparent.png') }}" title="Powered by Shopkit" height="25" style="border:0;" border="0" alt="Powered by Shopkit" /></a>
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