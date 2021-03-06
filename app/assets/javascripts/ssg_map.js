(function( $ ) {

var methods = {
	init : function( options ) { 
		var $this = $(this);
    var data = $this.data('ssg_map');

      // first time initialize
		var map = new L.Map($this.attr('id'), data.opts.map_options);
		var googleRoads = new L.Google('ROADMAP', data.opts.map_options);
		var googleSatelite = new L.Google('SATELLITE', data.opts.map_options);

		map.addLayer(googleRoads);
		
		map.addControl(new L.Control.Layers( {'Google':googleRoads, 'Google Satellite':googleSatelite}, {}));

		map.setView(new L.LatLng(data.opts.lat, data.opts.lng), data.opts.zoom);	

		// Commented this for load on drag/zoom
		// if (data.opts.zoomend) { map.on("zoomend", 	data.opts.zoomend); }
		// if (data.opts.dragend) { map.on("dragend", 	data.opts.dragend); }

		if (data.opts.click)   { map.on("click", 		data.opts.click); }

		data.map = map;

		$this.data('ssg_map', data);
	},
	setView : function(lat, lng, zoom) {
		var $this = $(this);
		var data = $this.data('ssg_map');
		data.map.setView(new L.LatLng(lat, lng), zoom);	
	},
	getBounds : function() {
		return $(this).data('ssg_map').map.getBounds();
	},
	drawIssue : function(opts) {
		var $this = $(this);
		var data = $this.data('ssg_map');
		var htmlMarkup = '';

		var marker = L.marker([ opts.lat, opts.lng ]);

		if (opts.icon) {
			marker.setIcon(opts.icon);
		}

		if (opts.title) {
      popup =   "<div class='clearfix' style='min-width: 200px;'>";
      popup +=    "<img src={0} style='width:100%'>".format(opts.image_url);
      popup +=    "<div class='info'><b><a href='" + opts.issue_url + "' style='color:black'>{0}</a></b><br>{1}".format(opts.title, opts.description);
      popup +=  "</div>";
			marker.bindPopup(popup);
		}

		marker.addTo(data.map);
	}
};


$.fn.SSGMap = function(method) {

	// Method calling logic
	if ( methods[method] ) {		
		return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
	} else if ( typeof method === 'object' || ! method ) {
		var defaults = {
			// leaflet map options
	      map_options        : { 
	      	scrollWheelZoom : false 
	      }
	   };
		var $this = $(this);
		var opts = $.extend(defaults, method);
		//console.log(opts);
		$this.data('ssg_map', { opts : opts });


		return methods.init.apply(this, [opts]);
	} else {
		$.error( 'Method ' +  method + ' does not exist on jQuery.tooltip' );
	}      
};

})( jQuery );
