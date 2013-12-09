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
};

function fb_share(name, caption, description, link, picture) {
  FB.ui(
  {
   method: 'feed',
   name: name,
   caption: caption,
   description: description,
   link: link,
   picture: picture
  },
  function(response) {
    if (response && response.post_id) {
      alert('Post was published.');
    } else {
      alert('Post was not published.');
    }
  });
};