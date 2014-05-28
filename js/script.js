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
	
	$('a.fancy').fancybox({'overlayColor' : '#fff'});
	
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

	$(document).on('change', '.select-product-options', function() {
  		var option = $('option:selected', this);
  		var price = option.data('price');
  		$('.page-product .price span').text(price);
	});
		
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