jQuery ->
  $('.fire-event-link').bind('ajax:beforeSend', ->
    $(this).parent().append("<img src='/assets/ajax-loader.gif'/>")
    $(this).remove()
  )

  $('[id*=date]').datepicker(
    dateFormat: 'dd-mm-yy'
    defaultDate: 0
  );

  $(document).on 'click', 'form .remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $(document).on 'click', 'form .add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

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
