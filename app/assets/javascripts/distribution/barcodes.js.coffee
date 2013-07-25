arr = window.location.href.split("/")
fullurl = arr[0] + "//" + arr[2]
jQuery ->
  $('#item-select').select2
    placeholder: "Выберите закупку"
    width: '100%'
  $("#item-select").on("change", (e)->
    $.ajax (
      url: fullurl + '/distribution/' + $(this).val() + '/unfinished_orders'
      success: (data) =>
        $('p.work-schedule').html(data['work_schedule'])
    )
  )