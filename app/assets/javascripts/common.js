// convert all <select> elements	to selectbox
$('select').selectbox();

// Google tracker
var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-30569816-1']);
_gaq.push(['_trackPageview']);
(function() {
  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();

function goto_url(url){ window.location.href = url; }