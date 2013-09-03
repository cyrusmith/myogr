getPackage = (barcodeInput) ->
  barcodeValue = $(barcodeInput).val();
  $.ajax(
    url: '/distribution/barcodes?barcode_string=' + barcodeValue
    dataType: 'json'
    beforeSend: ->
      barcodeInput.prop('disabled', true)
    success: (data) =>
      alert(data)
    complete: ->
      barcodeInput.prop('disabled', false)
  )

jQuery ->
  barcodeInput = $('input[name=barcode]')
  barcodeInput.keypress((event)->
    if (event.keyCode == $.ui.keyCode.ENTER)
      getPackage(barcodeInput)
      event.preventDefault()
  )