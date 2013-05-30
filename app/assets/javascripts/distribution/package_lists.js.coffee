jQuery ->
  $('select.actions').change(->
    option = $(this).children('[value='+this.value + ']')
    if option.hasClass('pdf')
      url = option.attr('source')
      win=window.open(url, '_blank')
      win.focus()
  )
#  $('#package_lists').dataTable
#    sPaginationType: "full_numbers"
#    bJQueryUI: true
#    bProcessing: true
#    bServerSide: true
#    sAjaxSource: $('#package_lists').data('source')
#    "oLanguage": {
#      "sProcessing":   "Подождите...",
#      "sLengthMenu":   "Показать _MENU_ записей",
#      "sZeroRecords":  "Записи отсутствуют.",
#      "sInfo":         "Записи с _START_ до _END_ из _TOTAL_ записей",
#      "sInfoEmpty":    "Записи с 0 до 0 из 0 записей",
#      "sInfoFiltered": "(отфильтровано из _MAX_ записей)",
#      "sInfoPostFix":  "",
#      "sSearch":       "Поиск:",
#      "sUrl":          "",
#      "oPaginate": {
#        "sFirst": "Первая",
#        "sPrevious": "<",
#        "sNext": ">",
#        "sLast": "Последняя"
#      },
#      "oAria": {
#        "sSortAscending":  ": активировать для сортировки столбца по возрастанию",
#        "sSortDescending": ": активировать для сортировки столбцов по убыванию"
#      }
#    }
