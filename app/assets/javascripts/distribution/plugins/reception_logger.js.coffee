jQuery ->
  $('body').on('barcode:scan', (event, barcode)->
    if event.success
      text = "<tr><td>#{event.barcode}</td><td>Успех</td></tr>"
    else
      text = "<tr class='red'><td>#{event.barcode}</td><td>Ошибка</td></tr>"
    $('#reception-log > tbody').append(text)
  )
