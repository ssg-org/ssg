L.Icon.Default.imagePath = '/assets/images';


// convert all <select> elements    to selectbox
//$('select').selectbox();

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

function submitForm(form_id_selector) {
$('#form-error-div ul').empty();
    $('#form-error-div').hide();
return $(form_id_selector).submit();
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

        // Hide message
        setTimeout(function() {
            $("#form-error-div").hide('fade', {}, 1000)
        }, 1500);
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
