getUserPackages = (userInputElement, inputType)->

jQuery ->
  userInput = $('input[name=user]')
  userInput.keypress((event)->
    if (event.keyCode == $.ui.keyCode.ENTER)
      inputType = $('input[name=input_type]:selected').val()
      getUserPackages(userInput, inputType)
      event.preventDefault()
  )