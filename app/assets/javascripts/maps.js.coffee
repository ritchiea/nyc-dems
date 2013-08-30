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

  $('#add-endorsement').on 'click', () ->
    $('#address-form-container').fadeIn(300)
