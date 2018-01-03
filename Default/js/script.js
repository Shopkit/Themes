$(document).ready(function() {

	if (Modernizr.mq('only screen and (min-width: 767px)')) {
		$('.products img').imagesLoaded(function() {

			masonry();

			$(window).resize(function() {
				masonry();
			});
		});
	}

	$('.modal-alert').modal('show')

	if (Modernizr.mq('only screen and (min-width: 979px)')) {
		if (typeof(imgs_slideshow) != "undefined") {
			$('.slideshow').crossSlide({
				speed: 45,
				fade: 1
			}, imgs_slideshow);
		} else {
			if ($('.slideshow img').length == 1) {
				$('.slideshow-wrapper .slideshow').css({ 'background': 'url(' + $('.slideshow img').attr('src') + ') center center / cover no-repeat' }).children('div').remove();
			}
		}
	}

	$('a.fancy').fancybox({
		'overlayColor': '#fff',
		onStart: function() {
			$('.fancybox-bg').remove();
			$('#fancybox-close').html('<i class="fa fa-times"></i>');
			$('#fancybox-loading').html('<i class="fa fa-2x fa-spinner"></i>');
			$('#fancybox-left > span').html('<i class="fa fa-chevron-left"></i>');
			$('#fancybox-right > span').html('<i class="fa fa-chevron-right"></i>');
		}
	});

	if (Modernizr.mq('only screen and (min-width: 767px)')) {
		$('.video-iframe').each(function(index) {
			src = $(this).attr('data-src');
			$(this).replaceWith('<iframe  src="' + src + '" frameborder="0" allowfullscreen></iframe>');
		});
	}

	$('.col-left nav ul li h4 a[href="#"]').click(function(e) {
		e.preventDefault();
	});

	check_shipping($('input[name="pagamento"]:checked'));

	$('input[name="pagamento"]').change(function() {
		check_shipping($(this));
	});

	$('[data-toggle=tooltip]').tooltip();

	$('form').submit(function() {
		$('body').css({ 'cursor': 'wait' });
		$(this).find('input[type=submit], button[type=submit]').attr('disabled', 'true').fadeTo('fast', 0.25);
	});

	//Trigger first set of options
	if (typeof product !== 'undefined' && product.option_groups.length > 0) {
		if (product.option_groups.length > 1) {
			$('.data-product-price, .price del').text('');
		}
		product_options(product, true);
	}

	//Event on change
	$(document).on('change', '.select-product-options', function() {
		product_options(product);
	});

	//price on request button
	$('a.price-on-request').on('click', function() {

		var options = " - ";

		$('select.select-product-options').each(function(index, el) {
			options = options + $(this).children('option:selected').data('title') + " / ";
		});

		$(this).prop('href', $(this).prop('href') + options.slice(0, -3) + '#contact-form');
	})

	//Billing / Delivery data
	$(document).on('change', '#billing_info_same_delivery', function(event) {
		var _this = $(this);
		var target = _this.data('target');
		$(target).toggleClass('hidden');
	});

	$.getScript("https://maps.googleapis.com/maps/api/js?key=AIzaSyDrsZsLYT4ntjtQ4DFgtw0ZG-WfMMn4z28&libraries=places", function() {
		$('#delivery_address').geocomplete().bind('geocode:result', function(event, result) {
			$.each(data_places(result.address_components), function(index, value) {
				$('.delivery-info input[data-places="' + index + '"]').prop('value', value);
				if (index == 'country') {
					$('.delivery-info #delivery_country').val(countries_alpha_2[value]);
				}
			});
		});

		$('#billing_address').geocomplete().bind('geocode:result', function(event, result) {
			$.each(data_places(result.address_components), function(index, value) {
				$('.billing-info input[data-places="' + index + '"]').prop('value', value);
				if (index == 'country') {
					$('.billing-info #billing_country').val(countries_alpha_2[value]);
				}
			});
		});
	});
});

function masonry() {
	if (Modernizr.mq('only screen and (max-width: 767px)')) {
		$('.products').masonry('destroy').removeAttr('style');
	} else {
		$('.products').masonry({ isAnimated: true });
	}
}

