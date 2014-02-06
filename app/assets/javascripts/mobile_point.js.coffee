createPlacemark = (meeting_place, appointments)->
  coords = [meeting_place.location.latitude, meeting_place.location.longitude]
  address = meeting_place.location.street
  baloonContent = "<h1>Точка выдачи: #{address}</h1><p>Место выдачи:#{meeting_place.description}</p>"
  placemarkIcon = 'twirl#greenIcon'
  for key, appointment of appointments
    checked = ''
    if (window.current_appointment? && appointment.id == window.current_appointment.id)
      window.app_found = true
      placemarkIcon =  'twirl#yellowIcon'
      checked = 'checked'
    date = dateFormat(Date.parse(appointment.package_list.schedule.date), 'dayAndMonth')
    from = dateFormat(Date.parse(appointment.from), 'shortTime', true)
    till = dateFormat(Date.parse(appointment.till), 'shortTime', true)
    control = "<input type='radio' name='package[appointment_id]' id='appointment_#{appointment.id}' value='#{appointment.id}' #{checked}/>
                     <label for='appointment_#{appointment.id}'>#{date} с #{from} до #{till}</label>
                     <br/>"
    baloonContent = baloonContent + control
  placemark = new ymaps.Placemark(coords,{
    balloonContent: baloonContent,
    hintContent: address
    clusterCaption: address
  }, {
    preset: placemarkIcon
  })

ymaps.ready ->
  window.app_found = false
  map = new ymaps.Map("map",
    center: [ymaps.geolocation.latitude, ymaps.geolocation.longitude],
    zoom: 11
  )
  map.behaviors.enable(['scrollZoom', 'dblClickZoom'])
  map.controls.add(new ymaps.control.ZoomControl())

  clusterer = new ymaps.Clusterer(
    preset: 'twirl#greenClusterIcons',
    groupByCoordinates: false,
    clusterBalloonContentBodyLayout: 'cluster#balloonAccordionContent'
    clusterDisableClickZoom: true
    gridSize: 128
  )

#  clusterer.events.add('add', (event)->
#    placemark = event.get('child')
#    placemark.options.set({preset: 'twirl#yellowIcon'}) if placemark
#  )

  meeting_places = {}
  for key of window.appointments
    appointment = window.appointments[key]
    meeting_place_id = appointment.meeting_place_id
    unless meeting_places[meeting_place_id]?
      meeting_places[meeting_place_id] = appointment.meeting_place
      meeting_places[meeting_place_id]['appointments'] = []
    meeting_places[meeting_place_id]['appointments'].push appointment


  for place_id, place of meeting_places
    clusterer.add(createPlacemark(place, place.appointments))

#  if (!is_current_found && window.current_appointment?)
#    placemark = new ymaps.Placemark(coords,{
#      balloonContent: baloonContent,
#      hintContent: place.location.street
#      clusterCaption: place.location.street
#    }, {
#      preset: placemarkIcon
#    })
#    clusterer.add(placemark)
  if window.current_appointment? && !app_found
    clusterer.add(createPlacemark(window.current_appointment.meeting_place, [window.current_appointment]))
  map.geoObjects.add(clusterer)
#  for key of window.appointments
#    appointment = window.appointments[key]
#    meeting_place_id = appointment.meeting_place_id
#    if meeting_place_id not in marked_places
#      coords = [appointment.meeting_place.location.latitude, appointment.meeting_place.location.longitude]
#      placemark = new ymaps.Placemark(coords,{
#          iconContent: '1',
#          balloonContent: '<input type="radio" name="yandex" value="1" /><br/><input type="radio" name="yandex" value="2" />',
#          hintContent: 'Стандартный значок метки'
#        }, {
#          preset: 'twirl#greenIcon'
#        })
#
#    geoObjects.push placemark



jQuery ->
  $('a.pick_next_time').bind("ajax:success", (data, status, xhr)->
    $(this).parents('tr').fadeOut()
  )

  $('#krutilka').krutilka
    size: 64
    petals: 15
    petalWidth: 4
    petalLength: 16
    time: 2500
  $('#krutilka').trigger('hide')