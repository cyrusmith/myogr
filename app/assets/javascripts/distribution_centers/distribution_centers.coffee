jQuery ->
  $('#distribution_center_distribution_center_head_name').autocomplete
    minLength: 3
    source: $('#distribution_center_distribution_center_head_name').data('autocomplete-source')

  split = (val) ->
    val.split(/,\s*/)

  extractLast = (term) ->
    split(term).pop()

  $("#distribution_center_distribution_center_employees_names").bind("keydown",(event) =>
    if ( event.keyCode == $.ui.keyCode.TAB && $(this).data("ui-autocomplete").menu.active )
      event.preventDefault
  ).autocomplete
#    source: $('#distribution_center_distribution_center_employees_names').data('autocomplete-source')
    source: (request, response) =>
      url = $('#distribution_center_distribution_center_employees_names').data('autocomplete-source')
      $.getJSON(url, {
        term: extractLast(request.term)
      }, response);
    search: ->
      term = extractLast(this.value);
      if ( term.length < 3 )
        false
    focus: =>
      false
    select: (event, ui) ->
      terms = split(this.value)
      terms.pop()
      terms.push(ui.item.value)
      terms.push("")
      this.value = terms.join(", ")
      false