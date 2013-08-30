$ ->
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
    street = $('#address').val().replace(/\ /g,'+')
    city = $('#city').val().replace(/\ /g,'+')
    zip = $('#zip').val().replace(/\ /g,'+')
    address = [street,city,'NY',zip].join(',')
    console.log address
    $.ajax({
      url: 'http://maps.googleapis.com/maps/api/geocode/json?address='+address+'&sensor=false' })
        .done (data) ->
          console.log data['results']
          console.log data['results'][0]['address_components']
          console.log data['results'][0]['geometry']

