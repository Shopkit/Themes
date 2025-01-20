{# Settings and variables of the e-mail template #}
{% set show_logo = true %} {# Show logo #}
{% set logo_img_url = store.logo %} {# Logo image URL. Replace store.logo with an absolute URL if you want to use another logo #}

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>{{ 'lang.email.order.subject'|t([order.status_description|lower, order.id]) }}</title>
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
				 color:#999999;
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

			.no-link, .no-link a {
				color: #999999 !important;
				text-decoration: none !important;
				font-size: inherit !important;
				font-family: inherit !important;
				font-weight: inherit !important;
				line-height: inherit !important;
			}

			span[class="hidden-mobile"], span.hidden-mobile {
				display: inline-block !important;
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

				span[class="hidden-mobile"], span.hidden-mobile {
					display: none !important;
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

				table[class="remove-table-height"], table.remove-table-height {
					height: 0 !important;
				}

				table[class="extra-options"], table.extra-options {
					width: 300px !important;
					margin-right: 20px !important;
					margin-left: 20px !important;
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
	<body class="{{ css_class }}" id="body">
		<div style="display:none;">{{ 'lang.email.order.subject'|t([order.status_description|lower, order.id]) }}</div>

		<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#f5f5f5" id="backgroundTable" style="background-color: #f5f5f5;font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif;font-size:14px; color:#999999;">
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
												<td align="center" style="color:#ccc;font-size:12px;"><a href="{{ order.permalink }}" style="color:#ccc;font-size:12px;" target="_blank">{{ 'lang.email.order.email_link.text'|t }}</a></td>
											</tr>
										{% endif %}
										<tr>
											<td height="30">&nbsp;</td>
										</tr>
										<tr>
											<td bgcolor="#ffffff" style="border-radius:5px;">
												<div style="border-radius:5px;">

													{% if order.paid == true and store.order_paid_default_status == order.status %}
														{% set have_top_bar = true %}
														<div style="background-color:#8dc059;border-top-left-radius: 5px;border-top-right-radius: 5px;">
															<table bgcolor="#8dc059" width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;border-top-left-radius: 5px;border-top-right-radius: 5px;">
																<tr>
																	<td width="40" class="td-img-order-status" style="padding-top:15px;padding-bottom:15px;padding-left:20px;"><img src="{{ assets_url('assets/store/img/check.png') }}" width="40" alt="paid" border="0" class="img-order-status"/></td>
																	<td width="20" style="padding-top:15px;padding-bottom:15px;">
																		<p>&nbsp;</p>
																	</td>
																	<td style="padding-top:15px;padding-bottom:15px;"><span style="color:#fff;font-size:20px;line-height:130%;">{{ 'lang.email.order.paid.status'|t }}</span></td>
																	<td align="right" style="padding-top:15px;padding-bottom:15px;padding-right:20px;">
																		{% if order.invoice_permalink %}
																			<a href="{{ order.invoice_permalink }}" target="_blank" class="btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff; text-align:center; white-space: nowrap;">{{ 'lang.storefront.order.invoice'|t }}</a>
																		{% elseif order.tracking_code or order.tracking_url %}
																			<a href="{{ order.tracking_url ?: 'https://track.aftership.com/' ~ order.tracking_code }}" target="_blank" class="btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff; text-align:center; white-space: nowrap;">{{ 'lang.storefront.order.tracking.button'|t }}</a>
																		{% endif %}
																	</td>
																</tr>
															</table>
														</div>

													{% elseif order.status_alias == 'canceled' %}
														{% set have_top_bar = true %}
														<div style="background-color:#d9534f;border-top-left-radius: 5px;border-top-right-radius: 5px;">
															<table bgcolor="#d9534f" width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;border-top-left-radius: 5px;border-top-right-radius: 5px;">
																<tr>
																	<td width="40" class="td-img-order-status" style="padding-top:15px;padding-bottom:15px;padding-left:20px;"><img src="{{ assets_url('assets/store/img/cancel.png') }}" width="40" alt="canceled" border="0" class="img-order-status"/></td>
																	<td width="20" style="padding-top:15px;padding-bottom:15px;">
																		<p>&nbsp;</p>
																	</td>
																	<td style="padding-top:15px;padding-bottom:15px;padding-right:20px;"><span style="color:#fff;font-size:20px;line-height:130%;">{{ 'lang.email.order.canceled.status'|t }}</span></td>
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
																	<td style="padding-top:15px;padding-bottom:15px;"><span style="color:#fff;font-size:20px;line-height:130%;">{{ 'lang.email.order.returned.status'|t }}</span></td>
																	<td align="right" style="padding-top:15px;padding-bottom:15px;padding-right:20px;">
																		{% if order.tracking_code or order.tracking_url %}
																			<a href="{{ order.tracking_url ?: 'https://track.aftership.com/' ~ order.tracking_code }}" target="_blank" class="btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff; text-align:center; white-space: nowrap;">{{ 'lang.storefront.order.tracking.button'|t }}</a>
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
																	<td style="padding-top:15px;padding-bottom:15px;"><span style="color:#fff;font-size:20px;line-height:130%;">{{ 'lang.email.order.delivered.status'|t }}</span></td>
																	<td align="right" style="padding-top:15px;padding-bottom:15px;padding-right:20px;">
																		{% if order.invoice_permalink %}
																			<a href="{{ order.invoice_permalink }}" target="_blank" class="btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff; text-align:center; white-space: nowrap;">{{ 'lang.storefront.order.invoice'|t }}</a>
																		{% endif %}
																	</td>
																</tr>
															</table>
														</div>

													{% elseif order.status_alias == 'pickup_available' %}
														{% set have_top_bar = true %}
														<div style="background-color:#f0ac4e;border-top-left-radius: 5px;border-top-right-radius: 5px;">
															<table bgcolor="#f0ac4e" width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;border-top-left-radius: 5px;border-top-right-radius: 5px;">
																<tr>
																	<td width="40" class="td-img-order-status" style="padding-top:15px;padding-bottom:15px;padding-left:20px;"><img src="{{ assets_url('assets/store/img/pickup_available.png') }}" width="40" alt="pickup_available" border="0" class="img-order-status"/></td>
																	<td width="20" style="padding-top:15px;padding-bottom:15px;">
																		<p>&nbsp;</p>
																	</td>
																	<td style="padding-top:15px;padding-bottom:15px;"><span style="color:#fff;font-size:20px;line-height:130%;">{{ 'lang.email.order.pickup_available.status'|t }}</span></td>
																	<td align="right" style="padding-top:15px;padding-bottom:15px;padding-right:20px;">
																		{% if order.tracking_code or order.tracking_url %}
																			<a href="{{ order.tracking_url ?: 'https://track.aftership.com/' ~ order.tracking_code }}" target="_blank" class="btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff; text-align:center; white-space: nowrap;">{{ 'lang.storefront.order.tracking.button'|t }}</a>
																		{% endif %}
																	</td>
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
																	<td style="padding-top:15px;padding-bottom:15px;">
																		<span style="color:#fff;font-size:20px;line-height:130%;">{{ 'lang.email.order.sent.status'|t }}</span>
																		{% if order.expected_arrival_from %}
																			<br><span style="font-size:11px;color:#d3f7fb;">
																				{% if order.expected_arrival_until %}
																					{{ 'lang.email.order.sent.expected_arrival_until'|t([order.expected_arrival_from|format_datetime('long', 'none'), order.expected_arrival_until|format_datetime('long', 'none')]) }}
																				{% else %}
																					{{ 'lang.email.order.sent.expected_arrival_from'|t([order.expected_arrival_from|format_datetime('long', 'none')]) }}
																				{% endif %}
																				</span>
																		{% endif %}
																	</td>
																	<td align="right" style="padding-top:15px;padding-bottom:15px;padding-right:20px;">
																		{% if order.tracking_code or order.tracking_url %}
																			<a href="{{ order.tracking_url ?: 'https://track.aftership.com/' ~ order.tracking_code }}" target="_blank" class="btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff; text-align:center; white-space: nowrap;">{{ 'lang.storefront.order.tracking.button'|t }}</a>
																		{% elseif order.invoice_permalink %}
																			<a href="{{ order.invoice_permalink }}" target="_blank" class="btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff; text-align:center; white-space: nowrap;">{{ 'lang.storefront.order.invoice'|t }}</a>
																		{% endif %}
																	</td>
																</tr>
															</table>
														</div>

													{% elseif order.status_alias == 'waiting_shipment' %}
														{% set have_top_bar = true %}
														<div style="background-color:#f0ac4e;border-top-left-radius: 5px;border-top-right-radius: 5px;">
															<table bgcolor="#f0ac4e" width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;border-top-left-radius: 5px;border-top-right-radius: 5px;">
																<tr>
																	<td width="40" class="td-img-order-status" style="padding-top:15px;padding-bottom:15px;padding-left:20px;"><img src="{{ assets_url('assets/store/img/waiting_shipment.png') }}" width="40" alt="waiting_shipment" border="0" class="img-order-status"/></td>
																	<td width="20" style="padding-top:15px;padding-bottom:15px;">
																		<p>&nbsp;</p>
																	</td>
																	<td style="padding-top:15px;padding-bottom:15px;">
																		<span style="color:#fff;font-size:20px;line-height:130%;">{{ 'lang.email.order.waiting_shipment.status'|t }}</span>
																	</td>
																	<td align="right" style="padding-top:15px;padding-bottom:15px;padding-right:20px;">
																		{% if order.tracking_code or order.tracking_url %}
																			<a href="{{ order.tracking_url ?: 'https://track.aftership.com/' ~ order.tracking_code }}" target="_blank" class="btn-header" style="display: inline-block; padding:10px 20px; line-height:100%; color:#ffffff; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #ffffff; text-align:center; white-space: nowrap;">{{ 'lang.storefront.order.tracking.button'|t }}</a>
																		{% endif %}
																	</td>
																</tr>
															</table>
														</div>

													{% elseif order.status_alias == 'processing' %}
														{% set have_top_bar = true %}
														<div style="background-color:#f0ac4e;border-top-left-radius: 5px;border-top-right-radius: 5px;">
															<table bgcolor="#f0ac4e" width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;border-top-left-radius: 5px;border-top-right-radius: 5px;">
																<tr>
																	<td width="40" class="td-img-order-status" style="padding-top:15px;padding-bottom:15px;padding-left:20px;"><img src="{{ assets_url('assets/store/img/processing.png') }}" width="40" alt="processing" border="0" class="img-order-status"/></td>
																	<td width="20" style="padding-top:15px;padding-bottom:15px;">
																		<p>&nbsp;</p>
																	</td>
																	<td style="padding-top:15px;padding-bottom:15px;">
																		<span style="color:#fff;font-size:20px;line-height:130%;">{{ 'lang.email.order.processing.status'|t }}</span>
																	</td>
																</tr>
															</table>
														</div>

													{% elseif order.status_alias == 'pending' %}
														{% set have_top_bar = true %}
														<div style="background-color:#f0ad4e;border-top-left-radius: 5px;border-top-right-radius: 5px;">
															<table bgcolor="#f0ad4e" width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;border-top-left-radius: 5px;border-top-right-radius: 5px;">
																<tr>
																	<td width="40" class="td-img-order-status" style="padding-top:15px;padding-bottom:15px;padding-left:20px;"><img src="{{ assets_url('assets/store/img/pending.png') }}" width="40" alt="pending" border="0" class="img-order-status"/></td>
																	<td width="20" style="padding-top:15px;padding-bottom:15px;">
																		<p>&nbsp;</p>
																	</td>
																	<td style="padding-top:15px;padding-bottom:15px;">
																		<span style="color:#fff;font-size:20px;line-height:130%;">{{ 'lang.email.order.pending.status'|t }}</span>
																	</td>
																</tr>
															</table>
														</div>

													{% elseif order.status_alias == 'waiting_stock' %}
														{% set have_top_bar = true %}
														<div style="background-color:#f0ad4e;border-top-left-radius: 5px;border-top-right-radius: 5px;">
															<table bgcolor="#f0ad4e" width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;border-top-left-radius: 5px;border-top-right-radius: 5px;">
																<tr>
																	<td width="40" class="td-img-order-status" style="padding-top:15px;padding-bottom:15px;padding-left:20px;"><img src="{{ assets_url('assets/store/img/waiting.png') }}" width="40" alt="waiting_stock" border="0" class="img-order-status"/></td>
																	<td width="20" style="padding-top:15px;padding-bottom:15px;">
																		<p>&nbsp;</p>
																	</td>
																	<td style="padding-top:15px;padding-bottom:15px;">
																		<span style="color:#fff;font-size:20px;line-height:130%;">{{ 'lang.email.order.waiting_stock.status'|t }}</span>
																	</td>
																</tr>
															</table>
														</div>

													{% elseif order.status_alias == 'waiting_payment' %}
														{% set have_top_bar = true %}
														<div style="background-color:#f0ad4e;border-top-left-radius: 5px;border-top-right-radius: 5px;">
															<table bgcolor="#f0ad4e" width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;border-top-left-radius: 5px;border-top-right-radius: 5px;">
																<tr>
																	<td width="40" class="td-img-order-status" style="padding-top:15px;padding-bottom:15px;padding-left:20px;"><img src="{{ assets_url('assets/store/img/waiting.png') }}" width="40" alt="waiting_payment" border="0" class="img-order-status"/></td>
																	<td width="20" style="padding-top:15px;padding-bottom:15px;">
																		<p>&nbsp;</p>
																	</td>
																	<td style="padding-top:15px;padding-bottom:15px;">
																		<span style="color:#fff;font-size:20px;line-height:130%;">{{ 'lang.email.order.waiting_payment.status'|t }}</span>
																	</td>
																</tr>
															</table>
														</div>

													{% elseif order.status_alias == 'waiting_confirmation' %}
														{% set have_top_bar = true %}
														<div style="background-color:#f0ad4e;border-top-left-radius: 5px;border-top-right-radius: 5px;">
															<table bgcolor="#f0ad4e" width="100%" border="0" cellpadding="0" cellspacing="0" style="width:100% !important;border-top-left-radius: 5px;border-top-right-radius: 5px;">
																<tr>
																	<td width="40" class="td-img-order-status" style="padding-top:15px;padding-bottom:15px;padding-left:20px;"><img src="{{ assets_url('assets/store/img/waiting.png') }}" width="40" alt="waiting_confirmation" border="0" class="img-order-status"/></td>
																	<td width="20" style="padding-top:15px;padding-bottom:15px;">
																		<p>&nbsp;</p>
																	</td>
																	<td style="padding-top:15px;padding-bottom:15px;">
																		<span style="color:#fff;font-size:20px;line-height:130%;">{{ 'lang.email.order.waiting_confirmation.status'|t }}</span>
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

													<div class="remove-border-bottom-mobile" style="background-color:#ffffff;border-bottom: 1px solid #eee;{% if have_top_bar != true and have_client_note != true %} border-top-left-radius: 5px;border-top-right-radius: 5px;{% endif %}">

														<table bgcolor="#ffffff" width="100%" border="0" align="center" cellpadding="0" cellspacing="0" style="font-size:18px;color:#999999;width:100% !important;{% if have_top_bar != true and have_client_note != true %} border-top-left-radius: 5px;border-top-right-radius: 5px;{% endif %}">
															<tr>
																<td class="fix-line-height-mobile" width="100%" align="left" valign="top" style="line-height:14px;font-size:18px;">
																	<!--[if (gte mso 9)|(IE)]>
																		<table width="100%" align="center" style="border-bottom: 1px solid #eee;">
																			<tr>
																				<td width="50%">
																	<![endif]-->
																	<table bgcolor="#ffffff" width="290" align="left" border="0" cellpadding="0" cellspacing="0" class="column_table {% if have_top_bar != true and have_client_note != true %}border-top-right-radius-mobile{% endif %}" {% if have_top_bar != true and have_client_note != true %}style="border-top-left-radius: 5px;"{% endif %}>
																		<tr>
																			<td class="column-table-cell fix-padding-bottom padding-bottom-mobile-0" style="padding:30px 20px;">
																				<p class="visible-mobile" style="margin:0 0 0 0;color:#999999;display:none;font-size:14px;">
																					<strong style="color:#666;">{{ 'lang.storefront.order.label'|t }}</strong>
																				</p>
																				<p class="order-id" style="margin:0 0 0 0;" class="no-link"><span class="hidden-mobile">{{ 'lang.storefront.order.label'|t }}&nbsp;</span>#{{ order.id }}</p>
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
																				<p class="visible-mobile" style="margin:0 0 0 0;color:#999999;display:none;font-size:14px;">
																					<strong style="color:#666;">{{ 'lang.storefront.order.date'|t }}</strong>
																				</p>
																				<p class="order-date" style="margin:0 0 0 0;text-align:right;"><span style="white-space:nowrap;">{{ order.updated_at|format_datetime('long', 'none') }}</span></p>
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
																<td width="100%" align="left" valign="top" style="line-height:24px;font-size:14px;height:0;">
																	<!--[if (gte mso 9)|(IE)]>
																		<table width="100%" align="center">
																			<tr>
																				<td width="50%">
																	<![endif]-->
																	<table bgcolor="#ffffff" width="290" align="left" border="0" cellpadding="0" cellspacing="0" class="column_table">
																		<tr>
																			<td class="column-table-cell column-order-status fix-padding-bottom padding-top-mobile-15" valign="top" style="padding:30px 20px;">
																				<p style="margin:0 0 15px 0;color:#999999;">
																					<strong style="color:#666;">{{ 'lang.storefront.order.status'|t }}</strong>
																					<br /><span class="order-status-description">{{ order.status_description }}</span>
																				</p>

																				<p style="margin:0 0 15px 0;color:#999999;">
																					<strong style="color:#666;">{{ 'lang.storefront.order.shipping.title'|t }}</strong>
																					<br />{{ order.shipment_method ?: 'n/a' }}
																				</p>

																				{% if order.tracking_code or order.tracking_url %}
																					<p class="tracking-code-block" style="margin:0 0 0 0;color:#999999;">
																						<strong style="color:#666;">{{ 'lang.storefront.order.tracking'|t }}</strong>
																						<br /><span><a x-apple-data-detectors="true" href="{{ order.tracking_url ?: 'https://track.aftership.com/' ~ order.tracking_code }}" style="color:#333333;text-decoration:underline;" target="_blank">{{ order.tracking_code ?: 'lang.storefront.order.tracking.button'|t }}</a></span>																					</p>
																				{% endif %}
																			</td>
																		</tr>
																	</table>
																	<!--[if (gte mso 9)|(IE)]>
																		</td>
																		<td width="50%">
																	<![endif]-->
																	<table bgcolor="#ffffff" width="290" align="right" border="0" cellpadding="0" cellspacing="0" class="column_table remove-table-height" style="border-left:1px solid #eee;height:100%;">
																		<tr>
																			<td class="column-table-cell column-order-payment-detail fix-padding-top" valign="top" style="padding:30px 20px;">
																				{% if order.payment.type == 'on_delivery' %}
																					{% set payment_img = store.payments.on_delivery.image %}
																					{% set payment_data = '<p style="color:#999999;line-height:18px;font-size:12px;margin:5px 0 5px 0">' ~ store.payments.on_delivery.message|nl2br ~ '</p>' %}

																				{% elseif order.payment.type == 'pick_up' %}
																					{% set payment_img = store.payments.pick_up.image %}
																					{% set pickup_address = order.payment.data ? '<p style="line-height:18px;margin:5px 0 10px 0;"><strong>' ~ 'lang.storefront.order.pick_up_address'|t ~ '</strong><br>' ~ order.payment.data.name ~ '<br>' ~ order.payment.data.address ~ ' ' ~ order.payment.data.address_extra ~ '<br>' ~ order.payment.data.zip_code ~ ' ' ~ order.payment.data.city ~ '<br>' ~ order.payment.data.country ~ '<br></p>' : '' %}
																					{% set payment_info = pickup_address ~ '<p style="color:#999999;line-height:18px;font-size:12px;margin:5px 0 5px 0">' ~ store.payments.pick_up.message|nl2br ~ '</p>' %}

																				{% elseif order.payment.type == 'multibanco' %}
																					{% set payment_img = store.payments.multibanco.image %}
																					{% set multibanco_reference = order.payment.data.reference|split('', 3) %}
																					{% set payment_data = '<p style="margin:0 0 0 0; line-height:20px;"><strong style="color:#666;">' ~ 'lang.storefront.order.payment.multibanco.entity'|t ~ ':</strong> ' ~ order.payment.data.entity ~ '</p><p style="margin:0 0 0 0; line-height:20px;"><strong style="color:#666;">' ~ 'lang.storefront.order.payment.multibanco.reference'|t ~ ':</strong> <span style="padding: 0px 2px">' ~ multibanco_reference[0] ~ '</span><span style="padding: 0px 2px">' ~ multibanco_reference[1] ~ '</span><span style="padding: 0px 2px">' ~ multibanco_reference[2] ~ '</span></p><p style="margin:0 0 0 0; line-height:20px;"><strong style="color:#666;">' ~ 'lang.storefront.order.payment.multibanco.value'|t ~ ':</strong> ' ~ order.payment.data.value|money_with_sign(order.currency) ~ '</p> <p style="color:#999999;line-height:18px;font-size:12px;margin:5px 0 5px 0">' ~ store.payments.multibanco.message|nl2br ~ '</p>' %}

																				{% elseif order.payment.type == 'mbway' %}
																					{% set payment_img = store.payments.mbway.image %}
																					{% set payment_info = order.payment.data.phone ? '<p style="margin:0 0 0 0; line-height:20px;">' ~ 'lang.storefront.form.cellphone.label'|t ~ ': <strong>' ~ order.payment.data.phone ~ '</strong></p>' : null %}
																					{% set payment_data = '<p style="color:#999999;line-height:18px;font-size:12px;margin:5px 0 5px 0">' ~ store.payments.mbway.message|nl2br ~ '</p>' %}

																				{% elseif order.payment.type == 'paypal' %}
																					{% set payment_img = store.payments.paypal.image %}
																					{% set payment_data = '<p style="color:#999999;line-height:18px;font-size:12px;margin:5px 0 5px 0">' ~ store.payments.paypal.message|nl2br ~ '</p>' %}


																				{% elseif order.payment.type == 'bank_transfer' %}
																					{% set payment_img = store.payments.bank_transfer.image %}
																					{% set bank_transfer_iban = order.payment.data ? '<p style="line-height:20px;margin:5px 0 10px 0;word-break: break-all;"><strong>' ~ 'lang.storefront.order.payment.bank_transfer.label'|t ~ '</strong>: ' ~ order.payment.data ~ '</p>' : '' %}
																					{% set payment_data = '<p style="color:#999999;line-height:18px;font-size:12px;margin:5px 0 5px 0">' ~ store.payments.bank_transfer.message|nl2br ~ '</p>' %}
																					{% set payment_info = bank_transfer_iban %}

																				{% elseif order.payment.type == 'credit_card' %}
																					{% set payment_img = store.payments.credit_card.image|replace({'credit_card': slug(order.payment.data.brand)}) %}
																					{% set payment_info = order.payment.data.last4 ? '<p style="line-height:20px;margin:5px 0 5px 0">' ~ 'lang.email.order.payments.credit_card.data'|t([order.payment.data.brand, order.payment.data.last4, order.payment.data.exp_month, order.payment.data.exp_year]) ~ '</p>' : null %}
																					{% set payment_data = '<p style="color:#999999;line-height:18px;font-size:12px;margin:5px 0 5px 0">' ~ store.payments.credit_card.message|nl2br ~ '</p>' %}

																				{% elseif order.payment.type == 'wallets' %}
																					{% set payment_img = order.payment.data ? store.payments.wallets.image|replace({'wallets': order.payment.data.wallet}) : store.payments.wallets.image %}
																					{% set payment_data = '<p style="color:#999999;line-height:18px;font-size:12px;margin:5px 0 5px 0">' ~ store.payments.wallets.message|nl2br ~ '</p>' %}

																				{% elseif order.payment.type == 'klarna' %}
																					{% set payment_img = store.payments.klarna.image %}
																					{% set payment_info = order.payment.data.payment_method_category ? '<p style="line-height:20px;margin:5px 0 5px 0"><strong style="color:#666;">' ~ 'lang.email.order.payments.klarna.label'|t ~ ':</strong> ' ~ order.payment.data.payment_method_category ~ '</p>' : null %}
																					{% set payment_data = '<p style="color:#999999;line-height:18px;font-size:12px;margin:5px 0 5px 0">' ~ store.payments.klarna.message|nl2br ~ '</p>' %}

																				{% elseif order.payment.type == 'payshop' %}
																					{% set payment_img = store.payments.payshop.image %}
																					{% set payment_data = '<p style="margin:0 0 0 0; line-height:24px;"><strong style="color:#666;">' ~ 'lang.storefront.order.payment.multibanco.reference'|t ~ ':</strong> ' ~ order.payment.data.reference ~ '</p><p style="margin:0 0 0 0; line-height:24px;"><strong style="color:#666;">' ~ 'lang.storefront.order.payment.multibanco.value'|t ~ ':</strong> ' ~ order.payment.data.value|money_with_sign(order.currency) ~ '</p> <p style="color:#999999;line-height:18px;font-size:12px;margin:5px 0 5px 0">' ~ store.payments.payshop.message|nl2br ~ '</p>' %}

																				{% elseif order.payment.type == 'custom' %}
																					{% set payment_data = '<p style="color:#999999;line-height:18px;font-size:12px;">' ~ store.payments.custom.message|nl2br ~ '</p>' %}

																				{% endif %}

																				<p class="visible-mobile" style="margin:0 0 10px 0;color:#999999;display:none;">
																					<strong style="color:#666;">{{ 'lang.storefront.order.payment.title'|t }}</strong>
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

																							{% if order.paid == false and order.status_alias != 'canceled' %}
																								{% if order.payment.type == 'multibanco' and not order.payment.data.reference %}
																									<p><small>{{ 'lang.storefront.order.payment.multibanco.error_message'|t }} <a href="{{ store.url ~ 'order/payment/' ~ order.hash }}">{{ 'lang.email.order.payments.try_again'|t }}</a></small></p>
																								{% else %}
																									{{ payment_data }}
																									{{ payment_info }}

																									{% if order.payment.type != 'on_delivery' and order.payment.type != 'pick_up' %}
																										<p><a x-apple-data-detectors="true" href="{{ store.url ~ 'order/payment/' ~ order.hash }}" style="display: inline-block; padding:10px 15px; line-height:18px; color:#666; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #eee;text-align:center; background-color: #eee">{{ 'lang.storefront.order.change_payment_method'|t }}</a></p>
																									{% endif %}
																								{% endif %}
																							{% elseif order.paid == true %}
																								{{ payment_info }}
																								<p style="color:#999999;line-height:20px;font-size:13px;"><img src="{{ assets_url('assets/store/img/check-green.png') }}" width="16" height="16" alt="paid" border="0" class="img-payment-status" style="vertical-align: text-bottom; width: 16px; height: 16px;"/> {{ 'lang.email.order.paid.date'|t([order.paid_at|format_datetime('long','long')]) }}</p>
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
													<div style="background-color:#ffffff;line-height: 140%;">

														{% if order.products %}
															<table bgcolor="#ffffff" width="100%" border="0" cellpadding="0" cellspacing="0" style="border-bottom:1px solid #eee;width:100% !important;">

																{% for product in order.products|filter(p => p.is_product) %}
																	{% set last_product = loop.last %}
																	<tr>
																		<td style="{% if last_product and product.extras %}padding-bottom:30px;{% endif %}">
																			<table bgcolor="#ffffff" width="100%" border="0" cellpadding="0" cellspacing="0" style="{% if not product.extras %}border-bottom:1px solid #eee;{% endif %}width:100% !important;">
																				<tr>
																					{% set product_td_padding_bottom = product.extras ? '' : 'padding-bottom:30px;' %}

																					<td class="td-product-image" valign="top" width="50" style="padding-top:30px;padding-left:20px;{{ product_td_padding_bottom }}"><img src="{{ product.image.square }}" alt="{{ product.title }}" width="50" height="50" style="display:block;border-radius:5px;" border="0" /></td>
																					<td class="product-vt-margin" width="20" style="padding-top:30px;{{ product_td_padding_bottom }}">&nbsp;</td>
																					<td class="td-product-title" valign="top" style="font-size: 14px;line-height:24px;padding-top:30px;{{ product_td_padding_bottom }}">
																						<strong style="color:#333333;">{{ product.title|replace({(' - ' ~ product.option): ''}) }}</strong>
																						{% if product.option %}
																							<br />{{ product.option }}&nbsp;
																						{% endif %}
																					</td>
																					<td class="product-vt-margin" width="20" style="padding-top:30px;{{ product_td_padding_bottom }}">&nbsp;</td>
																					<td class="td-product-price" align="right" valign="top" style="font-size: 14px;line-height:24px;padding-top:30px;padding-right:20px;{{ product_td_padding_bottom }}">
																						{% set product_subtotal = (product.price * product.quantity) + product.price_extras %}
																						<span style="color:#333333; white-space:nowrap;"><strong>{{ product_subtotal|money_with_sign(order.currency) }}</strong></span><br />
																						<span style="color:#bbbbbb; white-space:nowrap;">{{ product.quantity }}x {{ product.price|money_with_sign(order.currency) }}</span>
																					</td>
																				</tr>
																			</table>

																			{% if product.extras %}
																				<table bgcolor="#ffffff" align="left" width="370" border="0" cellpadding="0" cellspacing="0" class="extra-options" style="border-bottom:1px solid #eee;width:370px;margin-top:10px;margin-left:90px;border-top-left-radius:5px;border-top-right-radius:5px;">
																					<thead bgcolor="#eeeeee" style="border-top-left-radius: 5px;border-top-right-radius:5px;">
																						<tr style="border-top-left-radius: 5px;border-top-right-radius:5px;">
																							{% set extra_qtd = product.extras|length %}
																							{% set option_text = extra_qtd == 1 ? 'lang.storefront.product.extra_options.singular.label'|t : 'lang.storefront.product.extra_options.plural.label'|t %}
																							<th align="left" colspan="2" style="padding-top:10px;padding-right:0px;padding-bottom:10px;padding-left:10px;border-top-left-radius: 5px;color:#888888;">{{ extra_qtd }} {{ option_text }}</th>
																							<th align="right" colspan="2" style="padding-top:10px;padding-right:10px;padding-bottom:10px;padding-left:0px;border-top-right-radius:5px;color:#888888;">{{ product.price_extras|money_with_sign(order.currency) }}</th>
																						</tr>
																					</thead>
																					<tbody>
																						{% for extra in product.extras %}
																							<tr style="border-bottom: 1px solid #eee;">
																								<td align="left" style="width:1px;height: 100%;background: #eee;" width="1"></td>
																								<td align="left" valign="top" style="padding-top:10px;padding-right:0px;padding-bottom:10px;padding-left:10px;">
																									<strong style="color:#888888;font-size:12px;">{{ extra.title }}</strong><br>
																									<span style="color:#666666;font-size:12px;">{{ extra.value }}</span>
																								</td>
																								<td align="right" valign="top" style="padding-top:10px;padding-right:10px;padding-bottom:10px;padding-left:0px;">
																									<div style="font-size:12px;color:#999999"><span style="color:#999999;">{{ extra.quantity }}x</span> {{ (extra.price|money_with_sign(order.currency) ) }}</div>
																								</td>
																								<td align="right" style="width:1px;height: 100%;background: #eee;" width="1"></td>
																							</tr>
																						{% endfor %}
																					</tbody>
																				</table>
																			{% endif %}
																		</td>
																	</tr>
																{% endfor %}

															</table>
														{% endif %}

														<table bgcolor="#ffffff" width="100%" border="0" cellpadding="0" cellspacing="0" style="line-height:100%;width:100% !important;border-bottom:1px solid #eee;">
															<tr>
																<td height="20" colspan="2" align="left">&nbsp;</td>
															</tr>
															<tr>
																<td height="30" align="left" valign="middle" style="font-size: 14px;line-height:24px;color:#666666;padding-left:20px;">{{ 'lang.storefront.layout.subtotal.title'|t }}</td>
																<td height="30" align="right" valign="middle" style="font-size: 14px;line-height:24px;color:#666666;padding-right:20px;"><span style="white-space:nowrap;">{{ order.subtotal|money_with_sign(order.currency) }}</span></td>
															</tr>

															{% if order.coupon %}
																<tr>
																	<td height="30" align="left" valign="middle" style="font-size: 14px;line-height:24px;color:#666666;padding-left:20px;">{{ 'lang.storefront.order.discount'|t }} <small style="color:#bbb;">({{ order.coupon.code }})</small></td>
																	<td height="30" align="right" valign="middle" style="font-size: 14px;line-height:24px;color:#666666;padding-right:20px;"><span style="white-space:nowrap;">{{ order.coupon.type == 'shipping' ? 'lang.storefront.cart.order_summary.free_shipping'|t : '- ' ~ order.discount|money_with_sign(order.currency) }}</span></td>
																</tr>
															{% endif %}

															<tr>
																<td width="50%" height="30" align="left" valign="middle" style="font-size: 14px;line-height:24px;color:#666666;padding-left:20px;">{{ 'lang.storefront.order.shipping.title'|t }}</td>
																<td width="50%" height="30" align="right" valign="middle" style="font-size: 14px;line-height:24px;color:#666666;padding-right:20px;"><span style="white-space:nowrap;">{{ order.coupon.type == 'shipping' ? 'lang.storefront.cart.order_summary.shipping_total.free'|t : order.shipping.value|money_with_sign(order.currency) }}</span></td>
															</tr>

															{% if order.payment.value %}
															<tr>
																<td width="50%" height="30" align="left" valign="middle" style="font-size: 14px;line-height:24px;color:#666666;padding-left:20px;">{{ 'lang.storefront.cart.order_summary.total_payment'|t }} <small style="color:#bbb;">({{ order.payment.title }})</small></td>
																<td width="50%" height="30" align="right" valign="middle" style="font-size: 14px;line-height:24px;color:#666666;padding-right:20px;"><span style="white-space:nowrap;">{{ order.payment.value|money_with_sign(order.currency) }}</span></td>
															</tr>
															{% endif %}

															{% if not order.tax_settings.included %}
															<tr>
																<td height="30" align="left" valign="middle" style="font-size: 14px;line-height:24px;color:#666666;padding-left:20px;">{{ 'lang.email.order.tax.label'|t([order.l10n.tax_name]) }}</td>
																<td height="30" align="right" valign="middle" style="font-size: 14px;line-height:24px;color:#666666;padding-right:20px;"><span style="white-space:nowrap;">{{ order.total_tax|money_with_sign(order.currency) }}</span></td>
															</tr>
															{% endif %}

															<tr>
																<td height="30" align="left" valign="middle" style="font-size: 14px;line-height:24px;color:#000000;padding-left:20px;"><strong style="color:#000000;">{{ 'lang.storefront.order.total'|t }}</strong></td>
																<td height="30" align="right" valign="middle" style="font-size: 14px;line-height:24px;color:#000000;padding-right:20px;"><strong style="color:#000000;white-space:nowrap;">{{ order.total|money_with_sign(order.currency) }}</strong></td>
															</tr>

															{% if order.tax_exemption %}
																<tr>
																	<td colspan="2" height="20" align="left" valign="middle" style="font-size: 11px;line-height:16px;color:#bbb;padding-left:20px;">{{ 'lang.email.order.tax.exemption'|t([order.tax_exemption|upper]) }}</td>
																</tr>
															{% elseif order.tax_settings.included %}
																<tr>
																	<td colspan="2" height="20" align="left" valign="middle" style="font-size: 11px;line-height:16px;color:#bbb;padding-left:20px;">{{ 'lang.storefront.cart.order_summary.taxes_included'|t([order.l10n.tax_name, order.total_tax|money_with_sign(order.currency)]) }}</td>
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
																					{% if store.settings.cart.field_company != 'hidden' %}
																						<strong style="color: #666">{{ 'lang.storefront.order.client.company'|t }}:</strong> {{ order.client.company ?: 'n/a' }}<br>
																					{% endif %}
																					{% if store.settings.cart.field_fiscal_id != 'hidden' %}
																						<strong style="color: #666">{{ order.l10n.tax_id_abbr }}:</strong> {{ order.client.fiscal_id ?: 'n/a' }}
																					{% endif %}
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
																<td width="100%" align="left" valign="top" style="font-size:14px;line-height:24px;color:#999999;height:0;">
																	<!--[if (gte mso 9)|(IE)]>
																		<table width="100%" align="center">
																			<tr>
																				<td width="50%">
																	<![endif]-->
																	<table bgcolor="#ffffff" width="290" align="left" border="0" cellpadding="0" cellspacing="0" class="column_table">
																		<tr>
																			<td class="column-table-cell fix-padding-bottom" valign="top" style="padding:30px 20px;">
																				<p style="margin:0 0 0 0;color:#666"><strong>{{ 'lang.storefront.order.delivery.address'|t }}</strong></p>
																				<p style="margin:0 0 0 0">{{ order.client.delivery.name }}</p>
																				<p style="margin:0 0 0 0" class="no-link">{{ order.client.delivery.address }} {{ order.client.delivery.address_extra }}</p>
																				<p style="margin:0 0 0 0" class="no-link">{{ order.client.delivery.zip_code }} {{ order.client.delivery.city }}</p>
																				<p style="margin:0 0 0 0">{{ order.client.delivery.country }}</p>
																				{% if store.settings.cart.field_delivery_phone != 'hidden' %}
																					<p style="margin:0 0 0 0" class="no-link">{{ 'lang.storefront.form.phone.label'|t }}: {{ order.client.delivery.phone ?: 'n/a' }}</p>
																				{% endif %}
																				{% if order.tracking_code or order.tracking_url %}
																					<p><a href="{{ order.tracking_url ?: 'https://track.aftership.com/' ~ order.tracking_code }}" target="_blank" style="display: inline-block; padding:10px 15px; line-height:100%; color:#666; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #eee;text-align:center; background-color: #eee">{{ 'lang.storefront.order.tracking.button'|t }}</a></p>
																				{% endif %}
																			</td>
																		</tr>
																	</table>
																	<!--[if (gte mso 9)|(IE)]>
																		</td>
																		<td width="50%">
																	<![endif]-->
																	<table bgcolor="#ffffff" width="290" align="right" border="0" cellpadding="0" cellspacing="0" class="column_table remove-table-height" style="border-left:1px solid #eee;height:100%;">
																		<tr>
																			<td class="column-table-cell fix-padding-top" valign="top" style="padding:30px 20px;">
																				<p style="margin:0 0 0 0;color:#666"><strong>{{ 'lang.storefront.order.billing.address'|t }}</strong></p>
																				<p style="margin:0 0 0 0">{{ order.client.billing.name }}</p>
																				<p style="margin:0 0 0 0" class="no-link">{{ order.client.billing.address }} {{ order.client.billing.address_extra }}</p>
																				<p style="margin:0 0 0 0" class="no-link">{{ order.client.billing.zip_code }} {{ order.client.billing.city }}</p>
																				<p style="margin:0 0 0 0">{{ order.client.billing.country }}</p>
																				{% if store.settings.cart.field_billing_phone != 'hidden' %}
																					<p style="margin:0 0 0 0" class="no-link">{{ 'lang.storefront.form.phone.label'|t }}: {{ order.client.billing.phone ?: 'n/a' }}</p>
																				{% endif %}
																				{% if order.invoice_permalink %}
																					<p><a href="{{ order.invoice_permalink }}" target="_blank" style="display: inline-block; padding:10px 15px; line-height:100%; color:#666; border-radius:3px; text-decoration:none; font-size:14px; border:1px solid #eee;text-align:center; background-color: #eee">{{ 'lang.storefront.order.invoice'|t }}</a></p>
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
																		<p style="margin: 0 0 10px 0;color:#666666;"><strong>{{ 'lang.storefront.order.observations'|t }}:</strong></p>
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
											<td align="center" style="color:#ccc;font-size:12px;">{{ 'lang.email.order.date'|t([order.created_at|format_datetime('long','long')]) }}</td>
										</tr>

										{% if store.show_branding %}
											<tr>
												<td height="30">&nbsp;</td>
											</tr>
											<tr>
												<td align="center">
													<div style="display:inline-block; border-top: 1px solid #ddd; padding-left:30px; padding-right:30px; padding-top:30px;">
														<span style="opacity: 0.25;margin-top: 30px;margin-bottom: 30px;text-align: center;color: #000;font-size: 9px;">{{ 'lang.storefront.layout.footer.poweredby'|t }}</span>
														<br>
														<a href="https://shopk.it/?utm_source={{ store.username }}&amp;utm_medium=email&amp;utm_campaign=Shopkit-Email-Order" title="Powered by Shopkit e-commerce" target="_blank" rel="nofollow"><img class="logo-footer" src="{{ assets_url('assets/frontend/img/logo-shopkit-black-transparent.png') }}" title="Powered by Shopkit e-commerce" height="25" style="border:0;" border="0" alt="Powered by Shopkit e-commerce" /></a>
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
