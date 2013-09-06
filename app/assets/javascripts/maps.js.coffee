$ ->
  _.templateSettings =
    interpolate : /\{\{(.+?)\}\}/g

  pinURL = "http://chart.apis.google.com/chart?chst=d_map_pin_letter_withshadow&chld="
  # this is for an ugly hack because the dom fails to update in time for ajax to set building_id
  # argh!
  intervals = []
  markers = []
  ERROR = 'Sorry there was an error with your submission, please try again'
  MOBILE = ''

  infoBoxOptions =
    boxStyle:
      backgroundColor: 'rgba(32, 32, 32, .75)'
      width: '450px'
      color: 'rgb(235, 235, 235)'
      overflowY: 'scroll'
      maxHeight: '440px'
    pixelOffset: new google.maps.Size(-140, 0)
    zIndex: null
    closeBoxMargin: "5px 5px 5px 5px"
    closeBoxURL: "/assets/close.png"
    infoBoxClearance: new google.maps.Size(1, 1)
    isHidden: false
    pane: "floatPane"

  infoBox = new InfoBox(infoBoxOptions)

  initialize = () ->
    google.maps.visualRefresh = true
    mapOptions =
      center: new google.maps.LatLng(40.749728, -73.914484)
      zoom: 12
      scrollwheel: false
      mapTypeId: google.maps.MapTypeId.ROADMAP
    window.map = new google.maps.Map(document.getElementById("map-canvas"),mapOptions)
    placeMarkers(window.buildings)
    delayInterval 3000, updateMap
    false

  $(document).on 'ready page:load', () ->
    initialize()
    if $('body').width() < 481
      MOBILE = true
      infoBoxOptions.boxStyle.width = '320px'

  $(document).ajaxComplete (e, xhr, settings) ->
    if xhr.status is 200 and settings.url is "/edit_endorsement/"
      $('#edit-endorsement').fadeOut(300)
      $editForm = $('#edit-endorsement-form-container')
      $editForm.empty().append('<p class="success">Success!</p>')
      setDelay 2000, () ->
        $editForm.remove()

  $(document).on 'click','.close', (e) ->
    e.preventDefault()
    $(@).parent().fadeToggle(300)

  $(document).on 'click','#about-button', (e) ->
    e.preventDefault()
    $('#about').fadeIn(300)

  $(document).on 'click','#add-endorsement', () ->
    removeClutter() if MOBILE is true
    $('#address-form-container').fadeIn(300)

  $(document).on 'click','#edit-endorsement', () ->
    $('#edit-endorsement-form-container').fadeIn(300)

  $(document).on 'click', '#find-me', (e) ->
    e.preventDefault()
    address = [
      $('#address').val().replace(/\ /g,'+'),
      $('#city').val().replace(/\ /g,'+'),
      'NY',
      $('#zip').val().replace(/\ /g,'+')].join(',')
    $.ajax({
      url: 'http://maps.googleapis.com/maps/api/geocode/json?address='+address+'&sensor=false' })
        .done (data) ->
          if data.status is "REQUEST_DENIED"
            showAddressErrorMessage()
            return false
          location = parseResults data.results[0]
          $('#address-form-container').fadeOut(300)
          latlon = new google.maps.LatLng(location.lat, location.lng)
          $('#about').fadeOut(300) if $('#about').css('display') isnt 'none'
          map.panTo( latlon )
          map.setZoom( window.map.getZoom()+5 ) if map.getZoom() isnt 17
          if getMarker(latlon) is undefined
            marker = createMarker latlon, 'My Building'
          else
            marker = getMarker(latlon)
          callBuildingAjax location, marker
          infoBox.setContent $('body').data('form')
          infoBox.open map, marker
          setEndorsementFormHandler marker
          false
        .fail () ->
          alert ERROR


  showAddressErrorMessage = () ->
    if $('.red').length == 0
      $('p.comfort-text').prepend('<span class="red">There was an error finding your address. Please make sure you did not include an apartment or unit number</span></br></br>')

  getMarker = (latlon) ->
    for marker in markers
      if marker.position is latlon
        return marker

  callBuildingAjax = (location, marker) ->
    $.ajax({
      type: 'POST'
      url: '/building/?lat='+location.lat+'&lon='+location.lng+'&address='+location.address+'&hood='+location.hood+'&county='+location.county })
        .done (data) ->
          building = data
          marker.building_id = building.id
          intervalID = delayInterval 10, () ->
            do (building = building) ->
              if $('#new_endorsement').length != 0
                $('#new_endorsement input[id=endorsement_building_id]').val(building.id)
                clearInterval intervals[0]
              false
          intervals.push(intervalID)
          false
        .fail () ->
          alert ERROR

  placeMarkers = (buildings) ->
    for building in buildings
      do (building) ->
        building = JSON.parse(building)
        pinImage = new google.maps.MarkerImage(pinURL+"%E2%80%A2|"+candidateColor(building.favorite_candidate)+"|0D0D0D")
        marker = new google.maps.Marker
          position: new google.maps.LatLng(building.lat, building.lng)
          map: window.map
          icon: pinImage
          title: building.address
          visible: true
          building_id: building.id
        markers.push marker
        setMarkerClickEvent marker
    false

  candidateColor = (fave) ->
    switch fave
      when 1 then 'A52A2A'
      when 2 then '42C0FB'
      when 3 then '68228B'
      when 4 then 'B2B200'
      when 5 then '458B00'
      else 'CCCCCC'

  setMarkerClickEvent = (marker) ->
    google.maps.event.addListener marker, 'click', ->
      $.ajax({
        url: '/get_endorsements/?building_id='+marker.building_id })
          .done (data) ->
            compile = _.template($('#endorsement-show').html())
            $votes = $('<div></div>')
            for endorsement in data
              $votes.append compile(endorsement)
            boxText = document.createElement("div")
            boxText.className = 'endorsements-container'
            buildingCompile = _.template($('#building-show').html())
            boxText.innerHTML = ( buildingCompile(marker) + $votes.html() )
            if MOBILE is true
              removeClutter()
            infoBox.setContent boxText
            infoBox.open map, marker
        .fail () ->
          alert 'Sorry there was an error loading endorsements from the server, please try again'

  removeClutter = () ->
    $('#header').remove()
    $('#about-button').remove()
    $('#about').remove()
    $('#edit-endorsement').remove()
    $('#add-endorsement').remove()

  delayInterval = (ms, func) ->
    setInterval func, ms

  setDelay = (ms, func) ->
    setTimeout func, ms

  setEndorsementFormHandler = (marker) ->
    $(document).on 'ajax:success', '#new_endorsement', (e, data, status, xhr) ->
      $.cookie "voted", 'true', { expires: 7, path: '/' }
      $('#add-endorsement').fadeOut(300) if $('#add-endorsement').css('display') isnt 'none'
      $('#endorsement-form-container').empty().append('<p class="success">Endorsement saved!</p>')
      setDelay 2000, () ->
        infoBox.close()
      setMarkerClickEvent marker

  updateMap = () ->
    $.ajax({
      url: '/get_buildings/' })
        .done (data) ->
          for marker in markers
            do (marker = marker) ->
              marker.setMap null
          placeMarkers(data)

  createMarker = (latlon, title) ->
    pinImage = new google.maps.MarkerImage(pinURL+"%E2%80%A2|CCCCCC|0D0D0D")
    new google.maps.Marker
      position: latlon
      map: map
      icon: pinImage
      title: title

  parseResults = (data) ->
    location =
      address: data.formatted_address.split(',')[0]
      hood: data.address_components[2].long_name
      county: data.address_components[5].long_name
      lat: data.geometry.location.lat
      lng: data.geometry.location.lng
