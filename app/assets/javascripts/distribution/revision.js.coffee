arr = window.location.href.split("/")
fullurl = arr[0] + "//" + arr[2]

formatUserSelect = (user) ->
  user.username
formatUserResult = (user) ->
  '<div>' + user.username + '</div>'
jQuery ->
    $('.barcode_select').select2
    placeholder: "Выберите штрих-код"
    width: '200px'
    data: { results: window.revisionBarcodes}

    $('.sender_select').select2
      placeholder: "Выберите отправителя"
      width: '300px'
      minimumInputLength: 3
      ajax:
        url: fullurl + '/user/find'
        data: (term, page) ->
          { term: term }
        results: (data, page) ->
          {results: data}
      formatResult: formatUserResult
      formatSelection: formatUserSelect

    $('.reciever_select').select2
      placeholder: "Выберите получателя"
      width: '300px'
      minimumInputLength: 3
      ajax:
        url: fullurl + '/user/find'
        data: (term, page) ->
          { term: term }
        results: (data, page) ->
          {results: data}
      formatResult: formatUserResult
      formatSelection: formatUserSelect

#  $('#add_row').click(->
#    newRow = $('.revision_row').first().clone()
#    $('#revision_data').append(newRow)
#    initSelects(result)
#  )