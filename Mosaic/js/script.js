$(document).ready(function() {

	// $(window).resize(function () {
	// 	var window_height = $(window).height();
	// 	$('header').css({'height' : window_height});
	// }).resize();

	var $container = $('.products');
	var window_height = $(window).height();
	var window_width = $(window).width();

	set_layout();

	$('.btn-slide, .slide-bar a.close').on('click', function() {

		var data_target = $(this).attr('data-target')
		var target = $(data_target);
		var slidebar_width = target.width();
		var side_width = $('.sidebar').width();

		if (target.hasClass('in')) {
			target.removeClass('in');

			if (!Modernizr.mq('(max-width: 979px)')) {
				target.css({ 'left': side_width / 1.3 });
				$('.main, .bg-img, .bg-mask').css({ 'left': side_width });
			}
		} else {

			$('.slide-bar').removeClass('in');
			target.addClass('in');

			if (!Modernizr.mq('(max-width: 979px)')) {
				$('.slide-bar').css({ 'left': side_width / 1.3 });
				$('.main, .bg-img, .bg-mask').css({ 'left': side_width });
				$('.main, .bg-img, .bg-mask').css({ 'left': side_width + slidebar_width });
				target.css({ 'left': side_width });
			}
		}

		return false;

	});

	$('header form input[type=search]').on('keyup keypress', function() {
		$('header form').addClass("focused");
	});

	$('.modal-alert').modal('show');

	//Categories
	$('.categories ul a[href="#"]').click(function(e) {
		e.preventDefault();
	});

	$('.btn-navbar').click(function() {
		$('body').toggleClass('mobile-nav');
	});

	check_shipping($('input[name="pagamento"]:checked'));

	$('input[name="pagamento"]').change(function() {
		check_shipping($(this));
	});

	$('form').submit(function() {
		$('body').css({ 'cursor': 'wait' });
		$(this).find('input[type=submit], button[type=submit]').attr('disabled', 'true').fadeTo('fast', 0.25);
	});

	//Event on change
	$(document).on('change', '.select-product-options', function() {
		product_options(product);
	});

	//Products

	$container.children('li').each(function() {
		var spin_el = $(this);
		spin_el.spin({
			color: basecolor,
			width: 3,
			top: (spin_el.height() / 2) - 20
		});
	});

	$container.imagesLoaded().done(function(instance) {
			$container.isotope({
				resizable: false,
				masonry: {
					columnWidth: getUnitWidth()
				},
				onLayout: function() {}
			});
		})
		.progress(function(instance, image) {
			var image_tag = $(image.img);
			image_tag.animate({ 'opacity': 1 }).parents('li').children('.spinner').fadeOut('slow', function() {
				image_tag.parents('li').spin(false);
			});
		});

	jQuery(window).smartresize(function() {
		set_layout();
		$container.isotope({
			masonry: { columnWidth: getUnitWidth() }
		});
	}).resize();

	function getUnitWidth() {
		var width;
		if ($container.width() <= 320) {
			//console.log("320");
			width = Math.floor($container.width() / 1);
		} else if ($container.width() >= 321 && $container.width() <= 480) {
			//console.log("321 - 480");
			width = Math.floor($container.width() / 1);
		} else if ($container.width() >= 481 && $container.width() <= 768) {
			//console.log("481 - 768");
			width = Math.floor($container.width() / 2);
		} else if ($container.width() >= 769 && $container.width() <= 979) {
			//console.log("769 - 979");
			width = Math.floor($container.width() / 3);
		} else if ($container.width() >= 980 && $container.width() <= 1200) {
			//console.log("980 - 1200");
			width = Math.floor($container.width() / 4);
		} else if ($container.width() >= 1201 && $container.width() <= 1600) {
			//console.log("1201 - 1600");
			width = Math.floor($container.width() / 4);
		} else if ($container.width() >= 1601 && $container.width() <= 1824) {
			//console.log("1601 - 1824");
			width = Math.floor($container.width() / 5);
		} else if ($container.width() >= 1825) {
			//console.log("1825");
			width = Math.floor($container.width() / 6);
		}
		return width;
	}

	function set_layout() {
		var unitWidth = getUnitWidth();

		$container.children("li").css({
			width: unitWidth,
			height: unitWidth
		});

		$('.et-wrapper').css({ 'height': unitWidth });

		if (!Modernizr.mq('only all') && window_height < 728) {
			$('body').addClass('safe-height');
		}
	}

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


$(window).load(function() {
	$('.flexslider').flexslider({
		animation: "slide",
		slideshow: false,
		smoothHeight: true,
		prevText: "",
		nextText: "",
		start: function() {
			//Trigger first set of options
			var default_option = 'false';
			if (typeof product !== 'undefined' && product.option_groups.length > 0) {
				var default_option = product_default_option(product);
				$('.select-product-options option[value="' + default_option + '"]').prop('selected', true).trigger('change');
			}
			if (isNaN(default_option)) {
				$('.select-product-options').val(0).change();
			}

			//Force first option to be triggered
			if (typeof product !== 'undefined' && product.option_groups.length > 0) {
				product_options(product, true);
			}

		}
	});

	$('.fb-page, .fb-comments').each(function() {
		$(this).attr('data-width', $(this).parent().width());
	});
});

function product_options(product, onload) {
	if ($('.select-product-options').length) {

		var _this = $('.select-product-options');
		var option = $('option:selected', _this);

		var data_product_options = { id_variant_1: option.data('id_variant_1'), id_variant_2: option.data('id_variant_2'), id_variant_3: option.data('id_variant_3') }
		var product_handle = product.handle;

		$.post('/product-options/' + product_handle, data_product_options, function(response) {

			var price_txt;
			var stock_qty;

			$('.add-cart').fadeTo('fast', 1);

			if (response) {
				if (response.price_on_request === true) {
					$('body').addClass('price-on-request');

					price_txt = 'Preço sob consulta';
					disable_form_product = true;
				} else {

					if (product_is_vendible(product, response)) {
						$('body').removeClass('price-on-request');
						if (response.promo === true) {
							$('.product .price del').text(response.price_formatted);
							price_txt = response.price_promo_formatted;

							if (response.price_promo_percentage) {
								$('.data-promo-percentage').text('Desconto de '+response.price_promo_percentage+'%');
							}
						} else {
							$('.product .price del').text('');
							price_txt = response.price_formatted;
							$('.data-promo-percentage').text('');
						}

						disable_form_product = false;
					} else {
						$('body').addClass('price-on-request');

						price_txt = 'Não disponível';
						disable_form_product = true;
					}

					stock_qty = response.stock_qty;
				}

				if (response.image) {
					var image_index = $('.flexslider li:not(.clone)').find('img[src="' + response.image.full + '"]').parent('li').index();
					$('.flexslider').flexslider(image_index - 1);
				}

				if (response.wishlist) {
					if (response.wishlist.status) {
						wishlist_html = '<i class="fa fa-heart-o fa-fw fa-lg"></i>';
						wishlist_url = response.wishlist.remove_url;
					} else {
						wishlist_html = '<i class="fa fa-heart fa-fw fa-lg"></i>';
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
				$('.product .price del').text('');
				$('.data-promo-percentage').text('');
			}

			$('.data-product-price').text(price_txt);
			$('.data-product-stock_qty').text(stock_qty);
			$('span[itemprop="sku"]').text(reference);

			product_options_url();

		}, 'json');
	}
}

function product_options_url() {
	$('.select-product-options').on('change', function() {
		var pathname = window.location.pathname;
		var origin = window.location.origin;

		var option = $(this).prop('value');

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
	var option_id = 'false';
	var query = window.location.search.substring(1);

	if (query) {
		var option_id = query.split('option=')[1];
		option_id = option_id.split('&')[0];
	}

	return option_id;
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