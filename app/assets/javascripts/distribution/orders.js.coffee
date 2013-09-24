arr = window.location.href.split("/")
fullurl = arr[0] + "//" + arr[2]
usedBarcodes = new Array()

@initNewPage = ->
  $('#orders .barcode_select').select2({placeholder: "Выберите штрих-код", width: '200px', data: { results: unusedBarcodes}})
  $('#custom_user_id').select2
    placeholder: "Выберите пользователя"
    width: '200px'
    minimumInputLength: 1
    ajax:
      url: fullurl + '/user/find_by_name'
      data: (term, page) ->
        {
        term: term,
        page_limit: 10,
        page: page,
        }
      results: (data, page) ->
        {results: data}
    formatResult: (data) ->
      data.text
    formatSelection: (data) ->
      '<div>' + data.text + '</div>'

jQuery ->
  $('input#distributor_search').keyup((event)->
    return event.preventDefault() if (event.keyCode == $.ui.keyCode.ENTER)
    substring = $(this).val().toLowerCase()
    $(this).parent().siblings('li.distributor').each(->
      string = $(this).children('a').attr('data-search').toLowerCase()
      if (string.indexOf(substring) + 1) || ($(this).hasClass('current'))
        $(this).removeClass('no-display')
      else
        $(this).addClass('no-display')
    )
  )

  $(".distributor>a").on 'click', (event)->
    saveNeeded = false
    $('#orders .barcode_select').each ->
      if ($(this).val() != '')
        isCustomUser = $(this).parents('#add_custom_user').length > 0
        if (isCustomUser)
          unless ($('#custom_user_id').val() == '')
            $('#add_custom').click()
            saveNeeded = true
        else
          saveNeeded = true
    if (saveNeeded)
      link = this
      $('#dialog-confirm').dialog
        resizable: false
        height: 220
        width: 500
        modal: true
        buttons:
          "Да": ->
            $('.distributor').removeClass('current')
            $(link).parent().addClass('current')
            $('#create_items_form input[type=submit]').submit()
            $(this).dialog('close')
          "Нет": ->
            $('#orders .barcode_select').each ->
              if ($(this).val() != '')
                currentSelectData = $(this).select2('data')
                deleteIndexes = []
                for usedBarcode in usedBarcodes
                  if (usedBarcode == currentSelectData)
                    unusedBarcodes.push(usedBarcode)
                    deleteIndexes.push(_i)
                for index in deleteIndexes
                  usedBarcodes.splice(index, 1)
                sortBarcodes()
            $(this).dialog('close')
            getOrders(link)
      event.preventDefault()
    else
      getOrders(this)
      event.preventDefault()

  $('form').on "ajax:complete", (event, xhr, status)->
    if (xhr.status == 201)
      getOrders($('.distributor.current a'))

  $('body').delegate '#add_custom', 'click', ->
    customUser = $('#custom_user_id').select2('data')
    row = $(this).parents('tr')
    barcode = row.find('.barcode_select').select2('data')

    return alert('Выберите пользователя и штрихкод') unless barcode? && customUser
    $('#custom_user_id').select2('data', '')
    row.find('.barcode_select').select2('data', '')
    newRow = row.clone()
    newRow.children().first().text(customUser.text).append("<input id='user_' name='user[]' type='hidden' value='#{customUser.id}'>")
    newRow.children().last().text('Не сдан в цр')
    newRow.find('input[type=hidden][name*=custom_user]').attr('name')
    newRow.find('div.barcode_select').remove()
    newRow.find('.barcode_select').select2('destroy').select2({placeholder: "Выберите штрих-код", width: '200px', data: { results: unusedBarcodes}}).select2('data',
      barcode)
    row.before(newRow)

  $('body').delegate 'input#user_search', 'keyup', (event)->
    return event.preventDefault() if (event.keyCode == $.ui.keyCode.ENTER)
    substring = $(this).val().toLowerCase()
    $('td.user').each(->
      string = $(this).text().toLowerCase()
      if (string.indexOf(substring) + 1)
        $(this).parent().removeClass('no-display')
      else
        $(this).parent().addClass('no-display')
    )

  $('body').delegate 'select#state_search', 'change', (event)->
    value = $(this).val().toLowerCase()
    $('td.state').each(->
      if ($(this).text().toLowerCase().indexOf(value) + 1) || (value == 'all')
        $(this).parent().removeClass('no-display')
      else
        $(this).parent().addClass('no-display')
    )

  attachAddToBasketAction()

addToForm = (row) ->
  copiedRow = row.clone()
  copiedRow.find('input.barcode_select').select2('destroy')
  $('table#send-orders').append(copiedRow)

attachAddToBasketAction = ->
  $(document).on 'change', '#orders .barcode_select', (event) ->
    $('#submit-bar').show('slow')
    if (event.removed?)
      deleteIndexes = []
      for usedBarcode in usedBarcodes
        if (usedBarcode == event.removed)
          unusedBarcodes.push(usedBarcode)
          deleteIndexes.push(_i)
      for index in deleteIndexes
        usedBarcodes.splice(index, 1)
    clickedRow = $(this).parent().parent()
    addToForm(clickedRow)
    disableTableRow(clickedRow)

sortBarcodes = ->
  unusedBarcodes.sort((a, b) ->
    a = parseInt(a.text.substr(7))
    b = parseInt(b.text.substr(7))
    if (a > b)
      1
    else if (a < b)
      -1
    else
      0
  )

disableTableRow = (row) ->
  barcodeSelect = row.find('input.barcode_select')
  usedBarcodes.push(barcodeSelect.select2('data'))
  deleteIndexes = []
  for codeHash in unusedBarcodes
    if (codeHash['id'].toString() == barcodeSelect.val())
      deleteIndexes.push _i
  for index in deleteIndexes
    unusedBarcodes.splice(index, 1)
  sortBarcodes()

getOrders = (link) ->
  $.ajax(
    url: $(link).attr('href')
    dataType: 'script'
    beforeSend: ->
      $('.distributor.current').removeClass('current')
      $(link).parent().addClass('current')
      $('#orders').html('<p id="krutilka" style="text-align: center"></p>')
      $('#krutilka').krutilka
        size: 64
        petals: 15
        petalWidth: 4
        petalLength: 16
        time: 2500
    success: ->
      $('#submit-bar').hide()
  )