# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->
  initDatepicker()

#  $('#record_record_date').change ->
#    sendCheckTimeRequest()
#  $('ul#employees li input:radio').click ->
#    sendCheckTimeRequest()
#
#  $('ul#procedures li input:checked').addClass('chosen')
#
#  $('ul#procedures li input:checkbox').click ->
#    $(this).parents('ul#procedures li').toggleClass('chosen')
#    disableTooShortTimePeriods()
#
#  $('ul#avaliable_time li input:radio').click ->
#    $(this).parents('ul#avaliable_time li').toggleClass('chosen')
#    full_date = $('#record_record_date').val() + ' ' + $(this).val()
#    $('#record_full_time').val(full_date)
#
#getTotalDuration = ->
#  duration = 0
#  $('ul#procedures li input:checked').each ->
#    duration += parseFloat($(this).attr('data-duration'))
#  return duration
#
#sendCheckTimeRequest = ->
#  employeeId = $('ul#employees li input:checked').val()
#  recordDate = $('#record_record_date').val()
#  duration = getTotalDuration()
#
#  $.get('http://localhost:3000/remote/get_avaliable_time', {'employee' : employeeId, 'date' : recordDate, 'duration': duration}  , (data) ->
#        alert(data)
#        $('li[class^="time"]').removeClass('unactive').removeClass('chosen')
#        $('input[id^="time"]').removeAttr('checked')
#        $('input[id^="time"]').removeAttr('disabled')
#        for time in data
#          li = $('ul#avaliable_time li.time_' + time)
#          li.addClass('unactive')
#
#          radioButton = $('#time_' + time)
#          radioButton.attr('disabled', 'disabled')
#        disableTooShortTimePeriods()
#  )
#
#disableTooShortTimePeriods = ->
#  splitTimePeriod = 0.5
#  numberOfPeriods = getTotalDuration()/splitTimePeriod - 1
#
#  previousElement = null
#  currentElement = null
#  disablePeriod = false
#  i = 0
#  $('li[class^="time"]').reverseEach ->
#    currentElement = $(this)
#    if (previousElement == null || (previousElement.hasClass('unactive') && !currentElement.hasClass('unactive')))
#      disablePeriod = true
#    if (disablePeriod)
#      if (i <= numberOfPeriods)
#          if (previousElement != null)
#            disableTimeElement(previousElement)
#          if (currentElement.prev().text() == "")
#            disableTimeElement(currentElement)
#          i++
#      else
#        disablePeriod = false
#        i = 0
#    previousElement = currentElement
#
#disableTimeElement = (element) ->
#  UNACTIVE_CSS_CLASS = 'unactive'
#  element.addClass(UNACTIVE_CSS_CLASS)
#  element.children('input:radio').attr('disabled', 'disabled')

initDatepicker = ->
  $('#record_record_date').datepicker(
    dateFormat: 'dd-mm-yy'
    defaultDate: 0
    numberOfMonths: [1, 2]
    maxDate: "+1m"
    minDate: 0
  )
#  $('#record_record_date').datepicker("setDate", "0")

