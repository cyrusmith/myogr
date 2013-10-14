arr = window.location.href.split("/")
fullurl = arr[0] + "//" + arr[2]

jQuery ->
  $('.select_user_by_name').select2(
    placeholder: 'Введите имя пользователя'
    width: '300px'
    minimumInputLength: 3
    ajax:
      url: fullurl + '/user/find_by_name'
      data: (term, page) ->
        {
        term: term,
        page_limit: 10,
        page: page,
        }
      results: (data, page) ->
        {results: data}
    formatResult: (data) ->
      data.text
    formatSelection: (data) ->
      '<div>' + data.text + '</div>'
  )

  $("#fast-action-menu .tab").click( ->
    windowName = $(this).attr('data-window')
    $("##{windowName}").animate({width: 'toggle'}, 500)
  )