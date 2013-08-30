$ ->
  initialize = () ->
    google.maps.visualRefresh = true
    mapOptions = 
      center: new google.maps.LatLng(40.714, -74.0064)
      zoom: 13
      mapTypeId: google.maps.MapTypeId.ROADMAP
    window.map = new google.maps.Map(document.getElementById("map-canvas"),mapOptions)

#  loadScript = () ->
#    script = document.createElement('script')
#    script.type = "text/javascript"
#    script.src = "http://maps.googleapis.com/maps/api/js?key="+$('body').data('maps')+"&sensor=false&callback=initialize"
#    document.body.appendChild(script)
    
  $(document).on 'ready page:load', () ->
    initialize()

  $(document).on 'click','#add-endorsement', () ->
    $('#address-form-container').fadeIn(300)

  $(document).on 'click', '#find-me', (e) ->
    e.preventDefault()
    street = $('#address').val().replace(/\ /g,'+')
    city = $('#city').val().replace(/\ /g,'+')
    zip = $('#zip').val().replace(/\ /g,'+')
    address = [street,city,'NY',zip].join(',')
    $.ajax({
      url: 'http://maps.googleapis.com/maps/api/geocode/json?address='+address+'&sensor=false' })
        .done (data) ->
          location = parseResults data.results[0]
          window.map.panTo( new google.maps.LatLng(location.lat, location.lng) )
          window.map.setZoom( window.map.getZoom()+2 )

  parseResults = (data) ->
    location =
      hood: data.address_components[2].long_name
      county: data.address_components[5].long_name
      lat: data.geometry.location.lat
      lng: data.geometry.location.lng
