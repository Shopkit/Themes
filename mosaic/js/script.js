$(document).ready(function() {

	// $(window).resize(function () {
	// 	var window_height = $(window).height();
	// 	$('header').css({'height' : window_height});
	// }).resize();

	var $container = $('.products, .categories-list, .brands-list');
	var window_height = $(window).height();
	var window_width = $(window).width();

	set_layout();

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

	$('[data-toggle=tooltip]').tooltip();

	$('.btn-slide, .slide-bar a.close').on('click', function() {

		var data_target = $(this).attr('data-target');
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

	$('.categories').find('.sub-subcategories.in').closest('.sub-categories').addClass('in');

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

	var media_query = window.matchMedia('(max-width: 767px)');
	media_query.addEventListener('change', function(e) {
		handle_breakpoint_change(e, theme_options);
	});
	handle_breakpoint_change(media_query, theme_options);

	var limit_birthday_date = new Date().toISOString().split('T')[0];
	$('.page-account-profile #birthday').attr('max', limit_birthday_date);

	$(window).load(function() {
		$('body:not(.page-about) .flexslider').flexslider({
			slideshowSpeed: parseInt(theme_options.slideshow_slide_speed * 1000),
			slideshow: false,
			smoothHeight: true,
			prevText: "",
			nextText: "",
			start: function(slider) {
				// Play video in first slide if it exists
				var $firstSlide = $(slider.slides[0]);
				var $video = $firstSlide.find('.slide-video-element');
				if ($video.length) {
					$video[0].play();
				}

				//Trigger first set of options
				var default_option = 'false';
				if (typeof product !== 'undefined' && product.option_groups.length > 0) {
					var default_option = product_default_option(product);
					$('.select-product-options option[value="' + default_option + '"]').prop('selected', true).trigger('change');
				}
				if (isNaN(default_option)) {
					$('.select-product-options').val(0).change();
				}

				if($('body').hasClass('page-product')){
					var image_height = $('.flex-active-slide img, .flex-active-slide video').height();
					$('.flexslider').css('min-height',image_height);
				}

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
				var $currentSlide = $(slider.slides[slider.currentSlide]);
				var $video = $currentSlide.find('.slide-video-element');
				if ($video.length) {
					$video[0].play();
				}

				if($('body').hasClass('page-product')){
					var image_height = $('.flex-active-slide img, .flex-active-slide video').height();
					$('.flexslider').css('min-height',image_height);

					if(product.option_groups.length > 0 && theme_options.trigger_thumbnail_option == 'show'){
						if(slider.direction != undefined){
							update_product_select($('.flexslider .flex-active-slide img').attr('src'), 'slideshow');
						}
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
						$container = $('.related-products .products');
						set_layout();
						if ($('body').hasClass('feather')) {
							feather.replace();
						}
						lazyLoadInstance.update();
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
		}, '.product-list.has-video');
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



function product_options(product, onload) {
	if ($('.select-product-options').length) {
		$('.add-cart').fadeTo('fast', 0.25).removeClass('form-enabled');

		var _this = $('.select-product-options');
		var option = $('option:selected', _this);

		var data_product_options = { all: true, id_variant_1: option.data('id_variant_1'), id_variant_2: option.data('id_variant_2'), id_variant_3: option.data('id_variant_3') };
		var product_handle = product.handle;

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

					if (product_is_vendible(product, response)) {
						$('body').removeClass('price-on-request');

						$('.product .data-price-non-wholesale').text(response.price_non_wholesale_formatted);

						if (response.promo === true) {
							$('.product .price del').text(response.price_formatted);
							price_txt = response.price_promo_formatted;

							if (response.price_promo_percentage) {
								$('.promo-percentage').removeClass('hidden');
								$('.data-promo-percentage').text(response.price_promo_percentage);
							} else {
								$('.promo-percentage').addClass('hidden');
							}
						} else {
							$('.product .price del').text('');
							price_txt = response.price_formatted;
							$('.promo-percentage').addClass('hidden')
							$('.data-promo-percentage').text('');
						}

						if (response.rewards) {
							$('#message-points').text(response.rewards);
							$('#message-points').parents('.alert').removeClass('hidden');
						} else {
							$('#message-points').parents('.alert').addClass('hidden');
						}

						$('.extra-options').removeClass('hidden').find('input, select, textarea').prop('disabled', false);

						disable_form_product = false;
					} else {
						$('body').addClass('price-on-request');

						price_txt = lang.storefront.script.product.not_available;
						disable_form_product = true;
					}

					stock_qty = response.stock_qty;
				}

				if (response.image && response.image.full.indexOf('no-img') <= 0) {
					var image_index = $('.flexslider li:not(.clone)').find('img[src="' + response.image.full + '"]').parent('li').index();
					$('.flexslider').flexslider(image_index);
				}

				if (response.wishlist) {
					if (response.wishlist.status) {
						wishlist_html = helper_icon_render('heart', 'fa-lg');
						wishlist_url = response.wishlist.remove_url;
						$('.wishlist').addClass('added');
					} else {
						wishlist_html = helper_icon_render('heart', 'fa-lg');
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
					var image_index = $('.flexslider li:not(.clone)').find('img[src="' + response.image.full + '"]').parent('li').index();
					$('.flexslider').flexslider(image_index);
				}
			}

			$(document).trigger('trigger_product_options', response);

			if (disable_form_product === true) {
				$('.product .price del').text('');
				$('.data-promo-percentage').text('');
				$('.extra-options').addClass('hidden').find('input, select, textarea').prop('disabled', true);
			}

			$('.data-product-price').text(price_txt);
			$('.data-product-stock_qty').text(stock_qty);
			$('span.sku').text(reference);
			$('span.ean').text(barcode);

			$('.add-cart').addClass('form-enabled');

			product_options_url();

		}, 'json');
	} else {
		$('.add-cart').addClass('form-enabled');
		$('.extra-options').removeClass('hidden').find('input, select, textarea').prop('disabled', false);
	}
}

function product_options_url() {
	$('.select-product-options').on('change', function() {
		var pathname = window.location.pathname;
		var origin = window.location.origin;

		var option = $(this).prop('value');

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
	//get query string value
	var option_id = qs["option"];

	return option_id;
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

function handle_breakpoint_change(e, theme_options) {
    var gallery_type = e.matches ? 'mobile' : 'desktop';

    destroy_slideshow();

    if (gallery_type === 'mobile') {
        load_slideshow('mobile', (theme_options.gallery_type === 'products' ? theme_options.gallery : theme_options.mobile_gallery), theme_options);
    } else {
        load_slideshow('desktop', theme_options.gallery, theme_options);
    }
}

function load_slideshow(type, gallery, theme_options) {
    if (type == 'mobile') {
        $('.slideshow').addClass('slideshow-gallery-mobile');
    } else {
        $('.slideshow').addClass('slideshow-gallery');
    }

    if (gallery && gallery.length) {
        for (var i = 0; i < gallery.length; i++) {
            var has_slide_content = (gallery[i].title || gallery[i].button || gallery[i].description) ? 'has-slide-content' : '';
            var slideshow_content = has_slide_content ? ('<div class="slide-content">' + (gallery[i].title ? (gallery[i].link ? '<h4 class="slide-title"><a href="'+gallery[i].link+'">'+gallery[i].title+'</a></h4>' : '<h4 class="slide-title">'+gallery[i].title+'</h4>') : '') + (gallery[i].description ? '<div class="slide-description">'+gallery[i].description+'</div>' : '') + (gallery[i].button ? '<div class="slide-button"><a href="'+gallery[i].button_link+'" '+(gallery[i].target_blank == '1' ? 'target="_blank"' : '' )+ 'class="button">'+gallery[i].button+'</a></div>' : '') + '</div>') : '';
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
                    '<video class="slide-video-element" autoplay muted playsinline '+(gallery.length == 1 ? 'loop' : '')+' poster="'+poster_url+'" data-size="'+theme_options.slideshow_background_size+'" aria-label="'+(gallery[i].image.alt ? gallery[i].image.alt : gallery[i].title)+'">' +
                    '<source src="'+video_url+'" type="video/mp4">' +
                    (gallery[i].image.alt ? gallery[i].image.alt : gallery[i].title) +
                    '</video>' +
                    slideshow_content +
                    '</li>';
            } else {
				slideshow_slide = '<li class="slide '+has_slide_content+'"><img src="'+gallery[i].image.full+'">' + slideshow_content + '</li>';
			}

            $('.slideshow .slides').append(slideshow_slide);
        }

		$('.slideshow').flexslider({
			slideshowSpeed: parseInt(theme_options.slideshow_slide_speed * 1000),
			animationSpeed: 1000,
			controlNav: true,
			directionNav: true,
			prevText: "",
			nextText: "",
			start: function(slider){
				// Play video in first slide if it exists
				var $firstSlide = $(slider.slides[0]);
				var $video = $firstSlide.find('.slide-video-element');
				if ($video.length) {
					$video[0].play();

                    slider.pause();
                    $video.on('ended', function() {
                        slider.play();
                    });
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
				var $currentSlide = $(slider.slides[slider.currentSlide]);
				var $video = $currentSlide.find('.slide-video-element');
				if ($video.length) {
					$video[0].play();

                    slider.pause();
                    $video.on('ended', function() {
                        slider.play();
                    });
				}
			}
		});

		$('.slideshow').removeClass('hidden');
    }
}

function destroy_slideshow() {
    var slideshow = $('.slideshow');
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
    slideshow.removeClass('slideshow-gallery-mobile slideshow-gallery loaded').addClass('hidden');
}

(function($) {
	$.fn.hasScrollBar = function() {
		return this.get(0).scrollWidth > this.get(0).clientWidth;
	};
})(jQuery);
