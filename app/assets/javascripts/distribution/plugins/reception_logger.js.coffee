$('body').on 'barcode:scan', (event)->
  if event.barcode != null
    barcode_data = event.barcode
    username = 'Не привязан'
    username = barcode_data.package_item.username if barcode_data.package_item?
    class_name = 'red' unless event.success
    text = "<tr class='#{class_name}'><td>#{barcode_data.barcode_string}</td><td>#{username}</td></tr>"
  else
    text = "<tr class='red'><td colspan='2'>Некорректный штрих-код</td></tr>"
  $('#reception-log > tbody').prepend(text)