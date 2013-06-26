repopulatePackageSelect = (packages) ->
  select = $('#packages')
  select.children('option[value!=""]').remove()
  for new_package in packages
    option = '<option value="' + new_package._id + '">' + new_package.code + '</option>'
    select.append(option)
$ ->
  # enable chosen js
  $('.chzn-select').chosen
    no_results_text: 'Ничего не найдено'
    data_placeholder: ''

  $('#packages_chzn .chzn-search input[type="text"]').focus()

  $('#krutilka').krutilka
    size: 32
    petals: 15
    petalWidth: 2
    petalLength: 8
    time: 2500
  $('#krutilka').trigger('hide')

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
        $('#krutilka').trigger('show')

      success: (data) =>
        repopulatePackageSelect(data)
      complete: ->
        $('#packages').removeAttr('disabled')
        $('#packages').trigger("liszt:updated")
        $('#krutilka').trigger('hide')
        $('#packages_chzn .chzn-search input[type="text"]').focus()
    )
  )

  $('#packages').change(->
    $.ajax(
      url: $(this).data('package-source')  + $(this).val()
      dataType: "script"
      beforeSend: ->
        $('input:submit').addClass('disabled')
        $('input:submit').attr('disabled', 'disabled')
        $('#krutilka').trigger('show')
      complete: ->
        $('input:submit').removeClass('disabled')
        $('input:submit').removeAttr('disabled')
        $('#krutilka').trigger('hide')
        $('#collected_items').val('');
    )
  )