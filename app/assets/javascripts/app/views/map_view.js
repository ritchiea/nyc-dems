App.MapView = Ember.View.extend({
  // id: 'map-canvas',
  classNames: ['full-height'],
  tagName: 'div',
  // templateName: 'map',

  map: null,

  didInsertElement: function() {
    var pinURL = "http://chart.apis.google.com/chart?chst=d_map_pin_letter_withshadow&chld="

    google.maps.visualRefresh = true
    var mapOptions = {
      center: new google.maps.LatLng(40.714, -74.0064),
       zoom: 13,
       mapTypeId: google.maps.MapTypeId.ROADMAP
     }

    var map = new google.maps.Map(this.$().find('#map-canvas')[0], mapOptions)
  }

})
