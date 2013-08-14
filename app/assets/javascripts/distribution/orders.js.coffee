arr = window.location.href.split("/")
fullurl = arr[0] + "//" + arr[2]

initSelectFields = ->
  $('#orders .barcode_select').select2
    placeholder: "Выберите штрих-код"
    width: '200px'
    data: { results: unusedBarcodes}

addToForm = (row) ->
  copiedRow = row.clone()
  copiedRow.find('input.barcode_select').select2('destroy')
  $('table#send-orders').append(copiedRow)

disableTableRow = (row) ->
  barcodeSelect = row.find('input.barcode_select')
  deleteIndexes = []
  for codeHash in unusedBarcodes
    if (codeHash['id'].toString() == barcodeSelect.val())
      deleteIndexes.push _i
  for index in deleteIndexes
    unusedBarcodes.splice(index, 1)
  barcodeText = barcodeSelect.select2('data')['text']
  barcodeSelect.parent().html(barcodeText)

  row.find('a.add-to-list').detach()

  barcodeSelect.select2('destroy')
  $('#orders .barcode_select').select2('destroy')
  initSelectFields()

jQuery ->
  $('#distributors').select2
    placeholder: "Выберите закупки для фильтрации"
    width: '500px'
  $('#users').select2
    placeholder: "Поиск по пользователям"
    width: '300px'
    initSelectFields()
  $('a.add-to-list').click ->
    clickedRow = $(this).parent().parent()
    addToForm(clickedRow)
    disableTableRow(clickedRow)
