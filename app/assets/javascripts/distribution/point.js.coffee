#window.days_off = {}
fetchDaysOff = (year, month) ->
  start_date = ''
  url = document.URL + '/package_list/days_info'
  if (year? && month?)
    start_date = new Date(year, month-1, 1)

  $.ajax(
    url:url
    data:{start_date: start_date.format('dd-mm-yyyy'), admin_access: true}
    async: false
    success: (data) =>
      $.each(data, (index, value) =>
        for key of value
          window.days_off[key] = value[key]
          false
      )
  )

jQuery ->
  $('input[name*=head_user]').select2
    placeholder: 'Введите имя руководителя'
    width: '300px'
    minimumInputLength: 3
    ajax:
      url: $('input[name*=head_user]').data('autocomplete-source')
      data: (term, page) ->
        term: term,
        page_limit: 10,
        page: page,
      results: (data, page) ->
        results: data

  $("[name*=employee_ids]").select2
    multiple: true
    placeholder: 'Введите имена сотрудников'
    width: '300px'
    minimumInputLength: 3
    ajax:
      url: $('input[name*=employee_ids]').data('autocomplete-source')
      data: (term, page) ->
        term: term,
        page_limit: 10,
        page: page,
      results: (data, page) ->
        results: data

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
        string_date = date.format('isoDate')
        if (window.days_off[string_date])
          return window.days_off[string_date]
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