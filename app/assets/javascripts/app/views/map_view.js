App.MapView = Ember.View.extend({
  // id: 'map-canvas',
  classNames: ['full-height'],
  tagName: 'div',
  // templateName: 'map',

  map: null,

  didInsertElement: function() {
    console.log('mapView lol')
    var pinURL = "http://chart.apis.google.com/chart?chst=d_map_pin_letter_withshadow&chld="

    var mapOptions = {
      center: new google.maps.LatLng(40.714, -74.0064),
       zoom: 11,
       mapTypeId: google.maps.MapTypeId.ROADMAP
     }

     console.log(this.$())
     console.log(this.$().find('#map-canvas'))
    var map = new google.maps.Map(this.$().find('#map-canvas')[0], mapOptions)
  }

})
