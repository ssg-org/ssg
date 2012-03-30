/* Copyright (c) 2012 SSG
 * 
 * Requires: 
 */
(function( $ ){
	$.fn.main_menu = function(options) {
		$(this).hover(
			function() {
				$(this).next().stop().animate({ left :50 }, 'fast');
			},
			function() {
				if (!$(this).next().hasClass('left-menu-active')) {
					$(this).next().stop().animate({ left :-100 }, 'fast');
				}
			}
		);
	};
})( jQuery );