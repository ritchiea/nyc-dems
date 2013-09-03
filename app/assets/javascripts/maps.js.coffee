$ ->
  pinURL = "http://chart.apis.google.com/chart?chst=d_map_pin_letter_withshadow&chld="
  # this is for an ugly hack because the dom fails to update in time for ajax to set building_id
  intervals = []

  infoBoxOptions =
    boxStyle:
      backgroundColor: 'rgb(32, 32, 32)'
      opacity: 0.5
      width: '280px'
      color: 'rgb(235, 235, 235)'
      overflowY: 'scroll'
      maxHeight: '300px'
    pixelOffset: new google.maps.Size(-140, -100)
    zIndex: null
    #closeBoxMargin: "10px 2px 2px 2px"
    infoBoxClearance: new google.maps.Size(1, 1)
    isHidden: false
    pane: "floatPane"

  infoBox = new InfoBox(infoBoxOptions)

  initialize = () ->
    google.maps.visualRefresh = true
    mapOptions =
      center: new google.maps.LatLng(40.7492119, -73.8689525)
      zoom: 13
      mapTypeId: google.maps.MapTypeId.ROADMAP
    window.map = new google.maps.Map(document.getElementById("map-canvas"),mapOptions)
    placeMarkers()
    false

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
          callBuildingAjax location, address
          infoBox.setContent $('body').data('form')
          infoBox.open map, marker
          setEndorsementFormHandler()
          false

  callBuildingAjax = (location, address) ->
    $.ajax({
      type: 'POST'
      url: '/building/?lat='+location.lat+'&lon='+location.lng+'&address='+address[0]+'&hood='+location.hood+'&county='+location.county })
        .done (data) ->
          building = data
          intervalID = delayInterval 50, () ->
            do (building = building) ->
              if $('#new_endorsement').length != 0
                $('#new_endorsement input[id=endorsement_building_id]').val(building.id)
                clearInterval intervals[0]
              false
          intervals.push(intervalID)
          false

  placeMarkers = () ->
    for building in window.buildings
      do (building) ->
        building = JSON.parse(building)
        pinImage = new google.maps.MarkerImage(pinURL+"%E2%80%A2|42C0FB|0D0D0D")
        marker = new google.maps.Marker
          position: new google.maps.LatLng(building.lat, building.lng)
          map: window.map
          icon: pinImage
          title: building.address
          visible: true
          building_id: building.id
        google.maps.event.addListener marker, 'click', ->
          infoBox.setContent marker.title
          infoBox.open map, @
          console.log marker.building_id
          console.log @
          $.ajax({
            url: '/get_endorsements/?building_id='+marker.building_id })
              .done (data) ->
                console.log data
    false

  delayInterval = (ms, func) ->
    setInterval func, ms

  setEndorsementFormHandler = () ->
    $(document).on 'ajax:success', '#new_endorsement', (e, data, status, xhr) ->
      infoWindow.close()

  setBuildingID = () ->
    if $('#new_endorsement').length != 0
      $('#new_endorsement input[id=endorsement_building_id]').val(building.id)
      clearInterval intervals[0]

  createMarker = (latlon, title) ->
    pinImage = new google.maps.MarkerImage(pinURL+"%E2%80%A2|42C0FB|0D0D0D")
    new google.maps.Marker
      position: latlon
      map: map
      icon: pinImage
      title: title

  parseResults = (data) ->
    location =
      hood: data.address_components[2].long_name
      county: data.address_components[5].long_name
      lat: data.geometry.location.lat
      lng: data.geometry.location.lng
