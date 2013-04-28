# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
#  sendTimeRequest()
  $('#record_dates input:radio:last').datepicker(
    showOn: 'focus'
    dateFormat: 'dd-mm-yy'
    defaultDate: 0
    numberOfMonths: [1, 2]
    maxDate: '+1m'
    minDate: '+3d'
    onClose: (date) ->
      dateObject = $.datepicker.parseDate('dd-mm-yy', date)
      $(this).next().text($.datepicker.formatDate('DD, d MM', dateObject))
      sendTimeRequest()
  )

  $('#record_dates input:checked').each ->
    $(this).removeAttr('checked')

  $('#record_record_date').change ->
    sendTimeRequest()
    
  $('ul#procedures li input:radio').click ->
    sendTimeRequest()
    
  $('ul#employees li input:radio').click ->
    sendTimeRequest()
#
#  $('ul#procedures li input:checked').addClass('chosen')
#
#  $('ul#procedures li input:checkbox').click ->
#    $(this).parents('ul#procedures li').toggleClass('chosen')
#    sendTimeRequest()

  $('#avaliable_time input:radio').click ->
    sumbitButton = $('input#submit')
    if isReadyForSubmission()
      time = $(this).attr("time")
      full_date = $('#record_dates input:checked').val() + ' ' + time.slice(0,2) + ":" + time.slice(2,4)
      $('#record_full_time').val(full_date)
      sumbitButton.removeAttr('disabled')
    else
      sumbitButton.attr('disabled', 'disabled')

  $('#record_dates input:radio:not(:last)').click ->
    sendTimeRequest()

#    disableTooShortTimePeriods()
#
#  $('ul#avaliable_time li input:radio').click ->
#    $(this).parents('ul#avaliable_time li').toggleClass('chosen')
#
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
disableTooShortTimePeriods = ->
  splitTimePeriod = 0.5
  numberOfPeriods = getTotalDuration()/splitTimePeriod - 1

  previousElement = null
  currentElement = null
  disablePeriod = false
  i = 0
  $('li[class^="time"]').reverseEach ->
    currentElement = $(this)
    if (previousElement == null || (previousElement.hasClass('unactive') && !currentElement.hasClass('unactive')))
      disablePeriod = true
    if (disablePeriod)
      if (i <= numberOfPeriods)
          if (previousElement != null)
            disableTimeElement(previousElement)
          if (currentElement.prev().text() == "")
            disableTimeElement(currentElement)
          i++
      else
        disablePeriod = false
        i = 0
    previousElement = currentElement

disableTimeElement = (element) ->
  UNACTIVE_CSS_CLASS = 'unactive'
  element.addClass(UNACTIVE_CSS_CLASS)
  element.children('input:radio').attr('disabled', 'disabled')

initDatepicker = ->
  $('#record_dates input:radio:last').datepicker(
    showOn: 'focus'
    dateFormat: 'dd-mm-yy'
    defaultDate: 0
    numberOfMonths: [1, 2]
    maxDate: '+1m'
    minDate: '+3d'
    onClose: (date) ->
      dateObject = $.datepicker.parseDate('dd-mm-yy', date)
      $(this).next().text($.datepicker.formatDate('DD, d MM', dateObject))
      sendTimeRequest()
  )

sendTimeRequest = ->
#  if (isReadyForTimeRequest())
    employeeId = $('ul#employees li input:checked').val()
    recordDate = $('#record_dates input:checked').val()
    duration = getTotalDuration()#
    $.get('http://localhost:3000/remote/get_avaliable_time', {'employee' : employeeId, 'date' : recordDate, 'duration': duration}  , (data) ->
#          alert(data)
#          $('li[class^="time"]').addClass('unactive').removeClass('chosen').find('label').addClass('disabled')
          $('input[class="time"]').removeAttr('checked').attr('disabled', 'disabled')
#          $('label[class="time"]').addClass('unactive')
          splitTimePeriod = 0.5
          numberOfPeriods = getTotalDuration()/splitTimePeriod - 1
          for time_period in data
#            alert("time_period.length = " + time_period.length + ", numberOfPeriods = " + numberOfPeriods) 
            if time_period.length > numberOfPeriods
              new_length = time_period.length - numberOfPeriods
              new_time_period = time_period[0...new_length]
              for time in new_time_period
#                alert(time)
#                li = $('table#avaliable_time li.time_' + time)
#                li.removeClass('unactive').addClass('active').find('label').removeClass('disabled')
                radioButton = $('input[class="time"][time="'+time+'"]')
                radioButton.removeAttr('disabled', 'disabled') 
#                $('label[time="'+time+'"]').removeClass('unactive')
#                alert($('label[time="'+time+'"]'))
          $('#avaliable_time').show()
          disableTooShortTimePeriods()
    )

isReadyForTimeRequest = ->
  $('#procedures input:checked').size() > 0 && $('#record_dates input:checked').size() > 0 && $('#employees input:checked').size() > 0

isReadyForSubmission = ->
  isReadyForTimeRequest() && $('#avaliable_time input:checked').size() > 0

getTotalDuration = ->
  duration = 0
  $('ul#procedures li input:checked').each ->
    duration += parseFloat($(this).attr('duration'))
  return duration


