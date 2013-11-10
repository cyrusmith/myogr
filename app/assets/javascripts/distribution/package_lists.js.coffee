jQuery ->
  $('.fire-event-link').bind('ajax:beforeSend', ->
    $(this).parent().append("<img src='/assets/ajax-loader.gif'/>")
    $(this).remove()
  )

  $('body').on 'change', 'select.actions', ->
    option = $(this).children('[value=' + this.value + ']')
    url = option.attr('source')
    method = option.attr('method') || 'get'
    $(this).val('')
    if option.hasClass('pdf')
      win = window.open(url, '_blank')
      win.focus()
    else
      $.ajax
        url: url
        type: method
