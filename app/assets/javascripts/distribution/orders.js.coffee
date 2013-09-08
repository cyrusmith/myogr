arr = window.location.href.split("/")
fullurl = arr[0] + "//" + arr[2]

jQuery ->
  initSelectFields()
  attachAddToBasketAction()

initSelectFields = ->
  $('#distributors').select2
    placeholder: "Выберите закупки для фильтрации"
    width: '500px'

  $('#users').select2
    placeholder: "Поиск по пользователям"
    width: '300px'

  $('#orders .barcode_select').select2
    placeholder: "Выберите штрих-код"
    width: '200px'
    data: { results: unusedBarcodes}

addToForm = (row) ->
  copiedRow = row.clone()
  toggleRemoveAction(copiedRow)
  copiedRow.find('input.barcode_select').select2('destroy')
  $('table#send-orders').append(copiedRow)

attachAddToBasketAction = ->
  $(document).on 'click', '#orders .barcode_select', (event) ->
    clickedRow = $(this).parent().parent()
    addToForm(clickedRow)
    disableTableRow(clickedRow)

disableTableRow = (row) ->
  barcodeSelect = row.find('input.barcode_select')
  deleteIndexes = []
  for codeHash in unusedBarcodes
    if (codeHash['id'].toString() == barcodeSelect.val())
      deleteIndexes.push _i
  for index in deleteIndexes
    unusedBarcodes.splice(index, 1)
  barcodeText = barcodeSelect.select2('data')['text']
#  barcodeSelect.parent().html(barcodeText)
  barcodeSelect.select2('destroy')
  $('#orders .barcode_select').select2('destroy')
  initSelectFields()

toggleRemoveAction = (row) ->
  actionBar = row.find('td.order_actions')
  if (actionBar.children('.remove-from-basket').length == 0)
    actionBar.append('<a href="javascript:void(0);" class="remove-from-basket"><i class="icon-minus"></i></a>')
    actionBar.children('.remove-from-basket').click(->
      row.remove()
    )
  else
    actionBar.children('.remove-from-basket').remove()