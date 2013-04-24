#window.days_off = {}
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
    inline:true
    dateFormat: 'dd-mm-yy'
    defaultDate: 0
    numberOfMonths: [1, 3]
    maxDate: '+1y'
    minDate: '+1d'
    onChangeMonthYear: (year, month) ->
      fetchDaysOff(year, month)
    beforeShowDay: (date) =>
      if (window.days_off? and window.days_off != {})
        string_date = date.format('yyyy-mm-dd')
        if (window.days_off[string_date])
          return [true, window.days_off[string_date], 'Выходной']
        else
          return [true, '', '']
      else
        return [true, '', '']
    onSelect: (date) =>
      dc = $('#dc')[0].value
      url = '/distribution/points/' + dc + '/package_list/'
      $.ajax({
        url:url
        data: {date : date},
        dataType: "script"
      })
  )