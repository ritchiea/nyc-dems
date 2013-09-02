$ ->
  pinURL = "http://chart.apis.google.com/chart?chst=d_map_pin_letter_withshadow&chld="

  initialize = () ->
    google.maps.visualRefresh = true
    mapOptions = 
      center: new google.maps.LatLng(40.714, -74.0064)
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
      $('#zip').val().replace(/\ /g,'+')].join(',')
    $.ajax({
      url: 'http://maps.googleapis.com/maps/api/geocode/json?address='+address+'&sensor=false' })
        .done (data) ->
          location = parseResults data.results[0]
          $('#address-form-container').fadeOut(300)
          address = new google.maps.LatLng(location.lat, location.lng)
          window.map.panTo( address )
          window.map.setZoom( window.map.getZoom()+3 )
          marker = createMarker address, 'My Home'
          infoWindow = createFormWindow()
          infoWindow.open map, marker

  createFormWindow = () ->
    new google.maps.InfoWindow({
      content: $('#endorsement-form').html() })

  createMarker = (address, title) ->
    pinImage = new google.maps.MarkerImage(pinURL+"%E2%80%A2|42C0FB|0D0D0D") 
    marker = new google.maps.Marker({
      position: address
      map: map
      icon: pinImage,
      title: title })

  parseResults = (data) ->
    location =
      hood: data.address_components[2].long_name
      county: data.address_components[5].long_name
      lat: data.geometry.location.lat
      lng: data.geometry.location.lng
