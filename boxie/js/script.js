(function () {
  svg4everybody();
})();

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

    if ($('body').hasClass('dark')) {
        $('.payment-methods li').each(function(index, el) {
            var img = $(el).find('img');
            var img_source = img.data('src');
            if (img_source) {
                img.attr('data-src', img_source.replace('color', 'white-bg'));
            }
        });
    }

    // header
    var header = $('.header'),
        burger = header.find('.trigger-header-menu'),
        menu = header.find('.header-menu'),
        items = menu.find('.menu-item'),
        subitems = menu.find('.menu-body .menu-item'),
        close = menu.find('.menu-close'),
        back = menu.find('.menu-back'),
        html = $('html'),
        body = $('body');

    burger.on('click', function() {
        burger.toggleClass('active');
        menu.toggleClass('visible').promise().done(function(){
            if (Modernizr.mq('only screen and (min-width: 767px)')) {
                var height = $('.store-notice').outerHeight();
                if (menu.hasClass('visible')) {
                    menu.css('top', height);
                } else {
                    menu.css('top', 0);
                }
            } else {
                $('.store-notice').toggleClass('hidden');
                menu.css('top', 0);
            }
        });
        html.toggleClass('no-scroll');
        body.toggleClass('no-scroll');
    });

    items.each(function () {
        var item = $(this),
        head = item.find('.js-menu-head');
        subhead = item.find('.js-submenu-head');

        head.on('click', function (e) {

            if (Modernizr.mq('only screen and (min-width: 767px)')) {
                var biggest_submenu_items = Math.max.apply(Math, $('.menu-body .menu-item', item).map(function(item){
                    return $(this).width();
                }));

                $('.menu-body .menu-item', item).each(function(index, el) {
                    var item_width = $(el).width();
                    $('.submenu-body', el).css('left', (biggest_submenu_items - item_width) / 2 + item_width + 70 );
                });
            } else {
                $('.menu-body .menu-item', item).each(function(index, el) {
                    $('.submenu-body', el).css('left', 0);
                });
            }

            if (!item.hasClass('active')) {
                menu.removeClass('left left2x');
                items.removeClass('active');
                menu.addClass('left');
                item.addClass('active');
            } else {
                items.removeClass('active');
                menu.removeClass('left left2x');
            }
        });

        if (head.parent('.menu-item').hasClass('active')) {
            menu.addClass('left');
        }
        if (subhead.parent('.menu-item').hasClass('active')) {
            head.trigger('click');
            item.parents('.menu-item').addClass('active');
            item.find('.submenu-item.active').parents('.menu-item').addClass('active');
            menu.addClass('left left2x');
        }

        close.on('click', function () {
            items.removeClass('active');
            burger.toggleClass('active');
            menu.toggleClass('visible');
            menu.removeClass('left');
            html.removeClass('no-scroll');
            body.removeClass('no-scroll');
        });
    });

    $('.js-submenu-head').on('click', function () {
        item = $(this).closest('.menu-item');

        if (!item.hasClass('active')) {
            menu.removeClass('left2x');
            subitems.removeClass('active');
            menu.addClass('left2x');
            item.addClass('active');
        } else {
            menu.removeClass('left2x');
            item.removeClass('active');
        }
    });

    back.on('click', function () {
        if (menu.hasClass('left2x')) {
            menu.removeClass('left2x');
            menu.find('.menu-group .menu-item').removeClass('active');
        } else {
            menu.removeClass('left');
            menu.find('.menu-item').removeClass('active');
        }
    });

    if (Modernizr.mq('only screen and (min-width: 767px)')) {
        var biggest_menu_items = Math.max.apply(Math, $('.menu-list > .menu-item', menu).map(function(item){
            return $(this).width();
        }));

        $('.menu-list > .menu-item', menu).each(function(index, el) {
            var item_width = $(el).width();
            $('.menu-body', el).css('left', (biggest_menu_items - item_width) / 2 + item_width + 70 );
        });
    } else {
        $('.menu-list > .menu-item', menu).each(function(index, el) {
            $('.menu-body', el).css('left', 0);
        });
    }

    var headerHeight = $('.header').next().offset().top;
    document.documentElement.style.setProperty('--header-height', ($('.header').outerHeight() + $('.store-notice').outerHeight()));
    $(window).on('scroll', function () {
        if ($(window).scrollTop() > headerHeight) {
            $('.header.fixed-header').addClass('fixed');
            $('.fixed-header #nav-spacer').removeClass('hidden');
        } else {
            $('.fixed-header #nav-spacer').addClass('hidden');
            $('.header.fixed-header').removeClass('fixed');
        }
    });

    // search
    var search = $('.header-control .search'),
        search_input = $('.header-control .search').find('input'),
        btn = search.find('.search-button');
    btn.on('click', function () {
        if (!search.hasClass('show')) {
            search.addClass('show');
            search_input.focus();
            return false;
        } else {
            if (!search_input.val()) {
                search.removeClass('show');
                return false;
            } else {
                search.find('form').submit();
            }
        }
    });

    // global variables
    var prevArrow = '<button type="button" class="slick-prev">'+helper_icon_render('angle-left')+'</button>',
        nextArrow = '<button type="button" class="slick-next">'+helper_icon_render('angle-right')+'</button>';

    var slides = $('.categories-slider, .card-slider, .slider-container .products-list, .blog .blog-list, .js-slider-review');

    slides.each(function(index, el) {
        $(el).on('init', function(event, slick, currentSlide, nextSlide) {
            $(el).find('.slide').addClass('slide-loaded');
            if ($('body').hasClass('feather')) {
                feather.replace();
            }
            lazyLoadInstance.update();
        });
    });

    var media_query = window.matchMedia('(max-width: 767px)');
    media_query.addEventListener('change', function(e) {
        handle_breakpoint_change(e, theme_options);
    });
    handle_breakpoint_change(media_query, theme_options);

    // slider categories
    $('.categories-slider').slick({
        slidesToShow: 8,
        slidesToScroll: 1,
        arrows: true,
        prevArrow: prevArrow,
        nextArrow: nextArrow,
        speed: 600,
        infinite: true,
        responsive: [{
            breakpoint: 1366,
            settings: {
                slidesToShow: 7
            }
        }, {
            breakpoint: 1200,
            settings: {
                slidesToShow: 6
            }
        }, {
            breakpoint: 1024,
            settings: {
                slidesToShow: 5
            }
        }, {
            breakpoint: 768,
            settings: {
                slidesToShow: 4
            }
        }, {
            breakpoint: 640,
            settings: {
                slidesToShow: 2
            }
        }]
    });

    // slider card (Gallery)
    $('.card-slider').slick({
        slidesToShow: 3,
        slidesToScroll: 1,
        arrows: true,
        prevArrow: prevArrow,
        nextArrow: nextArrow,
        speed: 600,
        vertical: true,
        verticalSwiping: true,
        responsive: [{
            breakpoint: 1024,
            settings: {
                vertical: false,
                verticalSwiping: false
            }
        }, {
            breakpoint: 768,
            settings: {
                slidesToShow: 1,
                vertical: false,
                verticalSwiping: false
            }
        }]
    });

    // slider review
    $('.js-slider-review').slick({
        slidesToShow: 1,
        slidesToScroll: 1,
        arrows: true,
        prevArrow: prevArrow,
        nextArrow: nextArrow,
        dots: true,
        speed: 600,
        adaptiveHeight: true
    });

    $('.brands-block .brands-list').slick({
        slidesToShow: 6,
        slidesToScroll: 3,
        arrows: true,
        prevArrow: prevArrow,
        nextArrow: nextArrow,
        speed: 600,
        adaptiveHeight: true,
        responsive: [{
            breakpoint: 1024,
            settings: {
                slidesToShow: 5
            }
        }, {
            breakpoint: 768,
            settings: {
                slidesToShow: 4,
                slidesToScroll: 4
            }
        }, {
            breakpoint: 640,
            settings: {
                slidesToShow: 3
            }
        }, {
            breakpoint: 425,
            settings: {
                slidesToShow: 2,
                slidesToScroll: 2
            }
        }]
    });

    $('.blog .blog-list').slick({
        slidesToShow: 1,
        slidesToScroll: 1,
        arrows: true,
        prevArrow: prevArrow,
        nextArrow: nextArrow,
        speed: 600,
        adaptiveHeight: true,
        responsive: [{
            breakpoint: 9999,
            settings: "unslick"
        }, {
            breakpoint: 768,
            settings: ""
        }]
    });

    $(window).on('resize orientationchange', function () {
        $('.blog .blog-list').slick('resize');
        if ($('body').hasClass('feather')) {
            feather.replace();
        }
    });

    // zoom
    var ezOptions = {
        gallery: "gallery",
        galleryActiveClass: "active",
        zoomWindowWidth: "auto",
        zoomWindowHeight: "auto",
        zoomWindowOffsetX: 50,
        borderSize: "5",
        borderColour: "#F6F7FB",
        responsive: true,
        respond: [{
            range: '768-9999',
            zoomType: 'inner',
            cursor: 'crosshair',
            borderSize: "0"
        }, {
            range: '320-767',
            enabled: false,
            showLens: false
        }]
    };

    function init_js_zoom() {
        var img = $(".card-wrap .card-preview img.js-zoom");
        if (img.length && img.attr('data-zoom-image')) {
            img.ezPlus(ezOptions);
        }
    }

    init_js_zoom();

    $(".card-slide a").click(function(e, update_select = true) {
        if (typeof product !== 'undefined') {
            var _this = $(this);
            var image = _this.attr('data-image');
            var video = _this.attr('data-video-url');
            var zoom  = _this.data('zoom-image') || image;
            var image_container = $('.card-wrap .card-preview');

            $("#gallery .card-preview").removeClass("active");
            _this.addClass("active");

            if (product.option_groups.length > 0 && theme_options.trigger_thumbnail_option == 'show') {
                var current_image = image_container.find("img.js-zoom");
                if (current_image.length && current_image.data("ezPlus")) {
                    try { current_image.data("ezPlus").destroy(); } catch (err) {}
                }
            }

            if (video) {
                image_container.html(
                    '<video controls muted autoplay loop poster="' + (image || "") + '" class="card-pic" width="600">' +
                    '<source src="' + video + '" type="video/mp4">' +
                    "Your browser does not support the video tag." +
                    "</video>"
                );
                image_container.siblings('.card-icon').addClass('hidden');
            } else {
                image_container.html(
                    '<img class="card-pic js-zoom" src="' + image + '" data-zoom-image="' + zoom + '" alt="">'
                );
                image_container.siblings('.card-icon').removeClass('hidden');
                init_js_zoom();
            }

            if (product.option_groups.length > 0 && theme_options.trigger_thumbnail_option == 'show') {
                if (Modernizr.mq('(min-width: 768px)') && update_select == true){
                    update_product_select(image);
                }
            }
        }
        set_container_height();
    });

    $('.card-slider').on('afterChange', function(event, slick, currentSlide, nextSlide) {
        event.preventDefault();
        if (Modernizr.mq('(max-width: 767px)') && typeof product !== 'undefined' && product.option_groups.length > 0 && theme_options.trigger_thumbnail_option == 'show') {
            update_product_select($('.card-slide[data-slick-index="'+ currentSlide +'"] a').attr('data-image'));
        }
        set_container_height();
    });

    if (Modernizr.mq('(max-width: 767px)')) {
        $('.card-preview').on('click', function (e) {
            e.preventDefault();
        });
    }

    if (Modernizr.mq('(min-width: 767px)')) {
        $('.header-menu').css('padding-top', $('.header').outerHeight());
    }

    $('.product-category').each(function(){
        var _this = $(this);
        if (this.offsetWidth < this.scrollWidth && !_this.attr('title')) {
            _this.attr({
                'title': _this.text()
            });
        }
    });

    $('[data-toggle=tooltip]').tooltip();

    $('.page-product .details .nav-item:first-child a').trigger('click');

    // filters
    (function () {
        var filters = $('.js-filters'),
            open = filters.find('.js-filters-open'),
            wrap = filters.find('.js-filters-wrap');
        open.on('click', function () {
            open.toggleClass('active');
            wrap.slideToggle();
        });

        var tags = filters.find('.filters_tags'),
            items = filters.find('.dropdown-item:not([data-type="category"])');

        items.each(function() {
            var item = $(this);

            item.on('click', function(e) {
                e.preventDefault();
                var _this = $(this),
                    params = get_url_params();
                if (_this.data('type') == 'price') {
                    params.price_min = _this.data('min');
                    params.price_max = _this.data('max');
                }
                if (_this.data('type') == 'tag') {
                    var tags = params.filter_tag ? params.filter_tag.split(",") : [];
                    var index = tags.indexOf(_this.data('tag'));

                    if (index > -1) {
                        tags.splice(index, 1);
                    } else {
                        tags.push(_this.data('tag'));
                    }
                    if (tags == false) {
                        delete params.filter_tag;
                    } else {
                        params.filter_tag = tags.join(',');
                    }
                }
                //params['_js'] = 'filter';

                location.href = generate_url(params);
            });
        });

        $(document).on('click', '.filters-remove', function(e) {
            var _this = $(this);
            var parent = _this.parent();
            var params = get_url_params();

            if (parent.data('type') == 'price') {
                delete params.price_min;
                delete params.price_max;
            }

            if (parent.data('type') == 'tag') {
                var tags = params.filter_tag ? params.filter_tag.split(",") : [];
                var index = tags.indexOf(parent.data('remove'));

                if (index > -1) {
                    tags.splice(index, 1);
                }
                if (tags == false) {
                    delete params.filter_tag;
                } else {
                    params.filter_tag = tags.join(',');
                }
            }

            location.href = generate_url(params);
        });

        $(document).on('click', '.js-order-by li', function(e) {
            var _this = $(this);
            var order = $(this).data('value');
            var params = get_url_params();
            params['order_by'] = order;

            location.href = generate_url(params);
        });


    })();

    // active filters
    (function () {
        var template_tags = $('.filters_tags'),
            html = '',
            params = get_url_params(),
            tags = params.filter_tag ? params.filter_tag.split(",") : [],
            price_min = params.price_min ? params.price_min : '';
            price_max = params.price_max ? params.price_max : '';

        if (price_min && price_max) {
            $('.filter').find('[data-min="'+ price_min +'"][data-max="'+ price_max +'"]').addClass('active');
        }

        if (tags != false) {
            for (i=0; i<tags.length; i++){
                $('.filter').find('[data-tag="'+ tags[i] +'"]').addClass('active');
            }
        }
    })();

    // select
    $(document).ready(function () {
        $('select:not([name="pickup"]):not("#pick_up_location"):not(.app-shopkit-product-extra-select)').niceSelect();
    });

    check_shipping($('input[name="pagamento"]:checked'));

    $(document).on('change', 'input[name="pagamento"]', function() {
        check_shipping($(this));
    });

    $('form').submit(function() {
        $('body').css({ 'cursor': 'wait' });
        $(this).find('input[type=submit], button').prop('disabled', true);
    });

    $(window).resize(function() {
        if ($('.table-responsive, .product-thumbs').length) {
            $('.table-responsive, .product-thumbs').each(function() {
                var _this = $(this);
                if (_this.hasScrollBar()) {
                    _this.addClass('has-mask');
                } else {
                    _this.removeClass('has-mask');
                }
            });
        }
    }).resize();

    $('.table-responsive.has-mask, .product-thumbs.has-mask').scroll(function() {
        var _this = $(this);
        var scroll_position = _this.scrollLeft();

        if (scroll_position > 0) {
            _this.addClass('mask-hidden');
        } else {
            _this.removeClass('mask-hidden');
        }
    });

    //Event on change
    $(document).on('change', 'select.select-product-options', function() {
        product_options(product);
    });

    //Billing / Delivery data
    $(document).on('change', '#billing_info_same_delivery', function(event) {
        var _this = $(this);
        var target = _this.data('target');
        $(target).toggleClass('d-none');
    });

    $(document).on('blur', 'input[name$=zip_code]', function(e) {
        set_country_by_postal_code($(this));
        $('#delivery_country, #billing_country').niceSelect('update');
    });

    $('.payment-methods .list-radio-block.list-group-item-active').find('select#pick_up_location').prop('required', true);

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

    $('.details table, .product-tabs-content table, .product-tabs table').addClass('table').addClass('table-bordered').addClass('table-product-content');
    $('.details table, .product-tabs-content table, .product-tabs table').wrap('<div class="table-responsive"></div>');

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
                    // slider products (Related Products)
                    $('.slider-container .products-list').slick({
                        slidesToShow: theme_options.products_per_row ? parseInt(theme_options.products_per_row) : 3,
                        slidesToScroll: 1,
                        arrows: true,
                        prevArrow: prevArrow,
                        nextArrow: nextArrow,
                        speed: 600,
                        responsive: [{
                            breakpoint: 1024,
                            settings: {
                                slidesToShow: 2
                            }
                        }, {
                            breakpoint: 767,
                            settings: {
                                slidesToShow: theme_options.mobile_products_per_row ? parseInt(theme_options.mobile_products_per_row) : 1,
                                adaptiveHeight: true
                            }
                        }]
                    });
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

        if ($('[name="' + target + '"]').is('select')) {
            $('[name="' + target + '"]').next('.nice-select').niceSelect('update').toggleClass('hidden disabled', !is_checked).prop('disabled', !is_checked).prop('required', is_required);
        }
    });

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
    $('.fb-page').each(function() {
        $(this).attr('data-width', $(this).parent().width());
    });

    //Force first option to be triggered
    if (typeof product !== 'undefined' && product.option_groups.length > 0) {
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
});

