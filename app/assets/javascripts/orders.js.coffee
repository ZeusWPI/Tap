# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
ready = ->
  $('.btn-inc').on 'click', ->
    increment(this, 1)

  $('.btn-dec').on 'click', ->
    increment(this, -1)

increment = (button, n) ->
  counter = $(button).closest('.form_row').find('.row_counter')
  newCount = parseInt(counter.val()) + n
  counter.val(Math.max(newCount, 0))
  calculatePrice()

calculatePrice = ->
  price = 0
  $('#form_products').children().each(->
    price += parseInt($(this).find('.price').html()) * parseInt($(this).find('.row_counter').val())
  )
  $('#order_total_price').val(price)

$(document).ready(ready)
$(document).on('page:load', ready)
