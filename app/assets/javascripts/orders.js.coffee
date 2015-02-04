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
  )

disIfNec = (row) ->
  counter = parseInt($(row).find('.row_counter').val())
  $(row).find('.btn-dec').prop('disabled', counter == 0);
  $(row).find('.btn-inc').prop('disabled', counter == parseInt($(row).find('.stock').val()))

increment = (button, n) ->
  row = $(button).closest('.form_row')

  # Fix the counter
  counter = $(row).find('.row_counter')
  counter.val(parseInt(counter.val()) + n)

  # Disable buttons if necessary
  disIfNec(row)

  # Update the price
  oldVal = parseFloat($('#order_total_price').val()) * 100
  newVal = (oldVal + parseInt($(row).find('.price').val()) * n)/100
  $('#order_total_price').val(newVal.toFixed(2))

$(document).ready(ready)
$(document).on('page:load', ready)
