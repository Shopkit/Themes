$(document).ready(function() {

	var lazyLoadInstance = new LazyLoad({
		callback_loaded: function(){
			masonry();
		}
	});

	var options = {
        format: "YYYY-MM-DD",
        locale: "pt",
        useCurrent: false,
        icons: {
            time: "fa fa-clock-o",
            date: "fa fa-calendar",
            up: "fa fa-arrow-up",
            down: "fa fa-arrow-down",
            previous: 'fa fa-chevron-left',
            next: 'fa fa-chevron-right',
        },
    };

    $('input[data-datepicker]').datetimepicker(options);

	if (Modernizr.mq('only screen and (min-width: 767px)')) {
		$('.products img, .categories img, .brands img').imagesLoaded(function() {

			masonry();

			$(window).resize(function() {
				masonry();
			});
		});
	}

	$('.modal-alert').modal('show');

	$('a.fancy').fancybox({
		'overlayColor': '#fff',
		'type': 'image',
		onStart: function() {
			$('.fancybox-bg').remove();
			$('#fancybox-close').html(helper_icon_render('times'));
			$('#fancybox-loading').html(helper_icon_render('sync', 'fa-2x'));
			$('#fancybox-left > span').html(helper_icon_render('angle-left'));
			$('#fancybox-right > span').html(helper_icon_render('angle-right'));
		}
	});

	function priority_nav() {
		var navigation = priorityNav.init({
			mainNavWrapper: ".trigger-priority-nav",
			mainNav: "ul.nav",
			navDropdownLabel: helper_icon_render('bars', 'fa-lg'),
			navDropdownClassName: "dropdown-menu",
			turnOffPoint: 979,
			offsetPixels: 20
		});
	}

	priority_nav();

	if (Modernizr.mq('only screen and (min-width: 980px)')) {
		var resize_element = $('.priority-nav');
		new ResizeObserver(function(){
			var el_height = resize_element.height();

			if (el_height > 42){
				var duplicate_nav = resize_element.clone();
				resize_element.remove();
				$('.navbar .navbar-inner > .container, .navbar .navbar-inner > .container-fluid').append(duplicate_nav);
				setTimeout(function(){
					$('.dropdown-menu-wrapper').remove();
					priority_nav();
				}, 1500);
			}
		}).observe(resize_element[0]);
	}

	var headerHeight = $('header .navbar').offset().top;
	$(window).on('scroll', function () {
		if ($(window).scrollTop() > headerHeight) {
			$('.navbar.fixed-header').addClass('fixed');
			$('.fixed-header #nav-spacer').removeClass('hidden');
		} else {
			$('.fixed-header #nav-spacer').addClass('hidden');
			$('.navbar.fixed-header').removeClass('fixed');
		}
	});

	$('.video-iframe').each(function(index) {
		src = $(this).attr('data-src');
		$(this).replaceWith('<iframe  src="' + src + '" frameborder="0" allowfullscreen></iframe>');
	});

	$('.col-left nav ul li h4 a[href="#"], .col-left nav ul li h5 a[href="#"]').click(function(e) {
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

	$('.col-left > nav > ul').find('.sub-subcategories.in').closest('.sub-categories').addClass('in');

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
	});

	//Billing / Delivery data
	$(document).on('change', '#billing_info_same_delivery', function(event) {
		var _this = $(this);
		var target = _this.data('target');
		$(target).toggleClass('hidden');
	});

	$(document).on('blur', 'input[name$=zip_code]', function(e) {
		set_country_by_postal_code($(this));
	});

	$('.payment-methods .list-radio-block.list-group-item-active').find('select#pick_up_location').prop('required', true);

	$('.shipping-methods .list-radio-block').on('click', function(e) {
		var _this = $(this);
		$('.shipping-methods .list-radio-block').removeClass('list-group-item-active').find('input').prop('checked', false);
		$('select', _this).length ? $('select', _this).prop('disabled', false) : $('.shipping-methods .list-radio-block:not(.list-group-item-active)').find('select').prop('disabled', true);
		_this.addClass('list-group-item-active').find('input').prop('checked', true).trigger('change');
	});

	$('.payment-methods .list-radio-block').on('click', function(e) {
		var _this = $(this);
		$('.payment-methods .list-radio-block').removeClass('list-group-item-active').find('input').prop('checked', false);
		_this.addClass('list-group-item-active').find('input').prop('checked', true).trigger('change');
		$('#pick_up_location', _this).length ? $('#pick_up_location', _this).prop('required', true) : $('.payment-methods').find('#pick_up_location').prop('required', false);
	});

	$('.intl-validate').intlTelInput({
		initialCountry: 'pt',
		preferredCountries: ['pt','es','fr','ch','br','gb','de','lu','be','it','us'],
		utilsScript: 'https://cdn.shopk.it/js/intl-tel-input-17.0.8/build/js/utils.js'
	});

	$(document).on('keyup blur focus', '.intl-validate', function(event) {
		var _this = $(this);
		var e164 = event.type == 'focusout' ? true : false;
		validate_phone_intl_input(_this, e164);
	});

	$(document).on('change', '#delivery_country, #billing_country', function(event) {
		var _this = $(this);
		var type = _this.attr('id').split('_')[0];
		var phone_input = $('#'+ type +'_phone');
		var country = _this.find('option:selected').attr('value');

		if (country == 'PTA' || country == 'PTM') {
			country = 'PRT';
		}

		if (!phone_input.val()) {
			phone_input.intlTelInput('setCountry', getKeyByValue(countries_alpha_2, country));
		}
	});

	$('.product-description table, .product-tabs-content table, .product-tabs table').addClass('table').addClass('table-bordered').addClass('table-product-content');
	$('.product-description table, .product-tabs-content table, .product-tabs table').wrap('<div class="table-responsive"></div>');

	$('.page-product .tabbable').find('.nav-tabs li:first a').trigger('click');

	$(window).resize(function() {

		if ($('.table-responsive').length) {
			$('.table-responsive').each(function() {
				var _this = $(this);
				if (_this.hasScrollBar()) {
					_this.addClass('has-mask');
				} else {
					_this.removeClass('has-mask');
				}
			});
		}

	}).resize();

	$('.table-responsive.has-mask').scroll(function() {
		var _this = $(this);
		var scroll_position = _this.scrollLeft();
		if (scroll_position > 0) {
			_this.addClass('mask-hidden');
		} else {
			_this.removeClass('mask-hidden');
		}
	});

	if ($('[data-load="related-products"]').length) {
		$('[data-load="related-products"]').each(function() {
			var _this = $(this);

			var products = _this.attr('data-products');
			var num_products = _this.attr('data-num-products');
			var products_per_row = _this.attr('data-products-per-row');
			var css_class_wrapper = _this.attr('data-css-class-wrapper');
			var type = _this.attr('data-type');

			$.ajax({
				method: 'GET',
				cache: true,
				url: '/related-products?products=' + products + '&num_products=' + num_products + '&products_per_row=' + products_per_row + '&css_class_wrapper=' + css_class_wrapper + '&type=' + type,
				dataType: 'html'
			}).done(function(data) {
				if (data) {
					_this.find('.related-products-placement').html(data);
					_this.removeClass('hidden');
					lazyLoadInstance.update();
				}
			});
		});
	}

	$('#cupao').keypress(function (e) {
		if (e.which == 13) {
			e.preventDefault();
			$(this).parents('.coupon-code-input').find('button[type="submit"]').trigger('click');
			return false;
		}
	});

	$(document).on('change', '.extra-options [data-target]', function(event) {
        var _this = $(this);
        var target = _this.data('target');
        var is_checked = _this.is(':checked');
        var is_required = _this.prop('required');
        var toggle_color_option_label = !(is_checked && $('[name="' + target + '"]').find('input:checked').length);
        $('[name="' + target + '"]').toggleClass('hidden', !is_checked).prop('disabled', !is_checked).prop('required', is_required);

        if ($('[name="' + target + '"]').hasClass('list-colors')) {
            $('.extra-option-option-label', _this.parents('.extra-option')).toggleClass('hidden', toggle_color_option_label);
        }
    });

	$('.testimonial-carousel').slick({
        infinite: true,
        slidesToShow: 3,
        slidesToScroll: 1,
        arrows: false,
		dots: true,
        responsive: [{
                breakpoint: 991,
                settings: {
                    slidesToShow: 2
                }
            },
            {
                breakpoint: 767,
                settings: {
                    slidesToShow: 1
                }
            }
        ]
    });
});

