window.App = Ember.Application.create({
  LOG_TRANSITIONS: true,
  google: google,
  rootElement: '#container'
})

App.Marker = Ember.Object.extend({})


App.View = Ember.View.extend({
  classNames: ['full-height']
})
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
