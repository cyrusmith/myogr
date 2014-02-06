
ymaps.ready ->
  map = new ymaps.Map("map",
    center: [ymaps.geolocation.latitude, ymaps.geolocation.longitude],
    zoom: 13
  )
  map.behaviors.enable(['scrollZoom', 'dblClickZoom'])
  searchControl = new ymaps.control.SearchControl(useMapBounds:true)
  map.controls.add(searchControl)
  map.controls.add(new ymaps.control.ZoomControl())

  searchControl.events.add('resultselect', (event)->
    geoObjectsArr = searchControl.getResultsArray()
    selectedResultIndex = event.get('resultIndex')
    currentObject = geoObjectsArr[selectedResultIndex]
    coords = currentObject.geometry.getCoordinates()
    $('#distribution_meeting_place_location_attributes_latitude').val(coords[0])
    $('#distribution_meeting_place_location_attributes_longitude').val(coords[1])
  )

  map.events.add('click', (event) ->
    coords = event.get('coordPosition')
    $('#distribution_meeting_place_location_attributes_latitude').val(coords[0])
    $('#distribution_meeting_place_location_attributes_longitude').val(coords[1])
  )