$(window).load(function() {
	$('.fb-page').each(function() {
		$(this).attr('data-width', $(this).parent().width());
	});

	//Trigger first set of options
	if (typeof product !== 'undefined' && product.option_groups.length > 0) {
		if (product.option_groups.length > 1) {
			$('.data-product-price, .price del').text('');
		}
		product_options(product, true);
	}

	$('.intl-validate').each(function(index) {
		var _this = $(this);
		var address_type = _this.attr('id').split('_')[0];
		setTimeout(function() {
			if (!_this.val() && user[address_type].country_code_alpha_2) {
				_this.intlTelInput('setCountry', user[address_type].country_code_alpha_2);
			}
			validate_phone_intl_input(_this, true);
			_this.blur();
		}, 1500);
	});

	$('.slideshow-home').flexslider({
		slideshowSpeed: parseInt(theme_options.slideshow_slide_speed * 1000),
		animationSpeed: 1500,
		controlNav: true,
		directionNav: false,
		selector: ".slides > .slide",
		start: function() {
			$('.slideshow').addClass('loaded');
		}
	});
});

function masonry() {
	if (Modernizr.mq('only screen and (max-width: 767px)')) {
		$('.products, .categories, brands').masonry('destroy').removeAttr('style');
	} else {
		$('.products, .categories, brands').masonry({ isAnimated: true });
	}
}

