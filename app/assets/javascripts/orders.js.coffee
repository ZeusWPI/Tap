# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.btn-inc').on 'click', ->
    input = $(this).parent().parent().find('input').first()
    input.val(parseInt(input.val()) + 1)

  $('.btn-dec').on 'click', ->
    input = $(this).parent().parent().find('input').first()
    if input.val() != '0'
      input.val(parseInt(input.val()) - 1)

$(document).ready(ready)
$(document).on('page:load', ready)
