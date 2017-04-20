$(document).ready(function() {

	$('.products img').imagesLoaded(function(){
		
		masonry();
		
		$(window).resize(function() {
			masonry();
		});
	
	});
	
	$('.modal-alert').modal('show')
	
	if (typeof(imgs_slideshow) != "undefined") {
	
		$('.slideshow').crossSlide({
			speed: 45,
			fade: 1
		}, imgs_slideshow);	
	
	}
	
	$('a.fancy').fancybox({
		'overlayColor' : '#fff',
		onStart: function() {
			$('.fancybox-bg').remove();
			$('#fancybox-close').html('<i class="fa fa-times"></i>');
			$('#fancybox-loading').html('<i class="fa fa-2x fa-spinner"></i>');
			$('#fancybox-left > span').html('<i class="fa fa-chevron-left"></i>');
			$('#fancybox-right > span').html('<i class="fa fa-chevron-right"></i>');
		}
	});
	
	if (Modernizr.mq('only screen and (min-width: 767px)'))
	{
		$('.video-iframe').each(function(index) {
			src = $(this).attr('data-src');
	    	$(this).replaceWith('<iframe  src="' + src + '" frameborder="0" allowfullscreen></iframe>');
		});
	}

	$('.col-left nav ul li h4 a[href="#"]').click(function(e) {
		e.preventDefault();
	});

	check_shipping($('input[name="pagamento"]:checked'));

	$('input[name="pagamento"]').change(function(){
		check_shipping($(this));
	});

	$('[data-toggle=tooltip]').tooltip();

	$('form').submit(function() {
		$('body').css({'cursor':'wait'});
		$(this).find('input[type=submit], button[type=submit]').attr('disabled', 'true').fadeTo('fast', 0.25);
	});

	//Trigger first set of options
	if (typeof product !== 'undefined' && product.option_groups.length > 0)
	{
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
		
});

function masonry()
{
	if (Modernizr.mq('only screen and (max-width: 767px)'))
	{
		$('.products').masonry('destroy').removeAttr('style');
	}
		
	else
	{
		$('.products').masonry({ isAnimated: true });
	}
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

function product_options(product, onload)
{
	onload = typeof onload !== 'undefined' ? onload : false;

	if ($('.select-product-options').length)
	{
		$('.form-cart').fadeTo('fast', 0.25);

		var default_option = product_default_option(product);

		$('.select-product-options').each(function(i) {
			if (onload == true) {
				$('option[value="'+ default_option[i] +'"]', this).prop('selected', true);
			}
			var option = $('option:selected', this);
			window['id_variant_' + (i+1)] = option.attr('value');
		});

		var data_product_options = { id_variant_1 : window.id_variant_1, id_variant_2 : window.id_variant_2, id_variant_3 : window.id_variant_3 }
		var product_handle = product.handle;
		var disable_form_product;

		$.post( '/product-options/' + product_handle, data_product_options, function( response ) {

			var price_txt;
			var stock_qty;

			$('.form-cart').fadeTo('fast', 1);

			if (response)
			{
				if ( response.price_on_request === true )
				{
					$('body').addClass('price-on-request');

					price_txt = 'Preço sob consulta';
					disable_form_product= true;
				}
				else
				{
					$('body').removeClass('price-on-request');

					if (product_is_vendible(product, response))
					{
						if (response.promo === true)
						{
							$('.price del').text(response.price_formatted);
							price_txt = response.price_promo_formatted;
						}

						else
						{
							$('.price del').text('');
							price_txt = response.price_formatted;
						}

						disable_form_product = false;
					}

					else
					{
						price_txt = 'Não disponível';
						disable_form_product = true;
					}

					stock_qty = response.stock_qty;
				}

				if (response.image) {
					$('img[itemprop="image"]').prop('src', response.image.full);
					$('img[itemprop="image"]').parent('a').prop('href', response.image.full);
				}

				reference = response.reference;
			}

			else
			{
				price_txt = 'Não disponível';
				stock_qty = 0;
				disable_form_product = true;
				reference = '';
			}

			if (disable_form_product === true)
			{
				$('.price del').text('');
			}

			$('.data-product-price').text(price_txt);
			$('.data-product-stock_qty').text(stock_qty);
			$('span[itemprop="sku"]').text(reference);

			$('.form-cart input[name="qtd"], .form-cart button[type="submit"]').prop('disabled', disable_form_product);

			product_options_url();

		}, 'json');
	}
}

function product_options_url()
{
	$('.select-product-options').on('change', function () {
		var pathname = window.location.pathname;
		var origin = window.location.origin;
		var selected_option = { 0 : null, 1 : null, 2 : null };
		var k = 0;

		$('.select-product-options').each(function(index, el) {
			selected_option[k] = $('option:selected', this).prop('value');
			++k;
		});

		for (var i = 0; i < product.options.length; i++) {
			if (product.options[i].id_variant_1 == selected_option[0] && product.options[i].id_variant_2 == selected_option[1] && product.options[i].id_variant_3 == selected_option[2] ) {
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

function product_is_vendible(product, response)
{
	//Check if there object is not null
	if (response)
	{
		//Check product stock
		if (product.stock.stock_enabled)
		{
			if (response.stock_qty > 0)
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

	else
	{
		return false;
	}
}


//check product default option
function product_default_option(product)
{
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
			if (product.options[i].id == option_id ) {
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