// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
ready = function() {
  products_ordered = $('#product_search').keyup(function () {
              var rex = new RegExp($(this).val(), 'i');
              $('[data-name]').hide();
              $('[data-name]').filter(function () {
                              return rex.test($(this).data("name"));
                          }).show();
  })

  $('#products_modal').on('hidden.bs.modal', function () {
    $('#product_search').val('');
  });

  increment_product = function(product_id) {
    input = $("#current_order").find(".order_item_wrapper[data-product=" + product_id + "]").find("input[type=number]");
    $(input).val(parseInt($(input).val()) + 1).change();
  }

  $("#products_modal button").click(function() {
    increment_product($(this).data("product"))
  })

  $("#from_barcode_form").on("ajax:before", function(xhr, settings) {
    // Stuff you wanna do after sending form
  }).on("ajax:success", function(data, status, xhr) {
    if (status != null) {
      increment_product(status["id"])
    }
  }).on("ajax:error", function(xhr, status, error) {
    // Display an error or something, whatever
  }).on("ajax:complete", function(xhr, status) {
    $("#from_barcode_form")[0].reset();
    // Do more stuff
  })

  $('tr.order_item_wrapper').hide();
  $('tr.order_item_wrapper').filter(function() {
    return parseInt($(this).find('[type=number]').val()) > 0;
  }).show();

  $('tr.order_item_wrapper input[type=number]').change(function() {
    tr = $(this).closest('tr.order_item_wrapper')
    $(tr).toggle(parseInt($(this).val()) > 0);
    $(tr).find("td").last().html(((parseInt($(tr).data("price")) * parseInt($(this).val())) / 100.0).toFixed(2))
    recalculate();
  })

  recalculate = function() {
    /* Total Price */
    array = $('tr.order_item_wrapper').map(function() {
      return parseInt($(this).data("price")) * parseInt($(this).find("input[type=number]").val());
    })
    sum = 0;
    array.each(function(i, el) { sum += el; });
    $("#current_order .total_price").html((sum / 100.0).toFixed(2));

    /* Message when no product has been choosen */
    $("#current_order #empty").toggle(!($('tr.order_item_wrapper input[type=number]').filter(function() {
      return parseInt($(this).val()) > 0;
    }).length));
  }

  recalculate();
}

$(document).ready(ready);
$(document).on('page:load', ready);
