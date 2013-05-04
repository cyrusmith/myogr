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
    data:{start_date: dateFormat(start_date, 'dd-mm-yyyy')}
    async: false
    success: (data) =>
      window.days_off = []
      $.each(data, (index, value) =>
        for key of value
          window.days_off[key] = value[key]
          false
      )
  )

jQuery ->
  $('#distribution_point').change(->
    pointId = $(this).val()
    fetchDaysOff(pointId)
    $('#package_date').val('')
    $('#calendar').datepicker('refresh')
  )
  $('#calendar').datepicker(
    altField: "#package_date"
    inline:true
    dateFormat: 'dd-mm-yy'
    numberOfMonths: [1, 3]
    maxDate: '+2m'
    minDate: '+2d'
    beforeShowDay: (date) =>
      if (window.days_off? and window.days_off != {})
        string_date = date.format('yyyy-mm-dd')
        if (window.days_off[string_date])
          style = window.days_off[string_date]
          tip = 'Выходной'
          if style == 'limit-filled'
            tip = 'Лимит записей исчерпан'
          return [false, style, tip ]
        else
          return [true, '', '']
      else
        return [true, '', '']
  )

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
    event.preventDefault()

  $('.remove_custom_tid').click (event) ->
    $(this).parents('tr').remove()
    event.preventDefault()
