repopulatePackageSelect = (packages) ->
  select = $('#packages')
  select.children('option[value!=""]').remove()
  for new_package in packages
    option = '<option value="' + new_package._id + '">' + new_package.code + '</option>'
    select.append(option)
    select.trigger("liszt:updated");
$ ->
  # enable chosen js
  $('.chzn-select').chosen
    no_results_text: 'Ничего не найдено'
    data_placeholder: ''
    width: '100px'

  $('#packages_chzn .chzn-search input[type="text"]').focus()

  $('#package_list').change(->
    list_id = $(this).val()
    $.ajax(
      url: $(this).data('package-list-source') + list_id + '/packages/for_issue'
      beforeSend: ->
        $('#packages').chosen().val('')
        $('#packages').attr('disabled', 'disabled')
        $('#packages').trigger("liszt:updated")
        $('input:submit').addClass('disabled')
        $('input:submit').attr('disabled', 'disabled')
      success: (data) =>
        repopulatePackageSelect(data)
      complete: ->
        $('#packages').removeAttr('disabled')
        $('#packages').trigger("liszt:updated")
        $('#packages_chzn .chzn-search input[type="text"]').focus();
    )
  )

  $('#packages').change(->
    checkDocumentBlock = $('#check-document')
    $.ajax(
      url: $(this).data('package-source')  + $(this).val() + '.json'
      success: (data) =>
        alert('Проверьте документ: ' + data.document_number)
      complete: ->
        $('input:submit').removeClass('disabled')
        $('input:submit').removeAttr('disabled')
    )
  )