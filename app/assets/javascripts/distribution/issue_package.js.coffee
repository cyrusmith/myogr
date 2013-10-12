isBarcode = (value) ->
  result = value.match(/^\d{14}$/)
  if result
    true
  else
    false

getPackageInfo = (barcode) ->
  input = $('input[type=text]#barcode')
  $.ajax(
    url: "/distribution/barcodes?barcode_string=#{barcode}"
    dataType: 'json'
    beforeSend: ->
      input.val('')
    success: (data) =>
      unless (data)
        input.focus()
        return alert('Данные по введенному штрих-коду не найдены!')
      if data.package_item_id == null
        input.focus()
        return alert('Введенный штрихкод не привязан к отправлению!')
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
            input.focus()
      )
  )

createInfoMarkup = (barcode) ->
  "<p><b>Отправитель:</b> #{barcode.package_item.organizer}</p>
     <p><b>Получатель:</b> #{barcode.package_item.username}</p>
     <p><b>Закупка:</b> #{barcode.package_item.title}</p>
     <p><b>Состояние:</b> #{barcode.package_item.localized_state}</p>
    "

jQuery ->
  $('input[type=text]#barcode').keydown((event)->
    if(event.keyCode == $.ui.keyCode.ENTER)
      event.preventDefault()
      input = $(this)
      enteredBarcode = input.val().replace(/\s/g, '');
      if isBarcode(enteredBarcode)
        barcodeFields = $("input[type=hidden][name*=item_id]")
        isFoundInList = false
        for field in barcodeFields
          field = $(field)
          if field.attr('data-barcode') == enteredBarcode
            isFoundInList = true
            field.prev().removeClass('icon-remove').addClass('icon-ok').parent().addClass('green')
            field.appendTo('#issued_items')
            break
        unless isFoundInList
          getPackageInfo(enteredBarcode)
      else
        alert('Введенная последовательность не является штрих-кодом!')
      input.val('').focus()
      return false
  )

  $('a.issue_package').on("ajax:success", (data, status, xhr)->
    $(this).parent().fadeOut("slow", -> $(this).remove())
  )