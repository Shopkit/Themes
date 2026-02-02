$(document).ready(function() {

	var lazyLoadInstance = new LazyLoad();

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

	$(document).on('init_app_shipping_info', function(){
		if (Modernizr.mq('only screen and (max-width: 991px)')) {
			$('body.page-cart .order-resume').insertAfter('.table-cart-products');
		}
	});

	$(window).resize(function() {

		if (Modernizr.mq('only screen and (max-width: 991px)')) {
			if (typeof $('body.page-cart form .table-cart-products').next('.order-resume')[0] === 'undefined') {
				$('body.page-cart .order-resume').insertAfter('.table-cart-products');
			}
		} else {
			$('body.page-cart .order-resume').prependTo($('.order-resume-container'));
		}

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
		utilsScript: 'https://cdn-shopkit.com/js/intl-tel-input-17.0.8/build/js/utils.js'
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
					if ($('body').hasClass('feather')) {
                        feather.replace();
                    }
                    lazyLoadInstance.update();
                }
            });
        });
    }

	$('.input-qtd, #cupao').keypress(function (e) {
		if (e.which == 13) {
			e.preventDefault();
			if ($(this).hasClass('input-qtd')) {
				$('button[formaction*="cart/post/update"]').trigger('click');
			} else {
				$(this).parents('.coupon-code-input').find('button[type="submit"]').trigger('click');
			}
			return false;
		}
	});

	$(document).on('change', '.extra-options [data-target]', function(event) {
        var _this = $(this);
        var target = _this.data('target');
        var is_checked = _this.is(':checked');
        var is_required = _this.is(':required');
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

	var media_query = window.matchMedia('(max-width: 767px)');
	media_query.addEventListener('change', function(e) {
		handle_breakpoint_change(e, theme_options);
	});
	handle_breakpoint_change(media_query, theme_options);
	document.documentElement.style.setProperty('--header-height', ($('header').outerHeight()));

	var limit_birthday_date = new Date().toISOString().split('T')[0];
    $('.page-account-profile #birthday').attr('max', limit_birthday_date);

    // Video hover effect for product listings
    $(document).on({
        mouseenter: function() {
            var $this = $(this);
            var $video = $this.find('.product-hover-video');
            var $thumb = $this.find('.product-thumb');

            $thumb.css('visibility', 'hidden');
            $video.css('visibility', 'visible')[0].play();
        },
        mouseleave: function() {
            var $this = $(this);
            var $video = $this.find('.product-hover-video');
            var $thumb = $this.find('.product-thumb');
            var video = $video[0];

            video.pause();
            video.currentTime = 0;
            $video.css('visibility', 'hidden');
            $thumb.css('visibility', 'visible');
        }
    }, '.product.has-video');
});

