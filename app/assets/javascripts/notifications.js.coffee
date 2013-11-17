# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
  $('.notification a').on 'ajax:success', ->
    $(this).parents('.notification').removeClass('unread')
    $(this).remove()
    newNotifications = parseInt($('#notification-icon span').text()) - 1
    if (newNotifications == 0)
      $('#notification-icon span').remove()
    else
      $('#notification-icon span').text(newNotifications)