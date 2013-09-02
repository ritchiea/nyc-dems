$ ->
  pinURL = "http://chart.apis.google.com/chart?chst=d_map_pin_letter_withshadow&chld="

  infoBoxOptions = 
    content: $('#endorsement-form').html() 
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
          setEndorsementFormHandler()
          $.ajax({
            type: 'POST'
            url: '/building/?lat='+location.lat+'&lon='+location.lng+'&address='+address[0]+'&hood='+location.hood+'&county='+location.county })
              .done (data) ->
                $(document).find('input[id=endorsement_building_id]').val(data.id)
                #$('input[id=endorsement_building_id]').val(data.id)

  setEndorsementFormHandler = () ->
    $(document).on 'ajax:success', '#new_endorsement', (e, data, status, xhr) ->
      console.log data
      console.log status

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