function enable_shipping() {
	$('.shipping-methods').fadeTo('fast', 1).find('input').prop('disabled', false);
}

function disable_shipping() {
	$('.shipping-methods').fadeTo('fast', 0.25).find('input').prop('disabled', 'disabled');
}

function check_shipping(el) {
	if (el.prop('value') == 'Levantamento nas instalações') {
		disable_shipping();
	} else {
		enable_shipping();
	}
}

function product_options(product, onload) {
	onload = typeof onload !== 'undefined' ? onload : false;

	if ($('.select-product-options').length) {
		$('.form-cart').fadeTo('fast', 0.25);

		var default_option = product_default_option(product);

		$('.select-product-options').each(function(i) {
			if (onload == true) {
				$('option[value="' + default_option[i] + '"]', this).prop('selected', true);
			}
			var option = $('option:selected', this);
			window['id_variant_' + (i + 1)] = option.attr('value');
		});

		var data_product_options = { id_variant_1: window.id_variant_1, id_variant_2: window.id_variant_2, id_variant_3: window.id_variant_3 }
		var product_handle = product.handle;
		var disable_form_product;

		$.post('/product-options/' + product_handle, data_product_options, function(response) {

			var price_txt;
			var stock_qty;

			$('.form-cart').fadeTo('fast', 1);

			if (response) {
				if (response.price_on_request === true) {
					$('body').addClass('price-on-request');

					price_txt = 'Preço sob consulta';
					disable_form_product = true;
				} else {
					$('body').removeClass('price-on-request');

					if (product_is_vendible(product, response)) {
						if (response.promo === true) {
							$('.price del').text(response.price_formatted);
							price_txt = response.price_promo_formatted;
							if (response.price_promo_percentage) {
								$('.data-promo-percentage').text('Desconto de '+response.price_promo_percentage+'%');
							}
						} else {
							$('.price del').text('');
							price_txt = response.price_formatted;
							$('.data-promo-percentage').text('');
						}

						disable_form_product = false;
					} else {
						price_txt = 'Não disponível';
						disable_form_product = true;
					}

					stock_qty = response.stock_qty;
				}

				if (response.image) {
					$('img[itemprop="image"]').prop('src', response.image.full);
					$('img[itemprop="image"]').parent('a').prop('href', response.image.full);
				}

				if (response.wishlist) {
					if (response.wishlist.status) {
						wishlist_html = '<i class="fa fa-heart-o fa-fw"></i> Remover da wishlist';
						wishlist_url = response.wishlist.remove_url;
					} else {
						wishlist_html = '<i class="fa fa-heart fa-fw"></i> Adicionar à wishlist';
						wishlist_url = response.wishlist.add_url;
					}
					$('.wishlist a').html(wishlist_html).attr('href', wishlist_url);
				}

				reference = response.reference;
			} else {
				price_txt = 'Não disponível';
				stock_qty = 0;
				disable_form_product = true;
				reference = '';
			}

			if (disable_form_product === true) {
				$('.price del').text('');
				$('.data-promo-percentage').text('');
			}

			$('.data-product-price').text(price_txt);
			$('.data-product-stock_qty').text(stock_qty);
			$('span[itemprop="sku"]').text(reference);

			$('.form-cart input[name="qtd"], .form-cart button[type="submit"]').prop('disabled', disable_form_product);

			product_options_url();

		}, 'json');
	}
}

function product_options_url() {
	$('.select-product-options').on('change', function() {
		var pathname = window.location.pathname;
		var origin = window.location.origin;
		var selected_option = { 0: null, 1: null, 2: null };
		var k = 0;

		$('.select-product-options').each(function(index, el) {
			selected_option[k] = $('option:selected', this).prop('value');
			++k;
		});

		for (var i = 0; i < product.options.length; i++) {
			if (product.options[i].id_variant_1 == selected_option[0] && product.options[i].id_variant_2 == selected_option[1] && product.options[i].id_variant_3 == selected_option[2]) {
				var option = product.options[i].id;
			}
		}

		if (option) {
			var query = '?option=' + option;
		}

		if (query) {
			if (window.history.replaceState) {
				window.history.replaceState(null, null, origin + pathname + query);
			}
		}
	});

	return false;
}

