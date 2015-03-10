# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.btn-inc').on 'click', ->
    increment($(this), 1)

  $('.btn-dec').on 'click', ->
    increment($(this), -1)

  $('.form_row').each((index, row) ->
    disIfNec(row)
    $(row).on('input', recalculate)
  )

  recalculate()

disIfNec = (row) ->
  counter = parseInt($(row).find('.row_counter').val())
  $(row).find('.btn-dec').prop('disabled', counter == 0);
  $(row).find('.btn-inc').prop('disabled', counter == parseInt($(row).find('.stock').val()))

recalculate = () ->
  value = ($(row).find('.row_counter').val() * $(row).find('.price').val() for row in $('.form_row')).reduce (a, b) -> a+b
  $('#order_price').val((value / 100.0).toFixed(2))

increment = (button, n) ->
  row = $(button).closest('.form_row')

  # Fix the counter
  counter = $(row).find('.row_counter')
  counter.val(parseInt(counter.val()) + n)

  # Disable buttons if necessary
  disIfNec(row)

  recalculate()

$(document).ready(ready)
$(document).on('page:load', ready)
