isReadyForTimeRequest = () ->
  if ($.inArray($('#collector').val(), $('#collector').data('autocomplete-source')) > -1 && $('#collected_items').val().length > 0)
    $('input[type = "submit"]').removeAttr('disabled')
  else
    $('input[type = "submit"]').attr('disabled', 'disabled')


jQuery ->
  document.onkeypress = (event) ->
    if (event.keyCode == 13)
      return false

  $("#number").bind("keydown",(event) =>
    if ( event.keyCode == $.ui.keyCode.ENTER )
      $('tr[id="' + event.target.value + '"] img').attr('src', '/assets/check.png')
      oldValue = $('#collected_items').val()
      $('#collected_items').val(oldValue + ' ' + event.target.value)
      isReadyForTimeRequest()
      $("#number").val('')
  )