function enable_shipping() {
	$('.shipping-methods').fadeTo('fast', 1).removeClass('disabled').find('input').prop('disabled', false);
}

function disable_shipping() {
	$('.shipping-methods').fadeTo('fast', 0.25).addClass('disabled').find('input').prop('disabled', 'disabled');
}

function check_shipping(el) {
	if (el.prop('value') == 'pick_up') {
		disable_shipping();
	} else {
		enable_shipping();
	}
}

function product_options(product, onload) {
	onload = typeof onload !== 'undefined' ? onload : false;

	if ($('.select-product-options').length) {
		$('.form-cart').fadeTo('fast', 0.25).removeClass('form-enabled');

		var default_option = product_default_option(product);

		$('.select-product-options').each(function(i) {
			if (onload == true) {
				$('option[value="' + default_option[i] + '"]', this).prop('selected', true);
			}
			var option = $('option:selected', this);
			window['id_variant_' + (i + 1)] = option.attr('value');
		});

		if ($('.select-product-options').length == 1 && onload == true) {
			$.each(product.options, function(key, option){
				var $option = $('.select-product-options option[value="'+ option.id_variant_1 +'"]'),
					$option_text = $option.text();
				if (option.price_on_request) {
					$option_text += (' - ' + lang.storefront.macros.product.price_on_request);
				} else {
					if (option.price !== null) {
						var option_display_price = option.promo ? option.price_promo_formatted : option.price_formatted;
						$option_text += ' - ' + option_display_price;
					}
				}
				$option.text($option_text);
			});
		}

		var data_product_options = { all: true, id_variant_1: window.id_variant_1, id_variant_2: window.id_variant_2, id_variant_3: window.id_variant_3 };
		var product_handle = product.handle;
		var disable_form_product;

		$.post('/product-options/' + product_handle, data_product_options, function(response) {

			var price_txt;
			var stock_qty;

			$('.form-cart').fadeTo('fast', 1);

			if (response && response.active) {
				if (response.price_on_request === true) {
					$('body').addClass('price-on-request');

					price_txt = lang.storefront.macros.product.price_on_request;
					disable_form_product = true;
				} else {
					$('body').removeClass('price-on-request');

					if (product_is_vendible(product, response)) {

						$('.data-price-non-wholesale').text(response.price_non_wholesale_formatted);

						if (response.promo === true) {
							$('.price del').text(response.price_formatted);
							price_txt = response.price_promo_formatted;
							if (response.price_promo_percentage) {
								$('.promo-percentage').removeClass('hidden');
								$('.data-promo-percentage').text(response.price_promo_percentage);
                            } else {
								$('.promo-percentage').addClass('hidden');
							}
						} else {
							$('.price del').text('');
							price_txt = response.price_formatted;
							$('.promo-percentage').addClass('hidden')
							$('.data-promo-percentage').text('');
						}

						$('.extra-options').removeClass('hidden').find('input, select, textarea').prop('disabled', false);

						disable_form_product = false;
					} else {
						price_txt = lang.storefront.script.product.not_available;
						disable_form_product = true;
					}

					stock_qty = response.stock_qty;
				}

				if (response.image && response.image.full.indexOf('no-img') <= 0) {
					$('img.product-image').prop('src', response.image.full);
					$('img.product-image').parent('a').prop('href', response.image.full);
				}

				if (response.wishlist) {
					if (response.wishlist.status) {
						wishlist_html = helper_icon_render('heart') + ' ' + lang.storefront.product.wishlist.remove;
						wishlist_url = response.wishlist.remove_url;
						$('.wishlist').addClass('added');
					} else {
						wishlist_html = helper_icon_render('heart') + ' ' + lang.storefront.product.wishlist.add;
						wishlist_url = response.wishlist.add_url;
						$('.wishlist').removeClass('added');
					}
					$('.wishlist a').html(wishlist_html).attr('href', wishlist_url);

					if ($('body').hasClass('feather')) {
                        feather.replace();
                    }
				}

				reference = response.reference;
				barcode = response.barcode;
			} else {
				$('body').removeClass('price-on-request');
				price_txt = lang.storefront.script.product.not_available;
				stock_qty = 0;
				disable_form_product = true;
				reference = '';
				barcode = '';

				if (response && response.image && response.image.full.indexOf('no-img') <= 0) {
					$('img.product-image').prop('src', response.image.full);
					$('img.product-image').parent('a').prop('href', response.image.full);
				}
			}

			$(document).trigger('trigger_product_options', response);

			if (disable_form_product === true) {
				$('.price del').text('');
				$('.data-promo-percentage').text('');
				$('.extra-options').addClass('hidden').find('input, select, textarea').prop('disabled', true);
			}

			$('.data-product-price').text(price_txt);
			$('.data-product-stock_qty').text(stock_qty);
			$('span.sku').text(reference);
			$('span.ean').text(barcode);

			$('.form-cart input[name="qtd"], .form-cart button[type="submit"]').prop('disabled', disable_form_product);
			$('.form-cart').addClass('form-enabled');

			product_options_url();

		}, 'json');
	} else {
		$('.form-cart').addClass('form-enabled');
		$('.extra-options').removeClass('hidden').find('input, select, textarea').prop('disabled', false);
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
			var url = UpdateQueryString('option', option);

			if (url) {
				if (window.history.replaceState) {
					window.history.replaceState(null, null, url);
				}
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
	//get query string value
	var option_id = qs["option"];

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

(function($) {
	$.fn.hasScrollBar = function() {
		return this.get(0).scrollWidth > this.get(0).clientWidth;
	};
})(jQuery);
