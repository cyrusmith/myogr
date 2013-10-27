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
    focus: ->
      $('.ui-dialog :button').blur();
    buttons:
      'ОК': ->
        $(this).dialog('close')
    close: ->
      $('input[name=barcode]').prop('disabled', false).focus()
  )
  $('#dialog').focus()

playSound = (name) ->
  document.getElementById("#{name}-sound").play();

invokeBarcodeScanEvent = (data, is_success=true) ->
  $('body').trigger(
    type:'barcode:scan'
    success: is_success
    barcode: data
  )

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
        invokeBarcodeScanEvent(data, false)
        showErrorDialog('Данные по введенному штрих-коду не найдены!')
      if data.package_item_id == null
        invokeBarcodeScanEvent(data, false)
        showErrorDialog('Введенный штрихкод не привязан к отправлению!')
      if (data.package_item.state == 'pending')
        list = $('table#reception_list>tbody')
        isExist = list.children("tr[item=#{data.package_item.id}]").length > 0
        if (isExist)
          invokeBarcodeScanEvent(data, false)
          showErrorDialog('Такая посылка уже находится в списке!')
        else
          invokeBarcodeScanEvent(data, true)
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
        invokeBarcodeScanEvent(data, false)
        $('#dialog').html(createInfoMarkup(data))
        $('#dialog').dialog(
          title: 'Информация о посылке'
          resizable: false
          height: 350
          width: 500
          modal: true
          focus: ->
            $('.ui-dialog :button').blur();
          buttons:
            'ОК': ->
              $(this).dialog('close')
          close: ->
            $('input[name=barcode]').prop('disabled', false).focus()
        )

  )

loadPlugins = ->
  $('a.plugin-link').click()

jQuery ->
  barcodeInput = $('input[name=barcode]')
  barcodeInput.keypress((event)->
    if (event.keyCode == $.ui.keyCode.ENTER)
      getPackage(barcodeInput)
      event.preventDefault()
  )
  loadPlugins()