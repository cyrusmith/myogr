window.days_off = []
window.is_init = false

fetchDaysOff = (year, month) ->
  start_date = ''
  if (year? && month?)
    start_date = new Date(year, month, 1)
  $.getJSON('/distribution/package_lists/days_off', {start_date: start_date}, (data) =>
    $.each(data, (index, value) =>
      window.days_off.push(value)))

jQuery ->
  $('#distribution_point_head_name').autocomplete
    minLength: 3
    source: $('#distribution_point_head_name').data('autocomplete-source')

  split = (val) ->
    val.split(/,\s*/)

  extractLast = (term) ->
    split(term).pop()

  $("#distribution_point_employees_names").bind("keydown",(event) =>
    if ( event.keyCode == $.ui.keyCode.TAB && $(this).data("ui-autocomplete").menu.active )
      event.preventDefault
  ).autocomplete
#    source: $('#distribution_center_distribution_center_employees_names').data('autocomplete-source')
    source: (request, response) =>
      url = $('#distribution_point_employees_names').data('autocomplete-source')
      $.getJSON(url, {
        term: extractLast(request.term)
      }, response);
    search: ->
      term = extractLast(this.value);
      if ( term.length < 3 )
        false
    focus: =>
      false
    select: (event, ui) ->
      terms = split(this.value)
      terms.pop()
      terms.push(ui.item.value)
      terms.push("")
      this.value = terms.join(", ")
      false

  $('#calendar').datepicker(
    inline: true
    dateFormat: 'dd-mm-yy'
    defaultDate: 0
    numberOfMonths: [1, 3]
    maxDate: '+1y'
    minDate: '+1d'
    onChangeMonthYear: (year, month) =>
      fetchDaysOff(year, month)
    beforeShowDay: (date) =>
      if (!window.is_init)
        fetchDaysOff()
        window.is_init = true
      if (window.days_off.length > 0)
        for day_off in days_off
          if (date.getTime() == new Date().getTime())
            return [true, "day_off", 'Выходной']
          else
            return [true, '', '']
      else
        return [true, '', '']
#    onSelect: (date) =>
#      dc = $('#dc')[0].value
#      url = '/distribution/points/' + dc + '/package_list/'
#      $.getJSON(url,
#        {date: date}, (response) =>
#          $('#day_properties').append(response)
#      )
    onSelect: (date) =>
      dc = $('#dc')[0].value
      url = '/distribution/points/' + dc + '/package_list/'
      $.ajax({
        url:url
        data: {date : date},
        dataType: "script"
      })
  )



