isBarcode = (value) ->
  result = value.match(/^\d{14}$/)
  if result
    true
  else
    false

jQuery ->
  $('input[type=text]#barcode').keydown( (event)->
    if(event.keyCode == $.ui.keyCode.ENTER)
      input = $(this)
      enteredBarcode = input.val()
      barcodeField = $("input[type=hidden][data-barcode=#{enteredBarcode}]")
      if (barcodeField.length == 0)
        if (isBarcode(enteredBarcode))
          alert('Sending request')
        else
          alert('Неправильный штрих-код введен')
      barcodeField.prev().removeClass('icon-remove').addClass('icon-ok').parent().addClass('green')
      barcodeField.appendTo('#issued_items')
      input.val('').focus()
      event.preventDefault()
  )