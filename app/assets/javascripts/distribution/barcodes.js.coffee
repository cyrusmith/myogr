arr = window.location.href.split("/")
fullurl = arr[0] + "//" + arr[2]
jQuery ->
  formatUserSelect = (user) ->
    user.text
  formatUserResult = (user) ->
    '<div>' + user.text + '</div>'
  $('#quantity').change(->
    totalPrice = $(this).val() * $('#barcode_price').val()
    $('#total_price>span').text(totalPrice)
  )

  $('#owner').select2
    placeholder: "Выберите пользователя"
    width: '300px'
    minimumInputLength: 3
    ajax:
      url: fullurl + '/user/find_by_name'
      data: (term, page) ->
        { term: term }
      results: (data, page) ->
        {results: data}
    formatResult: formatUserResult
    formatSelection: formatUserSelect