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
