# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.btn-inc').on 'click', ->
    increment($(this), 1)

  $('.btn-dec').on 'click', ->
    increment($(this), -1)

  $('.form_row').each((index, row) ->
    updateInput(row, false)
    $(row).on('input', ->
      updateInput(row)
    )
  )

  recalculate()



# Validate input, and then update
updateInput = (row, useRecalculate = true)->
  cell = row.querySelector("input")
  if ! cell.validity.valid
    if(parseInt(cell.value) > parseInt(cell.max))
      cell.value = parseInt(cell.max)
    else
      cell.value = 0

  # Disable buttons if necessary
  disIfNec(row)

  if useRecalculate
    recalculate();


disIfNec = (row) ->
  counter = parseInt($(row).find('.row_counter').val())
  $(row).find('.btn-dec').prop('disabled', counter == 0);
  $(row).find('.btn-inc').prop('disabled', counter == parseInt($(row).find('.row_counter').attr('max')))

recalculate = () ->
  value = ($(row).find('.row_counter').val() * $(row).find('.price').val() for row in $('.form_row')).reduce (a, b) -> a+b
  $('#order_price').val((value / 100.0).toFixed(2))

increment = (button, n) ->
  row = $(button).closest('.form_row')

  # Fix the counter
  counter = $(row).find('.row_counter')
  value = parseInt(counter.val())
  # Apparently CoffeeScript doesn't support ?:
  value =  if isNaN(value) then 0 else value
  counter.val(value + n)

  updateInput(row[0])

$(document).ready(ready)
$(document).on('page:load', ready)
