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
																	<div style="margin:20px;color:#666666;font-size:14px;">

																		<p style="color:#666;font-size:14px;">
																			{{ 'lang.storefront.layout.greetings'|t }} {{ email_data.name|first_word }},
																		</p>

																		{% if email_data.step != 'expiring' %}
																			<p>
																				<h3 style="margin: 0;">{{ 'lang.email.rewards.lead'|t([email_data.client.rewards|rewards_label]) }}</h3>
																			</p>
																		{% endif %}

																		<p>
																			{% if email_data.step == 'order' %}
																				{{ 'lang.email.rewards.order.text'|t([email_data.points|rewards_label,email_data.order_id]) }}
																			{% endif %}

																			{% if email_data.step == 'signup' %}
																				{{ 'lang.email.rewards.signup.text'|t([email_data.points|rewards_label]) }}
																			{% endif %}

																			{% if email_data.step == 'newsletter' %}
																				{{ 'lang.email.rewards.newsletter.text'|t([email_data.points|rewards_label]) }}
																			{% endif %}

																			{% if email_data.step == 'birthday' %}
																				{{ 'lang.email.rewards.birthday.text'|t([email_data.points|rewards_label]) }}
																			{% endif %}

																			{% if email_data.step == 'reviews' %}
																				{{ 'lang.email.rewards.reviews.text'|t([email_data.points|rewards_label,email_data.product_title]) }}
																			{% endif %}

																			{% if email_data.step == 'expiring' %}
																				{{ 'lang.email.rewards.expiring.text'|t([email_data.points|rewards_label,email_data.points_expire_date|format_datetime('long', 'none')]) }}
																			{% endif %}

																			{% if email_data.step != 'expiring' and email_data.points_expire_date %}
																				<br>{{ 'lang.email.rewards.expire'|t([email_data.points_label|capitalize,email_data.points_expire_date|format_datetime('long', 'none'),email_data.points_label]) }}
																			{% endif %}
																		</p>

																		{% if email_data.step != 'expiring' %}
																			<table width="100%" cellpadding="0" cellspacing="0" border="0" style="font-family: \'Helvetica Neue\', Helvetica, Arial, sans-serif; background-color: #ffffff; padding: 20px;">
																				<tr>
																					<td style="font-size: 16px; font-weight: bold; padding-bottom: 10px;">
																					{{ 'lang.email.rewards.label.other'|t([email_data.points_label]) }}
																					</td>
																				</tr>
																				<tr>
																					<td bgcolor="#f5f5f5" style="background-color: #f5f5f5; padding: 15px; border-radius: 5px;">
																						<table cellpadding="0" cellspacing="0" border="0" width="100%" style="margin-bottom: 15px;">
																							<tr>
																								<td style="font-size: 14px;">
																									<strong>{{ 'lang.email.rewards.label.order'|t }}</strong><br>
																									<span style="color: #999999;">{{ 'lang.email.rewards.label.order.text'|t([store.settings.rewards.order_ratio|rewards_label,1|money_with_sign(store.currency)]) }}</span>
																								</td>
																							</tr>
																						</table>

																						{% set rewards = [] %}
																						{% if store.settings.rewards.signup %}
																							{% set rewards = rewards|merge(['signup']) %}
																						{% endif %}
																						{% if store.settings.rewards.newsletter %}
																							{% set rewards = rewards|merge(['newsletter']) %}
																						{% endif %}
																						{% if store.settings.rewards.birthday %}
																							{% set rewards = rewards|merge(['birthday']) %}
																						{% endif %}
																						{% if store.settings.rewards.reviews %}
																							{% set rewards = rewards|merge(['reviews']) %}
																						{% endif %}

																						{% for type in rewards %}
																							<table cellpadding="0" cellspacing="0" border="0" width="100%" style="{% if not loop.last %}margin-bottom: 15px;{% endif %}">
																								<tr>
																									<td style="font-size: 14px;">
																										<strong>{{ ('lang.email.rewards.label.' ~ type)|t }}</strong><br>
																										<span style="color: #999999;">{{ store.settings.rewards[type ~ '_ratio']|rewards_label }}</span>
																									</td>
																								</tr>
																							</table>
																						{% endfor %}
																					</td>
																				</tr>
																			</table>
																		{% endif %}

																		{% if email_data.page %}
																			<p>
																				{{ 'lang.email.rewards.page.text'|t|replace({'{{ email_data.points_label }}': email_data.points_label}) }} <a href="{{ email_data.page.url }}" style="color: #666; text-decoration: underline;">{{ 'lang.email.rewards.page.link'|t|replace({'{{ email_data.page.title }}': email_data.page.title}) }}</a>.
																			</p>
																		{% endif %}

																		<p style="text-align:center;margin-top: 30px"><a href="{{ store.url }}" target="_blank" class="link-white" style="display: inline-block; padding:15px 30px; line-height:100%; color:{{ get_contrast_color(store.basecolor) }}; border-radius:3px; text-decoration:none; font-size:16px; border:0;text-align:center; background-color: {{ store.basecolor }}; font-weight: bold;">{{ 'lang.email.signup.store_link'|t }}</a></p>
																	</div>
																</td>
															</tr>
														</table>
													</div>

												</div>
											</td>
										</tr>
										<tr>
											<td height="30">&nbsp;</td>
										</tr>
										<tr>
											<td align="center" style="font-size:12px;line-height:24px;color:#999999">
												{{ 'lang.email.rewards.unsubscribe.text'|t|replace({'{{ email_data.points_label }}': email_data.points_label}) }} <a href="{{ email_data.unsubscribe_url }}" style="color: #666; text-decoration: underline;">{{ 'lang.email.rewards.unsubscribe.button'|t }}</a>.
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
														<a href="https://shopk.it/?utm_source={{ store.username }}&amp;utm_medium=email&amp;utm_campaign=Shopkit-Email-Product-Reviews" title="Powered by Shopkit e-commerce" target="_blank" rel="nofollow"><img class="logo-footer" src="{{ assets_url('assets/frontend/img/logo-shopkit-black-transparent.png') }}" title="Powered by Shopkit e-commerce" height="25" style="border:0;" border="0" alt="Powered by Shopkit e-commerce" /></a>
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
