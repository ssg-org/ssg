L.Icon.Default.imagePath = '/assets/images';

var spinnerOpts = {
    lines: 12, // The number of lines to draw
    length: 7, // The length of each line
    width: 4, // The line thickness
    radius: 10, // The radius of the inner circle
    color: '#FFF', // #rgb or #rrggbb
    speed: 1, // Rounds per second
    trail: 60, // Afterglow percentage
    shadow: false, // Whether to render a shadow
    hwaccel: false // Whether to use hardware acceleration
};

// Google tracker
var _gaq = _gaq || [];
_gaq.push(['_setAccount', 'UA-30569816-4']);
_gaq.push(['_setDomainName', 'ulica.ba']);
_gaq.push(['_trackPageview']);
(function() {
  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
})();

function goto_url(url){ window.location.href = url; }

//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
//:::                                                                         :::
//:::  This routine calculates the distance between two points (given the     :::
//:::  latitude/longitude of those points). It is being used to calculate     :::
//:::  the distance between two locations using GeoDataSource (TM) prodducts  :::
//:::                                                                         :::
//:::  Definitions:                                                           :::
//:::    South latitudes are negative, east longitudes are positive           :::
//:::                                                                         :::
//:::  Passed to function:                                                    :::
//:::    lat1, lon1 = Latitude and Longitude of point 1 (in decimal degrees)  :::
//:::    lat2, lon2 = Latitude and Longitude of point 2 (in decimal degrees)  :::
//:::    unit = the unit you desire for results                               :::
//:::           where: 'M' is statute miles                                   :::
//:::                  'K' is kilometers (default)                            :::
//:::                  'N' is nautical miles                                  :::
//:::                                                                         :::
//:::  Worldwide cities and other features databases with latitude longitude  :::
//:::  are available at http://www.geodatasource.com                          :::
//:::                                                                         :::
//:::  For enquiries, please contact sales@geodatasource.com                  :::
//:::                                                                         :::
//:::  Official Web site: http://www.geodatasource.com                        :::
//:::                                                                         :::
//:::               GeoDataSource.com (C) All Rights Reserved 2012            :::
//:::                                                                         :::
//:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

function distance(lat1, lon1, lat2, lon2, unit) {
	var radlat1 = Math.PI * lat1/180
	var radlat2 = Math.PI * lat2/180
	var radlon1 = Math.PI * lon1/180
	var radlon2 = Math.PI * lon2/180
	var theta = lon1-lon2
	var radtheta = Math.PI * theta/180
	var dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta);
	dist = Math.acos(dist)
	dist = dist * 180/Math.PI
	dist = dist * 60 * 1.1515
	if (unit=="K") { dist = dist * 1.609344 }
	if (unit=="N") { dist = dist * 0.8684 }
	// return dist
    // Hack to disable distance validation on creation of issue remove later
    return 0
};

function global_locale_change(e) {
    alert(e);
};

function showLoader() {
    $("#loading").show();
    var target = document.getElementById('loading');
    var spinner = new Spinner(spinnerOpts).spin(target);
}

function hideLoader() {
    $("#loading").hide();
}

function submitForm(form_id_selector) {
	$('#form-error-div ul').empty();
    $('#form-error-div').hide();
        
    $(form_id_selector).submit();
};                                                                    

jQuery.validator.setDefaults({
    onkeyup: false,
    onclick: false,
    errorPlacement: function(error, element) {
    		$('#form-error-div').show();

            var form = $(element).closest('form')[0];
            // Hack since for some reasone required is not working on select
            if (form.id == 'register_form') {
                specialCase();
            }

            if (errorDisplayed(error.text())) {
                return;
            }

    		// add error class to select box
    		if (element.is("select")) {
    			var id_selectbox = '.sbHolder_' + element.attr('id');
    			$(id_selectbox).addClass('error');
    		}

        //error.appendTo(element.prev());
        appendErrorText(error.text());
    }
});

// I am sorry
function specialCase() {
    // Custom handle
    if ($('#city_id').val() == "") {
        var error_text = I18n.t('validation.register.city');
        if (!errorDisplayed(error_text)) {
            appendErrorText(error_text);
        }

        return false;
    }
};

