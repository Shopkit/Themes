$(document).ready(function() {

	var lazyLoadInstance = new LazyLoad();

	$('.navbar-nav .dropdown-menu li.active').parents('li.dropdown').addClass('active');

	$('.subdropdown > a[href="#"]').on('click', function(e) {
		e.preventDefault();
		e.stopPropagation();
		var target = e.currentTarget.parentNode;
		if ($(target).hasClass('open')) {
			$(target).removeClass('open');
		} else {
			$('ul.navbar-nav > .dropdown:hover > .dropdown-menu').find('.subdropdown.open').removeClass('open');
			$(target).addClass('open');
		}
	});

	//Run only on non-touch devices
	if (!Modernizr.touch) {
		$('[data-animation]').waypoint({
			triggerOnce: true,
			offset: '85%',
			handler: function() {

				var ele = $(this);
				var fx = ele.data('animation');
				var delay = ele.data('delay');

				setTimeout(function() {
					ele.addClass('animated ' + fx);
				}, delay * 1000);
			}
		});
		$('.navbar-nav .dropdown-toggle').removeAttr('data-toggle');
	}

	$('.store-notice .navbar-form .btn-search').on('click', function() {
		if ($('.store-notice .navbar-form .search-form').hasClass('hidden')) {
			$('.store-notice .navbar-form .search-form').removeClass('hidden');
			$('.store-notice .navbar-form .search-form input').focus();
			$('.store-notice .user-auth, .store-notice .languages-dropdown').addClass('opacity-0');
			return false;
		} else {
			if (!$('.store-notice .navbar-form .search-form input').val()) {
				$('.store-notice .navbar-form .search-form').addClass('hidden');
				$('.store-notice .user-auth, .store-notice .languages-dropdown').removeClass('opacity-0');
			}
		}

		if (!$('.store-notice .navbar-form .search-form').hasClass('hidden') && $('.store-notice .navbar-form .search-form input').val()) {
			$('.store-notice .navbar-form').submit();
		}
	});

	$(window).resize(function() {

		if ($('.navbar-nav').height() > 40) {
			$('.navbar-nav').addClass('is-big-nav');
			$('.navbar-nav').removeClass('is-small-nav');
		} else {
			$('.navbar-nav').removeClass('is-big-nav');
			$('.navbar-nav').addClass('is-small-nav');
		}

		if (!Modernizr.mq('(min-width: 1024px)')) {
			$('.facebook-comments:not(.have-moved)').detach().appendTo('.description').addClass('have-moved');
		}

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

	if (!Modernizr.input.placeholder) {
		$('input, textarea').placeholder();
	}

	$('[data-toggle=tooltip]').tooltip();
	//$('[data-toggle=modal]').modal();

	$('[data-toggle="toggle"]').on('click', function(event) {
		var _this = $(this);
		var target = _this.data('target');
		$(target).toggleClass('show hidden');
	});

	//Lightwindow

	$('.slideshow-product .slide a').on('click', function() {

		if (Modernizr.mq('(min-width: 1024px)')) {
			var _this = $(this);
			var img = _this.attr('href');

			$('.big-image-holder').addClass('shown');
			$('.big-image-holder img').prop('src', img).addClass('shown');
		}

		return false;
	});

	$('.big-image-holder .btn-close, .big-image-holder img').on('click', function() {

		$('.big-image-holder img').removeClass('shown').prop('src', '');
		$('.big-image-holder').removeClass('shown');

		return false;
	});

	$('.shipping-methods .list-radio-block').on('click', function() {
		var _this = $(this);
		$('.shipping-methods .list-radio-block').removeClass('list-group-item-active').find('input').prop('checked', false);
		$('select', _this).length ? $('select', _this).prop('disabled', false) : $('.shipping-methods .list-radio-block:not(.list-group-item-active)').find('select').prop('disabled', true);
		_this.addClass('list-group-item-active').find('input').prop('checked', true).trigger('change');
	});

	$('.payment-methods .list-radio-block').on('click', function() {
		var _this = $(this);
		$('.payment-methods .list-radio-block').removeClass('list-group-item-active').find('input').prop('checked', false);
		_this.addClass('list-group-item-active').find('input').prop('checked', true).trigger('change');
		$('#pick_up_location', _this).length ? $('#pick_up_location', _this).prop('required', true) : $('.payment-methods').find('#pick_up_location').prop('required', false);
	});

	//Cart / Shopkit functions

	check_shipping($('input[name="pagamento"]:checked'));

	$(document).on('change', 'input[name="pagamento"]', function() {
		check_shipping($(this));
	});

	$('form').submit(function() {
		$('body').css({ 'cursor': 'wait' });
		$(this).find('input[type=submit], button').prop('disabled', true);
	});

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

	$(document).on('click', 'a.dropdown-toggle', function(e){
		e.preventDefault();
	});

	// Align dropdown-menus
	(function () {
		var menus = $('ul.navbar-nav > li.dropdown');
		menus.each(function(index, el) {
			var _this = $(this);
			var dropdown = $('.dropdown-menu', this);
			var h_offset = _this.offset().left;
			var align_right = ($(document).width()-h_offset)<h_offset;
			align_right ? dropdown.addClass('dropdown-menu-right') : false;
		});
	})();

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

	$('.panel-collapse.in').siblings('.panel-heading').addClass('active');

	$('.panel-collapse').on('show.bs.collapse', function () {
		$(this).siblings('.panel-heading').addClass('active');
	});

	$('.panel-collapse').on('hide.bs.collapse', function () {
		$(this).siblings('.panel-heading').removeClass('active');
	});

   //Related products
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
});

$(window).load(function() {

	$('.slideshow-home').flexslider({
		slideshowSpeed: 7000,
		animationSpeed: 1500,
		controlNav: true,
		directionNav: false,
		selector: ".slides > .slide",
		start: function() {
			$('.slideshow').addClass('loaded');
		}
	});

	$('.slideshow-product').flexslider({
		slideshow: false,
		slideshowSpeed: 7000,
		animationSpeed: 500,
		controlNav: true,
		directionNav: true,
		selector: ".slides > .slide",
		prevText: "<i class='fa fa-angle-left'></i>",
		nextText: "<i class='fa fa-angle-right'></i>",
		smoothHeight: true,
		start: function() {
			$('.slideshow').addClass('loaded');
			$('.slideshow .flex-direction-nav li a.flex-disabled').parent('li').addClass('disabled');

			var image_height = $('.flex-active-slide img').height();
			$('.slideshow-product').css('min-height',image_height);

			//Force first option to be triggered
			if (typeof product !== 'undefined' && product.option_groups.length > 0) {
				product_options(product, true);
			}
		},
		after: function(){
			var image_height = $('.flex-active-slide img').height();
			$('.slideshow-product').css('min-height',image_height);
		}
	});

	$('.fb-page, .fb-comments').each(function() {
		$(this).attr('data-width', $(this).parent().width());
	});

	$('.intl-validate').each(function(index) {
		var _this = $(this);
		var address_type = _this.attr('id').split('_')[0];
		setTimeout(function() {
			if (!_this.val() && user[address_type].country_code_alpha_2) {
				_this.intlTelInput('setCountry', user[address_type].country_code_alpha_2);
			}
			validate_phone_intl_input(_this, true);
			_this.focus();
			_this.blur();
		}, 1500);
	});

});

function enable_shipping() {
	$('.shipping-methods').removeClass('disabled').find('input').prop('disabled', false);
}

function disable_shipping() {
	$('.shipping-methods').addClass('disabled').find('input').prop('disabled', true);
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
		$('.add-cart').fadeTo('fast', 0.25).removeClass('form-enabled');

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
					$option_text += ' - Preço sob consulta';
				} else {
					if (option.price !== null) {
						var option_display_price = option.promo ? option.price_promo_formatted : option.price_formatted;
						$option_text += ' - ' + option_display_price;
					}
				}
				$option.text($option_text);
			});
		}

		var data_product_options = { id_variant_1: window.id_variant_1, id_variant_2: window.id_variant_2, id_variant_3: window.id_variant_3 };
		var product_handle = product.handle;
		var disable_form_product;

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
					$('body').removeClass('price-on-request');

					if (product_is_vendible(product, response)) {

						$('.product-detail .data-price-non-wholesale').text(response.price_non_wholesale_formatted);

						if (response.promo === true) {
							$('.promo-price').text(response.price_formatted);
							price_txt = response.price_promo_formatted;

							if (response.price_promo_percentage) {
								$('.data-promo-percentage').text('Desconto de ' + response.price_promo_percentage + '%');
							}
						} else {
							$('.promo-price').text('');
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
					var image_index = $('.slideshow-product .flexslider .slides li a').find('img[src="' + response.image.full + '"]').parents('li').index();
					$('.slideshow-product').flexslider(image_index);
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
				$('body').removeClass('price-on-request');
				price_txt = 'Não disponível';
				stock_qty = 0;
				disable_form_product = true;
				reference = '';
			}

			if (disable_form_product === true) {
				$('.promo-price').text('');
				$('.data-promo-percentage').text('');
			}

			animate_updated_value('.data-product-price', price_txt, 'flash');
			animate_updated_value('.data-product-stock_qty', stock_qty, 'flash');
			animate_updated_value('span.sku', reference, 'flash');

			$('.add-cart input[name="qtd"], .add-cart button[type="submit"]').prop('disabled', disable_form_product);
			$('.add-cart').addClass('form-enabled');

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

function animate_updated_value(selector, value, fx) {
	$(selector).text(value);
	$(selector).removeClass(fx + ' animated').addClass('flash animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
		$(this).removeClass(fx + ' animated');
	});
}

(function($) {
	$.fn.hasScrollBar = function() {
		return this.get(0).scrollWidth > this.get(0).clientWidth;
	};
})(jQuery);
