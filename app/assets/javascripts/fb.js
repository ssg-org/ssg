function fb_login(app_id, redirect_url, scope){
	var  screenX     = 	typeof window.screenX != 'undefined' ? window.screenX : window.screenLeft;
	var  screenY     = 	typeof window.screenY != 'undefined' ? window.screenY : window.screenTop;
	var  outerWidth  = 	typeof window.outerWidth != 'undefined' ? window.outerWidth : document.body.clientWidth;
	var  outerHeight = 	typeof window.outerHeight != 'undefined' ? window.outerHeight : (document.body.clientHeight - 22);
	var  width    = 500;
	var  height   = 280;
	var  left     = parseInt(screenX + ((outerWidth - width) / 2), 10);
	var  top      = parseInt(screenY + ((outerHeight - height) / 2.5), 10);
	var  features = 'width=' + width + ',height=' + height + ',left=' + left + ',top=' + top + ',title=' + 'Facebook login page' + ',background-color:' + '#000000';
	var newwindow = window.open('https://www.facebook.com/dialog/oauth?client_id=' + app_id +'&redirect_uri=' + redirect_url + '&scope=' + scope + '&state=4&display=popup', 'Facebook', features);
	if (window.focus) {
		newwindow.focus();
	}
	return false;
}

function twitter_login(redirect_url, consumer_key){
	var  screenX     = 	typeof window.screenX != 'undefined' ? window.screenX : window.screenLeft;
	var  screenY     = 	typeof window.screenY != 'undefined' ? window.screenY : window.screenTop;
	var  outerWidth  = 	typeof window.outerWidth != 'undefined' ? window.outerWidth : document.body.clientWidth;
	var  outerHeight = 	typeof window.outerHeight != 'undefined' ? window.outerHeight : (document.body.clientHeight - 22);
	var  width    = 500;
	var  height   = 280;
	var  left     = parseInt(screenX + ((outerWidth - width) / 2), 10);
	var  top      = parseInt(screenY + ((outerHeight - height) / 2.5), 10);
	var  features = 'width=' + width + ',height=' + height + ',left=' + left + ',top=' + top + ',title=' + 'Twitter login page' + ',background-color:' + '#000000';
	var newwindow = window.open('https://api.twitter.com/oauth/request_token?oauth_callback=' + redirect_url+'&oauth_consumer_key=' + consumer_key, 'Twitter', features);
	if (window.focus) {
		newwindow.focus();
	}
	return false;
}

