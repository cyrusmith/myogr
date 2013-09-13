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
  else if (type == 'id')
    options['placeholder'] = 'Введите пользователя'
    options['url'] = fullurl + '/user/find'
  else
    options['placeholder'] = ''
    options['url'] = ''

  $('input[type=hidden][name=user_data]').select2(
    placeholder: options['placeholder']
    width: '300px'
    minimumInputLength: 3
    ajax:
      url: options['url']
      data: (term, page) ->
        { term: term }
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