// counter
(function () {
    var counters = $('.counter');
    counters.each(function () {
        var counter = $(this),
            minus = counter.find('.counter-btn_minus'),
            plus = counter.find('.counter-btn_plus'),
            input = counter.find('.counter-input');

        if (input.is('[readonly]')) {
            return false;
        }

        minus.on('click', function () {
            var count = parseInt(input.val()) - 1;
                count = count < 1 ? 1 : count;

            input.val(count);
        });
        plus.on('click', function () {
            input.val(parseInt(input.val()) + 1);
        });
        input.blur(function () {
            if (input.val() == "") {
                input.val("0");
            }
        });
        input.bind("change keyup input click", function () {
            input.val(input.val().replace(/[^\d]/, ""));
        });
    });
})();

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

    if ($('select.select-product-options').length) {
        $('.add-cart').fadeTo('fast', 0.25).removeClass('form-enabled');

        var default_option = product_default_option(product);

        $('select.select-product-options').each(function(i) {
            if (onload == true) {
                $('option[value="' + default_option[i] + '"]', this).prop('selected', true);
            }
            $('select').niceSelect('update');
            var option = $(this).next('.nice-select').find('.option.selected');
            window['id_variant_' + (i + 1)] = option.data('value');
        });

        if ($('select.select-product-options').length == 1 && onload == true) {
            $.each(product.options, function(key, option){
                var $option = $('select.select-product-options option[value="'+ option.id_variant_1 +'"]'),
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
            $('select').niceSelect('update');
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
                            $('.card-old').text(response.price_formatted);
                            $('.card-old').removeClass('hidden');
                            price_txt = response.price_promo_formatted;

                            if (response.price_promo_percentage) {
                                $('.promo-percentage').removeClass('hidden');
                                $('.data-promo-percentage').text(response.price_promo_percentage);
                            } else {
                                $('.promo-percentage').addClass('hidden');
                            }
                        } else {
                            $('.card-old').text('');
                            $('.card-old').addClass('hidden');
                            price_txt = response.price_formatted;
                            $('.promo-percentage').addClass('hidden');
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
                        $('.card-old').addClass('hidden');
                        disable_form_product = true;
                    }

                    stock_qty = response.stock_qty;
                }

                if (response.image && response.image.full.indexOf('no-img') <= 0) {
                    var image_selected = $('.card-slider').find('.card-slide:not(.slick-cloned) a[data-image="' + response.image.full + '"]');
                    var image_selected_index = image_selected.parent().attr('data-slick-index');

                    if ($('.card-slider .card-slide').length > 3) {
                        if (Modernizr.mq('(max-width: 767px)')){
                            $('select.select-product-options').addClass('manual-change');
                        }
                        $('.card-slider').slick('slickGoTo', image_selected_index);
                    }

                    if (Modernizr.mq('(min-width: 768px)')){
                        $('select.select-product-options').addClass('manual-change');
                        image_selected.closest('a').trigger('click', false);
                        $('select.select-product-options').removeClass('manual-change');
                    }
                }

                if (response.wishlist) {
                    if (response.wishlist.status) {
                        wishlist_url = response.wishlist.remove_url;
                        $('a.card-favorite').attr('href', wishlist_url).addClass('added');
                    } else {
                        wishlist_url = response.wishlist.add_url;
                        $('a.card-favorite').attr('href', wishlist_url).removeClass('added');
                    }

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
                    var image_selected = $('.card-slider').find('.card-slide:not(.slick-cloned) a[data-image="' + response.image.full + '"]');
                    var image_selected_index = image_selected.parent().attr('data-slick-index');

                    if ($('.card-slider .card-slide').length > 3) {
                        if (Modernizr.mq('(max-width: 767px)')){
                            $('select.select-product-options').addClass('manual-change');
                        }
                        $('.card-slider').slick('slickGoTo', image_selected_index);
                    }

                    if (Modernizr.mq('(min-width: 768px)')){
                        $('select.select-product-options').addClass('manual-change');
                        image_selected.closest('a').trigger('click', false);
                        $('select.select-product-options').removeClass('manual-change');
                    }
                }
            }

            $(document).trigger('trigger_product_options', response);

            if (disable_form_product === true) {
                $('.card-old').text('');
                $('.product-detail .promo-percentage').addClass('hidden');
                $('.extra-options').addClass('hidden').find('input, select, textarea').prop('disabled', true);
            }

            animate_updated_value('.card-actual', price_txt, 'flash');
            animate_updated_value('.data-product-stock_qty', stock_qty, 'flash');
            animate_updated_value('.card-number.sku', reference, 'flash');
            animate_updated_value('.card-number.ean', barcode, 'flash');

            $('.add-cart input[name="qtd"], .add-cart button[type="submit"]').prop('disabled', disable_form_product);
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
        var selected_option = { 0: null, 1: null, 2: null };
        var k = 0;

        $('select.select-product-options').each(function(index, el) {
            selected_option[k] = $(this).next('.nice-select').find('.option.selected').data('value');
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

function set_container_height() {
    var interval = setInterval(function(){ // wait for fading
        var height = $(".card-wrap .card-pic").css("height");
        $(".ZoomContainer").css("height", height);
        $(".ZoomContainer .zoomWindow").css("height", height);
        clearInterval(interval);
    }, 100);
}

function animate_updated_value(selector, value, fx) {
    $(selector).text(value);
    $(selector).removeClass(fx + ' animated').addClass('flash animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function() {
        $(this).removeClass(fx + ' animated');
    });
}

function get_url_params() {
    var query_strings = {};
    location.search.substr(1).split("&").forEach(function(item) {if(item){query_strings[item.split("=")[0]] = item.split("=")[1];}});
    return query_strings;
}

function generate_url(params) {
    var i = 0, key,
        url = '//' + location.host + location.pathname;
    var segments = location.pathname.split('/');

    if (!isNaN(segments[segments.length - 1]) && segments[segments.length - 1] == parseFloat(segments[segments.length - 1])) {
        segments.pop();
        url = '//' + location.host + segments.join('/');
    }

    for (key in params) {
        if (i === 0) {
            url += "?";
        } else {
            url += "&";
        }
        url += key;
        url += '=';
        url += params[key];
        i++;
    }
    return url;
}

function handle_breakpoint_change(e, theme_options) {
    var gallery_type = e.matches ? 'mobile' : 'desktop';

    destroy_slideshow();

    if (gallery_type === 'mobile') {
        load_slideshow('mobile', (theme_options.gallery_type === 'products' ? theme_options.gallery : theme_options.mobile_gallery), theme_options);
        if (theme_options.slideshow_mobile_full_height == 'slideshow-mobile-full-height') {
            $('.home-slideshow > div').removeClass('container container-fluid');
        } else {
            $('.home-slideshow > div').addClass((theme_options.layout_container == 'fluid' ? 'container-fluid' : 'container'));
        }
    } else {
        load_slideshow('desktop', theme_options.gallery, theme_options);
        if (theme_options.slideshow_full_height == 'slideshow-full-height') {
            $('.home-slideshow > div').removeClass('container container-fluid');
        } else {
            $('.home-slideshow > div').addClass((theme_options.layout_container == 'fluid' ? 'container-fluid' : 'container'));
        }
    }
}

function load_slideshow(type, gallery, theme_options) {
    var slideshow = $('.slideshow-gallery, .slideshow-gallery-mobile');

    if (type == 'mobile') {
        $('.slideshow').addClass('slideshow-gallery-mobile');
    } else {
        $('.slideshow').addClass('slideshow-gallery');
    }

    slideshow.each(function(index, el) {
        $(el).on('init', function(event, slick, currentSlide, nextSlide) {
            $(el).find('.slide').addClass('slide-loaded');
            if ($('body').hasClass('feather')) {
                feather.replace();
            }
            lazyLoadInstance.update();
        });
    });

    if (gallery && gallery.length) {
        for (var i = 0; i < gallery.length; i++) {
            var has_slide_content = (gallery[i].title || gallery[i].button || gallery[i].description) ? 'has-slide-content' : '';
            var slideshow_content = has_slide_content ? ('<div class="slideshow-overlay"></div><div class="slideshow-details">' + (gallery[i].title ? (gallery[i].link ? '<h1 class="slideshow-title title"><a href="'+gallery[i].link+'" class="link-inherit">'+gallery[i].title+'</a></h1>' : '<h1 class="slideshow-title title">'+gallery[i].title+'</h1>') : '') + (gallery[i].description ? '<div class="slideshow-description">'+gallery[i].description+'</div>' : '') + (gallery[i].button ? '<a class="slideshow-btn btn btn-primary" href="'+gallery[i].button_link+'" '+(gallery[i].target_blank == '1' ? 'target="_blank"' : '' )+ '>'+gallery[i].button+'</a>' : '') + '</div>') : '';
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
                slideshow_slide = '<div class="slide slide-video '+has_slide_content+'">' +
                    '<video class="slide-video-element" autoplay muted playsinline '+(gallery.length == 1 ? 'loop' : '')+' poster="'+poster_url+'" data-size="'+theme_options.slideshow_background_size+'">' +
                    '<source src="'+video_url+'" type="video/mp4">' +
                    'Your browser does not support the video tag.' +
                    '</video>' +
                    slideshow_content +
                    '</div>';
            } else {
                slideshow_slide = '<div class="slide '+has_slide_content+'" style="background-image:url('+gallery[i].image.full+'); background-repeat: no-repeat;">' + slideshow_content + '</div>';
            }

            $('.slideshow').append(slideshow_slide);
        }

        function pause_slideshow($el){
            if ($el && $el.length && $el.hasClass('slick-initialized')) {
                $el.slick('slickPause');
            }
        }

        function play_slideshow($el){
            if ($el && $el.length && $el.hasClass('slick-initialized')) {
                $el.slick('slickPlay');
            }
        }

        $('.slideshow-gallery, .slideshow-gallery-mobile').on('init', function(event, slick){
            var _slider = $(slick && slick.$slider ? slick.$slider : this);
            var current_slide = $(this).find('.slick-current');
            if (current_slide.hasClass('slide-video')) {
                var video = current_slide.find('.slide-video-element').get(0);
                if (video) {
                    video.play();

                    pause_slideshow(_slider);
                    $(video).off('ended._slickVideoOnce').one('ended._slickVideoOnce', function () {
                        play_slideshow(_slider);
                    });
                }
            }
        });

        $('.slideshow-gallery, .slideshow-gallery-mobile').removeClass('hidden').slick({
            autoplay: true,
            autoplaySpeed: parseInt(theme_options.slideshow_slide_speed * 1000),
            arrows: true,
            prevArrow: '<button type="button" class="slick-prev">'+helper_icon_render('angle-left')+'</button>',
            nextArrow: '<button type="button" class="slick-next">'+helper_icon_render('angle-right')+'</button>',
            speed: 900,
            infinite: true,
            draggable: false,
            pauseOnFocus: true,
            pauseOnHover: true
        });

        $('.slideshow-gallery, .slideshow-gallery-mobile').on('beforeChange', function(event, slick, currentSlide, nextSlide){
            // Pause all videos
            $('.slide-video-element').each(function() {
                this.pause();
            });
        });

        $('.slideshow-gallery, .slideshow-gallery-mobile').on('afterChange', function(event, slick, currentSlide, nextSlide){
            // Play current slide video
            var _slider = $(slick && slick.$slider ? slick.$slider : this);
            var current_slide = $(this).find('.slick-current');
            if (current_slide.hasClass('slide-video')) {
                var video = current_slide.find('.slide-video-element').get(0);
                if (video) {
                    video.play();

                    pause_slideshow(_slider);
                    $(video).off('ended._slickVideoOnce').one('ended._slickVideoOnce', function () {
                        play_slideshow(_slider);
                    });
                }
            }
        });
    }
}

function destroy_slideshow() {
    var slideshow = $('.slideshow');
    if (slideshow.hasClass('slick-initialized')) {
        // Pause and remove all videos before destroying
        $('.slide-video-element').each(function() {
            this.pause();
            this.src = '';
        });
        slideshow.slick('unslick');
    }
    slideshow.empty().removeClass('slideshow-gallery-mobile slideshow-gallery loaded').addClass('hidden');
}

(function($) {
    $.fn.hasScrollBar = function() {
        return this.get(0).scrollWidth > this.get(0).clientWidth;
    };
})(jQuery);