function errorDisplayed(error_text) {
    html = $('#form-error-div ul').html();
    return (html.indexOf(error_text) >= 0)
};

function appendErrorText(error_text) {
    $('#form-error-div ul').append('<li>' + error_text + '</li>');
};

//Format string implementation
if (!String.prototype.format) {
  String.prototype.format = function() {
    var args = arguments;
    return this.replace(/{(\d+)}/g, function(match, number) { 
      return typeof args[number] != 'undefined'
        ? args[number]
        : match
      ;
    });
  };
}


/* autocomplete combobox widget
    #######implement multi language#######*/

    (function( $ ) {
    $.widget( "custom.combobox", {
    _create: function() {
        this.wrapper = $( "<span>" )
        .addClass( "custom-combobox" )
        .insertAfter( this.element );
        this.element.hide();
        this._createAutocomplete();
        this._createShowAllButton();

        this.input.attr("placeholder", "Izaberite grad...");
    },
    _createAutocomplete: function() {
        var selected = this.element.children( ":selected" ),
        value = selected.val() ? selected.text() : "";
        this.input = $( "<input>" )
        .appendTo( this.wrapper )
        .val( value )
        .attr( "title", "" )
        .addClass( "custom-combobox-input ui-widget ui-widget-content ui-state-default ui-corner-left" )
        .autocomplete({
        delay: 0,
        minLength: 0,
        source: $.proxy( this, "_source" )
        })
        .tooltip({
            tooltipClass: "ui-state-highlight"
        });
        this._on( this.input, {
        autocompleteselect: function( event, ui ) {
        ui.item.option.selected = true;
        this._trigger( "select", event, {
        item: ui.item.option
        });
        },
        autocompletechange: "_removeIfInvalid"
        });
    },
    _createShowAllButton: function() {
        var input = this.input,
        wasOpen = false;
        $( "<a>" )
        .attr( "tabIndex", -1 )
        // .attr( "title", "Prikazi sve opstine" )
        .tooltip()
        .appendTo( this.wrapper )
        .button({
            icons: {
            primary: "ui-icon-triangle-1-s"
            },
        text: false
        })
    .removeClass( "ui-corner-all" )
    .addClass( "custom-combobox-toggle ui-corner-right" )
    .mousedown(function() {
        wasOpen = input.autocomplete( "widget" ).is( ":visible" );
        })
    .click(function() {
        input.focus();
// Close if already visible
        if ( wasOpen ) {
        return;
    }
// Pass empty string as value to search for, displaying all results
    input.autocomplete( "search", "" );
        });
    },
    _source: function( request, response ) {
        var matcher = new RegExp( $.ui.autocomplete.escapeRegex(request.term), "i" );
        response( this.element.children( "option" ).map(function() {
        var text = $( this ).text();
        if ( this.value && ( !request.term || matcher.test(text) ) )
        return {
            label: text,
            value: text,
            option: this
        };
    }) );
    },
    _removeIfInvalid: function( event, ui ) {
    // Selected an item, nothing to do
        if ( ui.item ) {
        return;
    }
// Search for a match (case-insensitive)
    var value = this.input.val(),
    valueLowerCase = value.toLowerCase(),
    valid = false;
    this.element.children( "option" ).each(function() {
    if ( $( this ).text().toLowerCase() === valueLowerCase ) {
        this.selected = valid = true;
        return false;
    }
    });
    // Found a match, nothing to do
    if ( valid ) {
        return;
    }
// Remove invalid value
    this.input
    .val( "" )
    .attr( "title", value + " nije poznat grad!" )
    .tooltip( "open" );
    this.element.val( "" );
    this._delay(function() {
    this.input.tooltip( "close" ).attr( "title", "" );
    }, 2500 );
    this.input.data( "ui-autocomplete" ).term = "";
},
_destroy: function() {
    this.wrapper.remove();
    this.element.show();
    }
});
})( jQuery );
$(function() {
    $( "#cmb_city_select" ).combobox({ 
        select: function(ui, option){
            selectCity(option);
        } 
    });
    $( "#toggle" ).click(function() {
    $( "#cmb_city_select" ).toggle();
});
});

/* end of autocomplete combobox widget */
