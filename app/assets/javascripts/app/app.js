window.App = Ember.Application.create({
  LOG_TRANSITIONS: true,
  google: google,
  rootElement: '#container'
})

App.Marker = Ember.Object.extend({})

// router

App.Router.map(function() {
  this.route('map', { path: '/' })
})

App.MapRoute = Ember.Route.extend({
  events: {
    addEndorsement: function() { this.controller.set('showAddressForm', true); }
  }
})

App.MapController = Ember.Controller.extend({ 
  showAddressForm: false
})

App.EndorsementsRoute = Ember.Route.extend({
  model: function() {
    return App.Endorsement.find()
  }
})
