$ ->
  pinURL = "http://chart.apis.google.com/chart?chst=d_map_pin_letter_withshadow&chld="
  # this is an ugly hack
  building = {}
  window.intervals = []

  infoBoxOptions = 
    content: $('body').data('form')
    boxStyle:
      backgroundColor: 'rgba(32, 32, 32, 0.5)'

  initialize = () ->
    $('#endorsement-form').remove() 
    google.maps.visualRefresh = true
    mapOptions = 
      center: new google.maps.LatLng(40.7492119, -73.8689525)
      zoom: 13
      mapTypeId: google.maps.MapTypeId.ROADMAP
    window.map = new google.maps.Map(document.getElementById("map-canvas"),mapOptions)

  $(document).on 'ready page:load', () ->
    initialize()

  $(document).on 'click','#add-endorsement', () ->
    $('#address-form-container').fadeIn(300)

  $(document).on 'click', '#find-me', (e) ->
    e.preventDefault()
    address = [
      $('#address').val().replace(/\ /g,'+'),
      $('#city').val().replace(/\ /g,'+'),
      'NY',
      $('#zip').val().replace(/\ /g,'+')]
    $.ajax({
      url: 'http://maps.googleapis.com/maps/api/geocode/json?address='+address.join(',')+'&sensor=false' })
        .done (data) ->
          location = parseResults data.results[0]
          $('#address-form-container').fadeOut(300)
          latlon = new google.maps.LatLng(location.lat, location.lng)
          map.panTo( latlon )
          map.setZoom( window.map.getZoom()+3 )
          marker = createMarker latlon, 'My Home'
          infoWindow = new InfoBox(infoBoxOptions)
          infoWindow.open map, marker
          callBuildingAjax()
          setEndorsementFormHandler()
          false

  setEndorsementFormHandler = () ->
    $(document).on 'ajax:success', '#new_endorsement', (e, data, status, xhr) ->
      clearInterval intervals[0]

  setBuildingID = () ->
    if $('#new_endorsement').length != 0
      $('#new_endorsement input[id=endorsement_building_id]').val(building.id)

  callBuildingAjax = () ->
    $.ajax({
      type: 'POST'
      async: false
      url: '/building/?lat='+location.lat+'&lon='+location.lng+'&address='+address[0]+'&hood='+location.hood+'&county='+location.county })
        .done (data) ->
          building = data
          intervalID = setInterval(setBuildingID, 50)
          intervals << intervalID

  createMarker = (latlon, title) ->
    pinImage = new google.maps.MarkerImage(pinURL+"%E2%80%A2|42C0FB|0D0D0D") 
    new google.maps.Marker
      position: latlon
      map: map
      icon: pinImage,
      title: title

  parseResults = (data) ->
    location =
      hood: data.address_components[2].long_name
      county: data.address_components[5].long_name
      lat: data.geometry.location.lat
      lng: data.geometry.location.lng
