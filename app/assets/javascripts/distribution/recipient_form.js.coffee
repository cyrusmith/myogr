arr = window.location.href.split("/")
fullurl = arr[0] + "//" + arr[2]

formatSelect = (data) ->
  data.text
formatResult = (data) ->
  '<div>' + data.text + '</div>'

initDropdown = (type) ->
  $('input[type=hidden][name=user_data]').select2('destroy')
  options = []
  if (type == 'document')
    options['placeholder'] = 'Введите номер документа'
    options['url'] = fullurl + '/distribution/packages/find_by_doc'
    options['minimumInputLength'] = 3
  else if (type == 'display_name')
    options['placeholder'] = 'Введите имя пользователя'
    options['url'] = fullurl + '/user/find_by_name'
    options['minimumInputLength'] = 3
  else if(type == 'id')
    options['placeholder'] = 'Введите id пользователя'
    options['url'] = fullurl + '/user/find'
    options['minimumInputLength'] = 1

  $('input[type=hidden][name=user_data]').select2(
    placeholder: options['placeholder']
    width: '300px'
    minimumInputLength: options['minimumInputLength']
    ajax:
      url: options['url']
      data: (term, page) ->
        {
          term: term,
          page_limit: 10,
          page: page,
        }
      results: (data, page) ->
        {results: data}
    formatResult: formatResult
    formatSelection: formatSelect
  )

jQuery ->
  initDropdown($('input[name=data_type]:checked').val())

  $('input[name=data_type]').click(->
    initDropdown($(this).val())
  )

  $('input[type=hidden][name=user_data]').on("change", ->
    $('#recipient_form').submit();
  )