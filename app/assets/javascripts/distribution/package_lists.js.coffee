jQuery ->
  $('.fire-event-link').bind('ajax:beforeSend', ->
    $(this).parent().append("<img src='/assets/ajax-loader.gif'/>")
    $(this).remove()
  )

  $('select.actions').change(->
    option = $(this).children('[value=' + this.value + ']')
    if option.hasClass('pdf')
      url = option.attr('source')
      $(this).val('')
      win = window.open(url, '_blank')
      win.focus()
  )
