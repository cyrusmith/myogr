jQuery ->
  $('input[type=text]#barcode').keydown( (event)->
    if(event.keyCode == $.ui.keyCode.ENTER)
      input = $(this)
      enteredBarcode = input.val()
      barcodeField = $("input[type=hidden][data-barcode=#{enteredBarcode}]")
      barcodeField.prev().removeClass('icon-remove').addClass('icon-ok').parent().addClass('green')
      barcodeField.appendTo('#issued_items')
      input.val('')
      event.preventDefault()
  )