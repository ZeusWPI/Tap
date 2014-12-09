# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.btn-inc').on 'click', ->
    increment($(this), 1)

  $('.btn-dec').on 'click', ->
    increment($(this), -1)


increment = (button, n) ->
  # Fix the counter
  counter = $(button).closest('.form_row').find('.row_counter')
  counter.val(parseInt(counter.val()) + n)

  # Enable or disable the dec button
  counter.parent().find('.btn-dec').prop("disabled", counter.val() == '0');

  # Update the price
  oldVal = parseFloat($('#order_total_price').val())
  $('#order_total_price').val(parseFloat(oldVal + counter.parent().find('.price').val() * n).toFixed(2))

$(document).ready(ready)
$(document).on('page:load', ready)
