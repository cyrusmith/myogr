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
      list = $('table#reception_list>tbody')
      isExist = list.children("tr[item=#{data.package_item.id}]").length > 0
      if (isExist)
        alert('Такая посылка уже находится в списке!')
      else
        list.find('.last_scan').removeClass('last_scan')
        list.prepend("<tr item='#{data.package_item.id}' class='last_scan'>
                        <td>
                          <input type='hidden' name='package_item_id[]' value='#{data.package_item.id}'/>
                          #{data.package_item.username}
                        </td>
                        <td>#{data.barcode_string} </td>
                        <td>#{data.package_item.organizer}</td>
                        <td>#{data.package_item.title} </td>
                      </tr>")
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