function product_is_vendible(product, response) {
	//Check if there object is not null
	if (response) {
		//Check product stock
		if (product.stock.stock_enabled) {
			if (response.stock_qty > 0) {
				return true;
			} else {
				if (product.stock.stock_backorder) {
					return true;
				} else {
					return false;
				}
			}
		} else {
			return true;
		}
	} else {
		return false;
	}
}

//check product default option
function product_default_option(product) {
	var option = 'false';
	var query = window.location.search.substring(1);

	//get query string value
	if (query) {
		var option_id = query.split('option=')[1];
		option_id = option_id.split('&')[0];
	}

	//set default option from query string
	if (typeof option_id !== 'undefined' && product.option_groups.length > 0) {
		for (var i = 0; i < product.options.length; i++) {
			if (product.options[i].id == option_id) {
				option = i;
			}
		}
	} else {
		//get default option
		for (var i = 0; i < product.options.length; i++) {
			if (product.options[i].active === true) {
				if (product.options[i].price_on_request === true) {
					option = i;
				} else {
					if (product.stock.stock_enabled) {
						if (product.stock.stock_backorder || product.options[i].stock > 0) {
							option = i;
						}
					} else {
						option = i;
					}
				}

				if ($.isNumeric(option)) {
					i = product.options.length;
				}
			}
		}
	}

	if (isNaN(option)) {
		option = 0;
	}

	return option = {
		0: product.options[option].id_variant_1,
		1: product.options[option].id_variant_2,
		2: product.options[option].id_variant_3
	};
}

function data_places(address_components) {
	var places_data = {};
	var componentForm = {
		street_number: 'short_name',
		route: 'long_name',
		locality: 'long_name',
		administrative_area_level_1: 'short_name',
		country: 'short_name',
		postal_code: 'short_name',
		postal_code_prefix: 'short_name'
	};

	for (var i = 0; i < address_components.length; i++) {
		var addressType = address_components[i].types[0];
		if (componentForm[addressType]) {
			places_data[addressType] = address_components[i][componentForm[addressType]];
		}
	}

	if (places_data['postal_code_prefix']) {
		places_data['postal_code'] = places_data['postal_code_prefix'];
	}

	return places_data;
}

