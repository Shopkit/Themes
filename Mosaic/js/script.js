$(document).ready(function(){

	// $(window).resize(function () {
	// 	var window_height = $(window).height();
	// 	$('header').css({'height' : window_height});
	// }).resize();

	var $container = $('.products');
	var window_height = $(window).height();
	var window_width = $(window).width();

	set_layout();

	$('header .btn-slide, .slide-bar a.close').on('click', function() {

		var data_target = $(this).attr('data-target')
		var target = $(data_target);
		var slidebar_width = target.width();
		var side_width = $('.sidebar').width();

		if ( target.hasClass('in') )
		{
			target.removeClass('in');

			if ( !Modernizr.mq('(max-width: 979px)') )
			{
				target.css({'left' : side_width/1.3});
				$('.main, .bg-img, .bg-mask').css({'left' : side_width});
			}
		}

		else
		{

			$('.slide-bar').removeClass('in');
			target.addClass('in');

			if ( !Modernizr.mq('(max-width: 979px)') )
			{
				$('.slide-bar').css({'left' : side_width/1.3});
				$('.main, .bg-img, .bg-mask').css({'left' : side_width});
				$('.main, .bg-img, .bg-mask').css({'left' : side_width+slidebar_width});
				target.css({'left' : side_width});
			}
		}

		return false;

	});

	$('.flexslider').flexslider({
		animation: "slide",
		slideshow: false,
		smoothHeight: true,
		prevText: "",
		nextText: "",
		start: function(){
			//Trigger first set of options
			var default_option = 'false';
			if (typeof product !== 'undefined' && product.option_groups.length > 0) {
				var default_option = product_default_option(product);
				$('.select-product-options option[value="' + default_option + '"]').prop('selected', true).trigger('change');
			}
			if (isNaN(default_option)) {
				$('.select-product-options').val(0).change();
    		}
    	}
	});

	$('header form input[type=search]').on('keyup keypress', function() {
		$('header form').addClass( "focused" );
	});

	$('.modal-alert').modal('show');

	//Categories
	$('.categories ul a[href="#"]').click(function(e) {
		e.preventDefault();
	});

	$('.btn-navbar').click(function(){
		$('body').toggleClass('mobile-nav');
	});

	check_shipping($('input[name="pagamento"]:checked'));

	$('input[name="pagamento"]').change(function(){
		check_shipping($(this));
	});

	$('form').submit(function() {
		$('body').css({'cursor':'wait'});
		$(this).find('input[type=submit], button[type=submit]').attr('disabled', 'true').fadeTo('fast', 0.25);
	});

	$(document).on('change', '.select-product-options', function() {

		var option = $('option:selected', this);
		var price = option.data('price');
		var stock = option.data('stock');
		var promo = option.data('promo');
		var price_on_request = option.data('request');
		var price_promo = option.data('price-promo');
		var reference = option.data('reference');
		var image = option.data('image');

		if ( price_on_request === true )
		{
			$('body').addClass('price-on-request');

			$('.data-product-price').text('Preço sob consulta');
			$('.product .price del').text('');
		}

		else
		{
			if (product_is_vendible(product, stock))
			{
				$('body').removeClass('price-on-request');

				if (promo == true)
				{
					price_txt = price_promo;
					price_promo = price;
				}

				else
				{
					price_txt = price;
					price_promo = '';
				}
			}

			else
			{
				$('body').addClass('price-on-request');

				price_txt = 'Não disponível';
				price_promo = '';
			}

			$('.data-product-price').text(price_txt);
			$('.product .price del').text(price_promo);
			$('.data-product-stock_qty').text(stock);
		}

		if (image) {
			var image_index = $('.flexslider li:not(.clone)').find('img[src="' + image + '"]').parent('li').index();
			$('.flexslider').flexslider(image_index-1);
		}

		$('span[itemprop="sku"]').text(reference);

		product_options_url();
	});

	//Products

	$container.children('li').each(function() {
		var spin_el = $(this);
		spin_el.spin({
			color: basecolor,
			width: 3,
			top: (spin_el.height()/2)-20
		});
	});

	$container.imagesLoaded().done( function( instance ) {
		$container.isotope({
			resizable: false,
			masonry: {
				columnWidth: getUnitWidth()
			},
			onLayout: function() {
			}
		});
	})
	.progress( function( instance, image ) {
		var image_tag = $(image.img);
		image_tag.animate({'opacity' : 1}).parents('li').children('.spinner').fadeOut('slow', function() {
			image_tag.parents('li').spin(false);
		});
	});

	jQuery(window).smartresize(function () {
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
		} 

		else if ($container.width() >= 321 && $container.width() <= 480) {
			//console.log("321 - 480");
			width = Math.floor($container.width() / 1);
		}

		else if ($container.width() >= 481 && $container.width() <= 768) {
			//console.log("481 - 768");
			width = Math.floor($container.width() / 2);
		}

		else if ($container.width() >= 769 && $container.width() <= 979) {
			//console.log("769 - 979");
			width = Math.floor($container.width() / 3);
		}

		else if ($container.width() >= 980 && $container.width() <= 1200) {
			//console.log("980 - 1200");
			width = Math.floor($container.width() / 4);
		}

		else if ($container.width() >= 1201 && $container.width() <= 1600) {
			//console.log("1201 - 1600");
			width = Math.floor($container.width() / 4);
		}

		else if ($container.width() >= 1601 && $container.width() <= 1824) {
			//console.log("1601 - 1824");
			width = Math.floor($container.width() / 5);
		}

		else if ($container.width() >= 1825) {
			//console.log("1825");
			width = Math.floor($container.width() / 6);
		}
		return width;
	}

	function set_layout()
	{
		var unitWidth = getUnitWidth();

		$container.children("li").css({
			width: unitWidth,
			height: unitWidth
		});

		$('.et-wrapper').css({'height' : unitWidth});

		if (!Modernizr.mq('only all') && window_height<728) 
		{
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

});

function product_options_url()
{
    $('.select-product-options').on('change', function () {
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

function product_is_vendible(product, stock)
{
	//Check product stock
	if (product.stock.stock_enabled)
	{
		if (stock > 0)
		{
			return true;
		}

		else
		{
			if (product.stock.stock_backorder)
			{
				return true;
			}

			else
			{
				return false;
			}
		}
	}

	else
	{
		return true;
	}
}

//check product default option
function product_default_option(product)
{
    var option_id = 'false';
    var query = window.location.search.substring(1);

    if (query) {
        var option_id = query.split('option=')[1];
        option_id = option_id.split('&')[0];
    }

    return option_id;
}

function enable_shipping()
{
	$('.shipping-methods').fadeTo('fast', 1).find('input').prop('disabled', false);
}

function disable_shipping()
{
	$('.shipping-methods').fadeTo('fast', 0.25).find('input').prop('disabled', 'disabled');
}

function check_shipping(el)
{
	if (el.prop('value') == 'Levantamento nas instalações')
	{
		disable_shipping();
	}

	else
	{
		enable_shipping();
	}
}
