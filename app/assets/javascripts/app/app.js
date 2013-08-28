window.App = Ember.Application.create({
  LOG_TRANSITIONS: true,
  google: google
})

App.Marker = Ember.Object.extend({})

// router

App.Router.map(function() {

  this.route('map', { path: '/' /*, 
                               init: mapView = App.MapView.create({}) */ })

})

App.MapRoute = Ember.Route.extend({})

App.EndorsementsRoute = Ember.Route.extend({
  model: function() {
    return App.Endorsement.find()
  }
})
