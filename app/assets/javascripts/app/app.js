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

// App.AddButton = Ember.Object.extend(Ember.Evented, {

App.MapRoute = Ember.Route.extend({
  events: {
    addEndorsement: function() { console.log('omglol'); }
  }
})

App.EndorsementsRoute = Ember.Route.extend({
  model: function() {
    return App.Endorsement.find()
  }
})