var countries_alpha_2 = { "PT": "PRT", "AF": "AFG", "ZA": "ZAF", "AL": "ALB", "DE": "DEU", "AD": "AND", "AO": "AGO", "AI": "AIA", "AQ": "ATA", "AG": "ATG", "SA": "SAU", "DZ": "DZA", "AR": "ARG", "AM": "ARM", "AW": "ABW", "AU": "AUS", "AT": "AUT", "AZ": "AZE", "BS": "BHS", "BH": "BHR", "BD": "BGD", "BB": "BRB", "BE": "BEL", "BZ": "BLZ", "BJ": "BEN", "BM": "BMU", "BY": "BLR", "BO": "BOL", "BA": "BIH", "BW": "BWA", "BR": "BRA", "BN": "BRN", "BG": "BGR", "BF": "BFA", "BI": "BDI", "BT": "BTN", "CV": "CPV", "CM": "CMR", "KH": "KHM", "CA": "CAN", "QA": "QAT", "KZ": "KAZ", "TD": "TCD", "CL": "CHL", "CN": "CHN", "CY": "CYP", "CO": "COL", "KM": "COM", "KP": "PRK", "KR": "KOR", "CI": "CIV", "CR": "CRI", "HR": "HRV", "CU": "CUB", "CW": "CUW", "DK": "DNK", "DJ": "DJI", "DM": "DMA", "EG": "EGY", "SV": "SLV", "AE": "ARE", "EC": "ECU", "ER": "ERI", "SK": "SVK", "SI": "SVN", "ES": "ESP", "PS": "PSE", "FM": "FSM", "US": "USA", "EE": "EST", "ET": "ETH", "FJ": "FJI", "PH": "PHL", "FI": "FIN", "FR": "FRA", "GA": "GAB", "GM": "GMB", "GH": "GHA", "GE": "GEO", "GI": "GIB", "GD": "GRD", "GR": "GRC", "GL": "GRL", "GP": "GLP", "GU": "GUM", "GT": "GTM", "GG": "GGY", "GY": "GUY", "GF": "GUF", "GN": "GIN", "GQ": "GNQ", "GW": "GNB", "HT": "HTI", "HN": "HND", "HK": "HKG", "HU": "HUN", "YE": "YEM", "BV": "BVT", "IM": "IMN", "CX": "CXR", "HM": "HMD", "NF": "NFK", "KY": "CYM", "CC": "CCK", "CK": "COK", "FO": "FRO", "GS": "SGS", "FK": "FLK", "MP": "MNP", "MH": "MHL", "UM": "UMI", "PN": "PCN", "SB": "SLB", "TC": "TCA", "VI": "VIR", "VG": "VGB", "IN": "IND", "ID": "IDN", "IR": "IRN", "IQ": "IRQ", "IE": "IRL", "IS": "ISL", "IL": "ISR", "IT": "ITA", "JM": "JAM", "JP": "JPN", "JE": "JEY", "JO": "JOR", "KI": "KIR", "KW": "KWT", "LA": "LAO", "LS": "LSO", "LV": "LVA", "LB": "LBN", "LR": "LBR", "LY": "LBY", "LI": "LIE", "LT": "LTU", "LU": "LUX", "MO": "MAC", "MG": "MDG", "MY": "MYS", "MW": "MWI", "MV": "MDV", "ML": "MLI", "MT": "MLT", "MA": "MAR", "MQ": "MTQ", "MU": "MUS", "MR": "MRT", "YT": "MYT", "MX": "MEX", "MZ": "MOZ", "MD": "MDA", "MC": "MCO", "MN": "MNG", "ME": "MNE", "MS": "MSR", "MM": "MMR", "NA": "NAM", "NR": "NRU", "NP": "NPL", "NI": "NIC", "NE": "NER", "NG": "NGA", "NU": "NIU", "NO": "NOR", "NC": "NCL", "NZ": "NZL", "OM": "OMN", "NL": "NLD", "BQ": "BES", "PW": "PLW", "PA": "PAN", "PG": "PNG", "PK": "PAK", "PY": "PRY", "PE": "PER", "PF": "PYF", "PL": "POL", "PR": "PRI", "KE": "KEN", "KG": "KGZ", "GB": "GBR", "CF": "CAF", "CZ": "CZE", "MK": "MKD", "CD": "COD", "CG": "COG", "DO": "DOM", "RE": "REU", "RO": "ROU", "RW": "RWA", "RU": "RUS", "EH": "ESH", "WS": "WSM", "AS": "ASM", "SM": "SMR", "SH": "SHN", "LC": "LCA", "BL": "BLM", "KN": "KNA", "MF": "MAF", "SX": "SXM", "PM": "SPM", "ST": "STP", "VC": "VCT", "SC": "SYC", "SN": "SEN", "SL": "SLE", "RS": "SRB", "SG": "SGP", "SY": "SYR", "SO": "SOM", "LK": "LKA", "SZ": "SWZ", "SD": "SDN", "SS": "SSD", "SE": "SWE", "CH": "CHE", "SR": "SUR", "SJ": "SJM", "TH": "THA", "TW": "TWN", "TJ": "TJK", "TZ": "TZA", "TF": "ATF", "IO": "IOT", "TL": "TLS", "TG": "TGO", "TO": "TON", "TK": "TKL", "TT": "TTO", "TN": "TUN", "TM": "TKM", "TR": "TUR", "TV": "TUV", "UA": "UKR", "UG": "UGA", "UY": "URY", "UZ": "UZB", "VU": "VUT", "VA": "VAT", "VE": "VEN", "VN": "VNM", "WF": "WLF", "ZM": "ZMB", "ZW": "ZWE" };