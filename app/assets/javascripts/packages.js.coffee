# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

fetchDaysOff = (year, month) ->
  start_date = ''
  url = document.URL + '/package_list/days_off'
  if (year? && month?)
    start_date = new Date(year, month-1, 1)

  $.ajax(
    url:url
    data:{start_date: start_date.format('dd-mm-yyyy')}
    async: false
    success: (data) =>
      $.each(data, (index, value) =>
        for key of value
          window.days_off[key] = value[key]
          false
      )
  )

jQuery ->
  $('distribution_point').change(-> fetchDaysOff())
  $('#calendar').datepicker(
    inline:true
    dateFormat: 'dd-mm-yy'
    defaultDate: 0
    numberOfMonths: [1, 3]
    maxDate: '+2m'
    minDate: '+2d'
    onChangeMonthYear: (year, month) ->
      fetchDaysOff(year, month)
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
#    onSelect: (date) =>
#      dc = $('#dc')[0].value
#      url = '/distribution/points/' + dc + '/package_list/'
#      $.ajax({
#        url:url
#        data: {date : date},
#        dataType: "script"
#      })
  )