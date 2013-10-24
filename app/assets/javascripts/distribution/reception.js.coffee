createInfoMarkup = (barcode) ->
  "<p><b>Отправитель:</b> #{barcode.package_item.organizer}</p>
   <p><b>Получатель:</b> #{barcode.package_item.username}</p>
   <p><b>Закупка:</b> #{barcode.package_item.title}</p>
   <p><b>Состояние:</b> #{barcode.package_item.localized_state}</p>
  "

showErrorDialog = (error_message) ->
  playSound('error')
  $('#dialog').html(error_message)
  $('#dialog').dialog(
    title: 'Ошибка'
    resizable: false
    height: 200
    width: 500
    modal: true
    dialogClass: 'alert-dialog'
    buttons:
      'ОК': ->
        $(this).dialog('close')
        $('input[name=barcode]').prop('disabled', false).focus()
  )

playSound = (name) ->
  document.getElementById("#{name}-sound").play();

getPackage = (barcodeInput) ->
  barcodeValue = $(barcodeInput).val();
  $.ajax(
    url: "/distribution/barcodes?barcode_string=#{barcodeValue}"
    dataType: 'json'
    beforeSend: ->
      barcodeInput.val('')
      barcodeInput.prop('disabled', true)
    success: (data) =>
      unless (data)
        showErrorDialog('Данные по введенному штрих-коду не найдены!')
      if data.package_item_id == null
        showErrorDialog('Введенный штрихкод не привязан к отправлению!')
      if (data.package_item.state == 'pending')
        list = $('table#reception_list>tbody')
        isExist = list.children("tr[item=#{data.package_item.id}]").length > 0
        if (isExist)
          showErrorDialog('Такая посылка уже находится в списке!')
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
          countItems = parseInt($('#count-items').text()) + 1
          $('#count-items').text(countItems)
          playSound('confirm')
          barcodeInput.prop('disabled', false).focus()
      else
        playSound('error')
        $('#dialog').html(createInfoMarkup(data))
        $('#dialog').dialog(
          title: 'Информация о посылке'
          resizable: false
          height: 350
          width: 500
          modal: true
          buttons:
            'ОК': ->
              $(this).dialog('close')
              barcodeInput.prop('disabled', false).focus()
        )
  )

jQuery ->
  barcodeInput = $('input[name=barcode]')
  barcodeInput.keypress((event)->
    if (event.keyCode == $.ui.keyCode.ENTER)
      getPackage(barcodeInput)
      event.preventDefault()
  )