# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

setNotificationPopupPosition = ->
  iconDivOffset = $('#notification-icon').offset()
  iconDivWidth = $('#notification-icon').width()
  iconDivHeight = $('#notification-icon').height()
  topPosition = iconDivOffset.top + iconDivHeight  + 20
  leftPosition = iconDivOffset.left + iconDivWidth - $('#notifications-popup').width() + (25 if $('#notification-icon span').length == 0)
  $('#notifications-popup').offset({left: leftPosition, top: topPosition})

jQuery ->
  notificationKrutilka = $('#notifications-popup > .krutilka')
  notificationKrutilka.krutilka
    size: 32
    petals: 12
    petalWidth: 2
    petalLength: 8
    time: 1500
  $("#carousel").moodular()
  $(window).on 'resize', ->
    setNotificationPopupPosition()

  $('#notification-icon').on 'ajax:before', ->
    $('#notification-list').empty()
    notificationKrutilka.trigger('show').show()
    $('#notifications-popup').show()
    setNotificationPopupPosition()

  $('#notification-icon').on 'ajax:success', ->
    notificationKrutilka.trigger('hide').hide()
    $('#notification-error').hide()

  $('#notification-icon').on 'ajax:error', ->
    notificationKrutilka.trigger('hide').hide()
    $('#notification-error').show()

  $('#notifications-popup').on 'ajax:success', 'a' ,->
    $(this).parent().fadeOut()
    newNotifications = parseInt($('#notification-icon span').text()) - 1
    if (newNotifications == 0)
      $('#notification-icon span').remove()
    else
      $('#notification-icon span').text(newNotifications)
  $('body').on 'click', (event)->
    if ($('#notifications-popup').is(':visible') && $(event.toElement).parents('#notifications-popup').length == 0)
      $('#notifications-popup').hide()