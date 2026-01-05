{# Settings and variables of the e-mail template #}
{% set show_logo = true %} {# Show logo #}
{% set logo_img_url = store.logo %} {# Logo image URL. Replace store.logo with an absolute URL if you want to use another logo #}

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>{{ email_subject }}</title>
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
            }
            @media screen and (min-width:481px) and (max-width:768px) {
            	table[class="column_table"], table.column_table {
					width: 50% !important;
				}
            }
		</style>
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
															<tr>
																<td width="100%" align="left" valign="top" style="line-height:18px;font-size:14px;">
																	<div style="margin:20px;">
																		<p style="color:#666;font-size:14px;">
																			{{ 'lang.storefront.layout.greetings'|t }} {{ email_data.name|first_word }},<br><br>
																			{{ 'lang.email.digital_files.main_text'|t }} <a href="{{ email_data.order.permalink }}" target="_blank">#{{ email_data.order.id }}</a>.
																		</p>
																	</div>
																</td>
															</tr>
														</table>
													</div>
													{# <div style="background-color:#ffffff;line-height: 140%;"> #}
													<div style="background-color:red;line-height: 140%;">

														{% if email_data.order.products %}
															<table bgcolor="#ffffff" width="100%" border="0" cellpadding="0" cellspacing="0" style="border-bottom:1px solid #eee;width:100% !important;">

																{% for product in email_data.order.products|filter(p => p.is_product and p.type == 'digital') %}
																	{% set last_product = loop.last %}
																	<tr>
																		<td style="padding-bottom:30px;border-bottom:1px solid #eee;">
																			<table bgcolor="#ffffff" width="100%" border="0" cellpadding="0" cellspacing="0" style="{% if not product.files %}border-bottom:1px solid #eee;{% endif %}width:100% !important;">
																				<tr>
																					{% set product_td_padding_bottom = product.files ? '' : 'padding-bottom:30px;' %}

																					<td class="td-product-image" valign="top" width="50" style="padding-top:30px;padding-left:20px;{{ product_td_padding_bottom }}"><img src="{{ product.image.square }}" alt="{{ product.image.alt ? product.image.alt : product.title }}" width="50" height="50" style="display:block;border-radius:5px;" border="0" /></td>
																					<td class="product-vt-margin" width="20" style="padding-top:30px;{{ product_td_padding_bottom }}">&nbsp;</td>
																					<td class="td-product-title" valign="top" style="font-size: 14px;line-height:24px;padding-top:30px;{{ product_td_padding_bottom }}">
																						<strong style="color:#333333;">{{ product.title|replace({(' - ' ~ product.option): ''}) }}</strong>
																						{% if product.option %}
																							&nbsp;<span style="color:#bbbbbb;">({{ product.option }})&nbsp;</span>
																						{% endif %}
																						{% if product.files_settings %}
																							{% set days = product.files_settings.allowed_days ? 'now'|date_modify('+'~ product.files_settings.allowed_days ~' days')|format_datetime('long','none') : 'lang.storefront.account.orders.order.files.not_expire'|t %}
																							{% set downloads = product.files_settings.allowed_downloads ? product.files_settings.allowed_downloads : 'lang.email.digital_files.unlimited.label'|t %}
																							<br /><span style="font-size:13px;color:#666666;">{{ 'lang.email.digital_files.files.expire'|t }}: {{ downloads }}. {{ 'lang.storefront.account.orders.order.files.expire'|t }}: {{ days }}</span>
																						{% endif %}
																					</td>
																				</tr>
																			</table>

																			{% if product.files %}
																				<table bgcolor="#ffffff" align="left" width="430" border="0" cellpadding="0" cellspacing="0" class="extra-options" style="border-bottom:1px solid #eee;width:430px;margin-top:10px;margin-left:90px;border-top-left-radius:5px;border-top-right-radius:5px;">
																					<thead bgcolor="#eeeeee" style="border-top-left-radius: 5px;border-top-right-radius:5px;">
																						<tr style="border-top-left-radius: 5px;border-top-right-radius:5px;">
																							<th align="left" colspan="4" style="padding-top:10px;padding-right:0px;padding-bottom:10px;padding-left:10px;border-top-left-radius: 5px;border-top-right-radius: 5px;color:#888888;">{{ 'lang.storefront.account.orders.order.files.title'|t }}</th>
																						</tr>
																					</thead>
																					<tbody>
																						{% for file in product.files %}
																							{% set button_label = file.size ? 'lang.storefront.account.orders.order.files.download'|t : 'lang.storefront.account.orders.order.files.open'|t %}
																							{% set file_size_info = file.size ? '&nbsp;<span style="font-size:12px;color:#999999;">('~file.size~')</span>' : '' %}
																							{% set file_ext_info = file.ext ? '<span style="font-size:11px;padding-left:4px;padding-right:4px;padding-bottom:2px;padding-top:2px;border-top-left-radius:2.5px;border-top-right-radius:2.5px;border-bottom-left-radius:2.5px;border-bottom-right-radius:2.5px;background-color:#777777;color:#ffffff;font-weight: bold;">'~ file.ext ~'</span>&nbsp;' : '' %}
																							<tr style="border-bottom: 1px solid #eee;">
																								<td align="left" style="width:1px;height: 100%;background: #eee;" width="1"></td>
																								<td align="left" valign="top" style="padding-top:10px;padding-right:0px;padding-bottom:10px;padding-left:10px;">{{ file_ext_info ~ file.title ~ file_size_info }}</td>
																								<td align="right" valign="top" style="padding-top:10px;padding-right:10px;padding-bottom:10px;padding-left:0px;"><a href="{{ file.url }}" target="_blank" style="text-decoration: underline;color: #333;border: 1px solid #eee;padding: 5px 10px;border-radius: 3px;text-decoration: none;font-weight: bold;font-size:12px;">{{ button_label }}</a></td>
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
														<a href="https://shopk.it/?utm_source={{ store.username }}&amp;utm_medium=email&amp;utm_campaign=Shopkit-Email-Abandoned-Cart" title="Powered by Shopkit e-commerce" target="_blank" rel="nofollow"><img class="logo-footer" src="{{ assets_url('assets/frontend/img/logo-shopkit-black-transparent.png') }}" title="Powered by Shopkit e-commerce" height="25" style="border:0;" border="0" alt="Powered by Shopkit e-commerce" /></a>
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