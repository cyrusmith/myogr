arr = window.location.href.split("/")
fullurl = arr[0] + "//" + arr[2]
jQuery ->
  $('#distributors').select2
    placeholder: "Выберите закупки для фильтрации"
    width: '500px'
  $('#users').select2
    placeholder: "Поиск по пользователям"
    width: '300px'
  $('.select2').select2
    width: '200px'
#  $('.select2').on('change', ->
#
#  )