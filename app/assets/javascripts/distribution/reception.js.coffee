getPackage = (barcodeInput) ->
  barcodeValue = $(barcodeInput).val();
  $.ajax(
    url: "/distribution/barcodes?barcode_string=#{barcodeValue}&state=pending"
    dataType: 'json'
    beforeSend: ->
      barcodeInput.val('')
      barcodeInput.prop('disabled', true)
    success: (data) =>
      unless (data)
        return alert('Данные по штрих-коду не найдены. Возможно товар уже был принят или не был отмечен организатором как направленный в центра раздач')
      list = $('ul#reception_list')
      distributorInList = list.children("li[distributor=#{data.package_item.item_id}]")
      if (distributorInList[0])
        item = distributorInList.parent().find("li[item=#{data.package_item.id}]")
        if (item[0])
          alert('Такая посылка уже находится в списке!')
        else
          distributorInList.next('ul').append("<li item='#{data.package_item.id}'>
                                                    <input type='hidden' name='package_item_id[]' value='#{data.package_item.id}'/>
                                                      Код: #{data.barcode_string} - #{data.package_item.username}</li>")
      else
        list.append("<li distributor='#{data.package_item.item_id}'>Отправитель:#{data.package_item.organizer} - #{data.package_item.title}</li>
                                     <ul>
                                       <li item='#{data.package_item.id}'>
                                          <input type='hidden' name='package_item_id[]' value='#{data.package_item.id}'/>
                                                  Код: #{data.barcode_string} - #{data.package_item.username}
                                       </li>
                                     </ul>")
    complete: ->
      barcodeInput.prop('disabled', false).focus()
  )

jQuery ->
  barcodeInput = $('input[name=barcode]')
  barcodeInput.keypress((event)->
    if (event.keyCode == $.ui.keyCode.ENTER)
      getPackage(barcodeInput)
      event.preventDefault()
  )