$(window).load(function() {

	$('.slideshow-product').flexslider({
		slideshow: false,
		slideshowSpeed: parseInt(theme_options.slideshow_slide_speed * 1000),
		animationSpeed: 500,
		controlNav: true,
		directionNav: true,
		selector: ".slides > .slide",
		prevText: helper_icon_render('angle-left'),
		nextText: helper_icon_render('angle-right'),
		smoothHeight: true,
		start: function(slider) {
			$('.slideshow').addClass('loaded');
			$('.slideshow .flex-direction-nav li a.flex-disabled').parent('li').addClass('disabled');
			$('.slideshow .btn-zoom').addClass('hidden');

			// Play video in first slide if it exists
			var $firstSlide = $(slider.slides[0]);
			var $video = $firstSlide.find('.slide-video-element');
			if ($video.length) {
				$('.slideshow .btn-zoom').removeClass('hidden');
				$video[0].play();
			}

			var image_height = $('.flex-active-slide img, .flex-active-slide video').height();
			$('.slideshow-product').css('min-height',image_height);

			//Force first option to be triggered
			if (typeof product !== 'undefined' && product.option_groups.length > 0) {
				product_options(product, true);
			}
		},
		before: function(slider){
			// Pause all videos
			$('.slide-video-element').each(function() {
				this.pause();
			});
		},
		after: function(slider){
			// Play video in current slide if it exists
			$('.slideshow .btn-zoom').addClass('hidden');
			var $currentSlide = $(slider.slides[slider.currentSlide]);
			var $video = $currentSlide.find('.slide-video-element');
			if ($video.length) {
				$('.slideshow .btn-zoom').removeClass('hidden');
				$video[0].play();
			}

			var image_height = $('.flex-active-slide img, .flex-active-slide video').height();
			$('.slideshow-product').css('min-height',image_height);
			if (typeof product !== 'undefined' && product.option_groups.length > 0 && theme_options.trigger_thumbnail_option == 'show') {
				if(slider.direction != undefined){
					update_product_select($('.slideshow-product .flex-active-slide a').attr('data-image'), 'slideshow');
				}
			}
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

			$('.add-cart').fadeTo('fast', 1);

			if (response && response.active) {
				if (response.price_on_request === true) {
					$('body').addClass('price-on-request');

					price_txt = lang.storefront.macros.product.price_on_request;
					disable_form_product = true;
				} else {
					$('body').removeClass('price-on-request');

					if (product_is_vendible(product, response)) {

						$('.product-detail .data-price-non-wholesale').text(response.price_non_wholesale_formatted);

						if (response.promo === true) {
							$('.promo-price').text(response.price_formatted);
							price_txt = response.price_promo_formatted;

							if (response.price_promo_percentage) {
								$('.promo-percentage').removeClass('hidden');
								$('.data-promo-percentage').text(response.price_promo_percentage);
							} else {
								$('.promo-percentage').addClass('hidden');
							}
						} else {
							$('.promo-price').text('');
							price_txt = response.price_formatted;
							$('.promo-percentage').addClass('hidden')
							$('.data-promo-percentage').text('');
						}

						if (response.rewards) {
							$('#message-points').text(response.rewards);
							$('#message-points').parents('.callout').removeClass('hidden');
						} else {
							$('#message-points').parents('.callout').addClass('hidden');
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
					var image_index = $('.slideshow-product .flexslider .slides li a').find('img[src="' + response.image.full + '"]').parents('li').index();
					$('.slideshow-product').flexslider(image_index);
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

				if (response.image && response.image.full.indexOf('no-img') <= 0) {
					var image_index = $('.slideshow-product .flexslider .slides li a').find('img[src="' + response.image.full + '"]').parents('li').index();
					$('.slideshow-product').flexslider(image_index);
				}
			}

			$(document).trigger('trigger_product_options', response);

			if (disable_form_product === true) {
				$('.promo-price').text('');
				$('.data-promo-percentage').text('');
				$('.extra-options').addClass('hidden').find('input, select, textarea').prop('disabled', true);
			}

			animate_updated_value('.data-product-price', price_txt, 'flash');
			animate_updated_value('.data-product-stock_qty', stock_qty, 'flash');
			animate_updated_value('span.sku', reference, 'flash');
			animate_updated_value('span.ean', barcode, 'flash');

			$('.add-cart input[name="qtd"], .add-cart button[type="submit"]').prop('disabled', disable_form_product);
			$('.add-cart').addClass('form-enabled');
			$('.extra-options').removeClass('hidden').find('input, select, textarea').prop('disabled', false);

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

function handle_breakpoint_change(e, theme_options) {
    var gallery_type = e.matches ? 'mobile' : 'desktop';

    destroy_slideshow();

    if (gallery_type === 'mobile') {
        load_slideshow('mobile', (theme_options.gallery_type === 'products' ? theme_options.gallery : theme_options.mobile_gallery), theme_options);
        if (theme_options.slideshow_mobile_full_height == 'slideshow-mobile-full-height') {
        	$('.slideshow:not(.slideshow-product)').addClass('margin-bottom').insertAfter('header');
        }
    } else {
        load_slideshow('desktop', theme_options.gallery, theme_options);
        if (theme_options.slideshow_full_height == 'slideshow-full-height') {
        	$('.slideshow:not(.slideshow-product)').addClass('margin-bottom').insertAfter('header');
        }
    }
}

function load_slideshow(type, gallery, theme_options) {
    if (type == 'mobile') {
        $('.slideshow:not(.slideshow-product)').addClass('slideshow-mobile');
    } else {
        $('.slideshow:not(.slideshow-product)').addClass('slideshow-home');
    }

    if (gallery && gallery.length) {
        for (var i = 0; i < gallery.length; i++) {
            var has_slide_content = (gallery[i].title || gallery[i].button || gallery[i].description) ? 'has-slide-content' : '';
            var slideshow_content = has_slide_content ? ('<div class="slide-content">' + (gallery[i].title ? (gallery[i].link ? '<h4 class="slide-title"><a href="'+gallery[i].link+'">'+gallery[i].title+'</a></h4>' : '<h4 class="slide-title">'+gallery[i].title+'</h4>') : '') + (gallery[i].description ? '<div class="slide-description">'+gallery[i].description+'</div>' : '') + (gallery[i].button ? '<div class="slide-button"><a href="'+gallery[i].button_link+'" '+(gallery[i].target_blank == '1' ? 'target="_blank"' : '' )+ 'class="btn btn-primary">'+gallery[i].button+'</a></div>' : '') + '</div>') : '';
            // Check if this slide is a video
            var slideshow_slide;
            if (gallery[i].is_video === true || gallery[i].is_video === 'true' || gallery[i].is_video === '1' || gallery[i].is_video === 1 || (gallery[i].video_url && gallery[i].video_url !== '' && gallery[i].video_url !== 'undefined')) {
                // Create video slide with video element instead of background image
                var video_url = gallery[i].video_url || gallery[i].url;
                // Get poster URL - handle both URL strings and IDs
                var poster_url;
                if (gallery[i].poster_url) {
                    // Use poster_url if available (full URL)
                    poster_url = gallery[i].poster_url;
                } else if (gallery[i].poster && !isNaN(gallery[i].poster)) {
                    // If poster is numeric (ID), skip it and use fallbacks
                    poster_url = gallery[i].thumbnail || gallery[i].image.full;
                } else {
                    // Use poster if it's a string URL, or fallback to thumbnail/image
                    poster_url = gallery[i].poster || gallery[i].thumbnail || gallery[i].image.full;
                }
                slideshow_slide = '<li class="slide slide-video '+has_slide_content+'">' +
                    '<video class="slide-video-element" ' + (i == 0 ? 'autoplay ' : '') + 'muted playsinline '+(gallery.length == 1 ? 'loop' : '')+' poster="'+poster_url+'" data-size="'+theme_options.slideshow_background_size+'" aria-label="'+(gallery[i].image.alt ? gallery[i].image.alt : gallery[i].title)+'">' +
                    '<source src="'+video_url+'" type="video/mp4">' +
                    (gallery[i].image.alt ? gallery[i].image.alt : gallery[i].title) +
                    '</video>' +
                    slideshow_content +
                    '</li>';
            } else {
				slideshow_slide = '<li class="slide '+has_slide_content+'" style="background-image:url('+gallery[i].image.full+')">' + slideshow_content + '</li>';
			}

            $('.slideshow:not(.slideshow-product) .slides').append(slideshow_slide);
        }

		$('.slideshow-home, .slideshow-mobile').flexslider({
			slideshowSpeed: parseInt(theme_options.slideshow_slide_speed * 1000),
			animationSpeed: 1500,
			controlNav: true,
			directionNav: false,
			selector: ".slides > .slide",
			start: function(slider) {
				$('.slideshow').addClass('loaded');

				var main_slideshow = $(slider[0]);
				var has_navigation = $(main_slideshow).find('.flex-control-nav');
				has_navigation.length ? main_slideshow.addClass('has-navigation') : main_slideshow.removeClass('has-navigation');

				// Play video in first slide if it exists
				play_slideshow_video(slider);
			},
			before: function(slider){
				// Pause all videos
				$('.slide-video-element').each(function() {
					this.pause();
				});
			},
			after: function(slider){
				// Play video in current slide if it exists
				play_slideshow_video(slider);
			}
		});

		function play_slideshow_video(slider) {
            var $currentSlide = $(slider.slides[slider.currentSlide]);
            var $video = $currentSlide.find('.slide-video-element');

            if (!$video.length) {
                return;
            }

            var vid = $video[0];
            slider.pause();
            vid.play();

            $video.off('ended.flexVideo').one('ended.flexVideo', function() {
                slider.flexAnimate(slider.getTarget("next"), true);
                slider.play();
            });
        }

		$('.slideshow:not(.slideshow-product)').removeClass('hidden');
    }
}

function destroy_slideshow() {
    var slideshow = $('.slideshow:not(.slideshow-product)');
    if (slideshow.data('flexslider')) {
        // Pause and remove all videos before destroying
        $('.slide-video-element').each(function() {
            this.pause();
            this.src = '';
        });
        slideshow.removeData('flexslider');
        slideshow.off('.flexslider');
        slideshow.html('<div class="flexslider"><ul class="slides"></ul></div>');
    }
    slideshow.removeClass('slideshow-mobile slideshow-home loaded').addClass('hidden');
}

(function($) {
	$.fn.hasScrollBar = function() {
		return this.get(0).scrollWidth > this.get(0).clientWidth;
	};
})(jQuery);
