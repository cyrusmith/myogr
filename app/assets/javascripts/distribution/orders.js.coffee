arr = window.location.href.split("/")
fullurl = arr[0] + "//" + arr[2]
usedBarcodes = new Array()

@initNewPage = ->
  assignedOrders = $('#send-orders tr')
  $('#orders .barcode_select').each(->
    inputCell = $(this).parent()
    userId = inputCell.find('input[name*=user]').val()
    distributorId = inputCell.find('input[name*=distributor]').val()
    isInitNeeded = true
    for order in assignedOrders
      orderUserId = $(order).find('input[name*=user]').val()
      orderDistributorId = $(order).find('input[name*=distributor]').val()
      if (orderDistributorId == distributorId && orderUserId == userId)
        isInitNeeded = false
        break

    if (isInitNeeded)
      $(this).select2({placeholder: "Выберите штрих-код", width: '200px', data: { results: unusedBarcodes}})
  )

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

  $('#orders .barcode_select.active').select2
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
  usedBarcodes.push(barcodeSelect.select2('data'))
  deleteIndexes = []
  for codeHash in unusedBarcodes
    if (codeHash['id'].toString() == barcodeSelect.val())
      deleteIndexes.push _i
  for index in deleteIndexes
    unusedBarcodes.splice(index, 1)
  $('#orders .barcode_select').select2('destroy')
  initSelectFields()
  barcodeSelect.removeClass('active').val('').select2('destroy')

toggleRemoveAction = (row) ->
  actionBar = row.find('td.order_actions')
  if (actionBar.children('.remove-from-basket').length == 0)
    actionBar.append('<a href="javascript:void(0);" class="remove-from-basket"><i class="icon-minus"></i></a>')
    actionBar.children('.remove-from-basket').click(->
      orderId = row.attr('id')
      barcodeId = row.find('input.barcode_select').val()
      deleteIndexes = []
      for codeHash in usedBarcodes
        if (codeHash['id'].toString() == barcodeId)
          unusedBarcodes.push(codeHash)
          deleteIndexes.push(_i)
      for index in deleteIndexes
        usedBarcodes.splice(index, 1)
      unusedBarcodes.sort((a,b)->
        a.text > b.text
      )
      $('#orders tr#' + orderId).find('input.barcode_select').addClass('active').select2(
        placeholder: "Выберите штрих-код"
        width: '200px'
        data: { results: unusedBarcodes}
      )
      row.remove()
    )
  else
    actionBar.children('.remove-from-basket').remove()