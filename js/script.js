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

