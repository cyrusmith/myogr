# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

fetchDaysInfo = (pointId) ->
  start_date = ''
  arr = window.location.href.split("/")
  fullurl = arr[0] + "//" + arr[2]
  points_controller_url = fullurl + '/distribution/points/' + pointId
  url = points_controller_url + '/package_list/days_info'
  if (year? && month?)
    start_date = new Date(year, month-1, 1)
  $.ajax(
    url: points_controller_url + '.json'
    success: (data) =>
      $('p.work-schedule').html(data['work_schedule'])
  )
  $.ajax(
    url:url
    data:{start_date: dateFormat(start_date, 'isoDate')}
    beforeSend: ->
      $('#calendar').slideDown()
      $('#calendar-loading').show()
      $('#krutilka').trigger('show')
    success: (data) =>
      window.days_off = []
      $.each(data, (index, value) =>
        for key of value
          window.days_off[key] = value[key]
          false
      )
      $('#calendar').datepicker('refresh')
    complete: ->
      $('#calendar').datepicker('setDate', getDefaultDate())
      $('#krutilka').trigger('hide')
      $('#calendar-loading').hide()
  )

isValid = (date) ->
  if (window.days_off? and window.days_off != {})
    string_date = date.format('isoDate')
    if (window.days_off[string_date] and window.days_off[string_date] != 'active-record')
      return false
  return true

getDefaultDate = ->
  package_date = $('#package_date').val()
  date = new Date()
  date = new Date (Date.parse(package_date)) if package_date != ''

  while(!isValid(date))
    date.setDate(date.getDate()+1)
  return date

jQuery ->
  $('a.pick_next_time').bind("ajax:success", (data, status, xhr)->
    $(this).parents('tr').fadeOut()
  )

  point_element = $('#distribution_point')[0]
  if point_element? and point_element.type == 'hidden'
    $('#calendar').show()
  else
    $('#distribution_point').change(->
      pointId = $(this).val()
      fetchDaysInfo(pointId)
    )

  package_date = $('#package_date').val()
  $('#calendar').datepicker(
    altField: "#package_date"
    inline:true
    dateFormat: 'yy-mm-dd'
    numberOfMonths: [1, 3]
    defaultDate: package_date if package_date != ''
    maxDate: '+2m'
    minDate: '0'
    beforeShowDay: (date) =>
      if (window.days_off? and window.days_off != {})
        string_date = date.format('isoDate')
        if (window.days_off[string_date])
          return window.days_off[string_date]
        else
          return [true, '', '']
      else
        return [true, '', '']
    onSelect: (date) =>
      $('input:submit').removeAttr('disabled').removeClass('disabled')
  )

  $('#krutilka').krutilka
    size: 64
    petals: 15
    petalWidth: 4
    petalLength: 16
    time: 2500
  $('#krutilka').trigger('hide')
