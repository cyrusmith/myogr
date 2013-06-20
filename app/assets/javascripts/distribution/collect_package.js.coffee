isReadyForTimeRequest = () ->
  if ($.inArray($('#collector').val(), $('#collector').data('autocomplete-source')) > -1 && $('#package_list').val().length > 0 && $('#collected_items').val().length > 0)
    $('input[type = "submit"]').removeAttr('disabled')
  else
    $('input[type = "submit"]').attr('disabled', 'disabled')

fill_package_list = (package_id) ->
  $('#package_items_list tr[class="item_record"]').remove()
  $.ajax(
    $('#package_list').data('package-source') + '/' + package_id + '.json'
    async: true
    success: (data) =>
      $.each(data.items, (index, value) =>
        if (!value.is_next_time_pickup)
          $('#package_items_list').append('<tr class = "item_record"><td>' + value.item_id + '</td><td>' + value.title + '</td><td><img src = "/assets/cross.png" id = "' + value.item_id + '"/></td></tr>')
      )
      false
  )

jQuery ->
  document.onkeypress = (event) ->
    if (event.keyCode == 13)
      return false

  $('#collector').autocomplete
    minLength: 3
    source: $('#collector').data('autocomplete-source')
    select: (event, ui) ->
      this.value = ui.item.label
      $('#collector').val(ui.item.label)
      isReadyForTimeRequest()
      false

  $("#package_number").bind("keydown",(event) =>
    if ( event.keyCode == $.ui.keyCode.TAB && $(this).data("ui-autocomplete").menu.active )
      event.preventDefault
  ).autocomplete
    minLength: 3
    source: (request, response) =>
      url = $('#package_number').data('autocomplete-source')
      $.getJSON(url, {
        term: request.term
      }, response);
    focus: =>
      false
    select: (event, ui) ->
      this.value = ui.item.label
      $('#package_list').val(ui.item.value)
      $('#collected_items').val('')
      fill_package_list(ui.item.value)
      isReadyForTimeRequest()
      false

  $("#number").bind("keydown",(event) =>
    if ( event.keyCode == $.ui.keyCode.ENTER )
      $('img[id="' + event.target.value + '"]').attr('src', '/assets/check.png')
      oldValue = $('#collected_items').val()
      $('#collected_items').val(oldValue + ' ' + event.target.value)
      isReadyForTimeRequest()
      $("#number").val('')
  )

  $("#collector").bind('keyup', (event) =>
    isReadyForTimeRequest()
  )