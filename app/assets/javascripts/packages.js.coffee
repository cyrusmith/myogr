# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

fetchDaysOff = (pointId) ->
  start_date = ''
  arr = window.location.href.split("/")
  full = arr[0] + "//" + arr[2]
  url = full + '/distribution/points/' + pointId + '/package_list/days_off'
  if (year? && month?)
    start_date = new Date(year, month-1, 1)

  $.ajax(
    url:url
    data:{start_date: dateFormat(start_date, 'isoDate')}
#    TODO некрасиво, попробовать ajaxStart
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
  point_element = $('#distribution_point')[0]
  if (point_element.type == 'hidden')
    $('#calendar').show()
  else
    $('#distribution_point').change(->
      pointId = $(this).val()
      fetchDaysOff(pointId)
    )

  package_date = $('#package_date').val()
  $('#calendar').datepicker(
    altField: "#package_date"
    inline:true
    dateFormat: 'yy-mm-dd'
    numberOfMonths: [1, 3]
    defaultDate: package_date if package_date != ''
    maxDate: '+2m'
    minDate: '+2d'
    beforeShowDay: (date) =>
      if (window.days_off? and window.days_off != {})
        string_date = date.format('isoDate')
        if (window.days_off[string_date])
          style = window.days_off[string_date]
          switch style
            when  'limit-filled'
              tip = 'Лимит записей исчерпан'
              return [false, style, tip]
            when 'day-off'
              tip = 'Выходной'
              return [false, style, tip]
            when 'closed'
              tip = 'Запись закрыта'
              return [false, style, tip]
            when 'active-record'
              tip = 'Вы записаны на этот день'
              return [true, style, tip]
            else
              return [false, '', 'Неизвестная ошибка']
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

  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $('#add-custom-topic').click (event) ->
    tid = $(this).prev('input').val().match(/\d{1,10}/gi)[0]
    $.ajax({
      url: $(this).attr('data-source') + '/' + tid
      dataType: "script"
    })
    $('#topic_link').val('')
    event.preventDefault()

  $('.remove_custom_tid').click (event) ->
    $(this).parents('tr').remove()
    event.preventDefault()
