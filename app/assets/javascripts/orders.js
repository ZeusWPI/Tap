// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/
ready = function() {
  /* INITIALIZE */
  $('tr.order_item_wrapper').hide();
  $('tr.order_item_wrapper').filter(function() {
    return parseIntNaN($(this).find('[type=number]').val()) > 0;
  }).show();

  /* HELPERS */
  increment_product = function(product_id) {
    input = $("#current_order").find(".order_item_wrapper[data-product=" + product_id + "]").find("input[type=number]");
    $(input).val(parseIntNaN($(input).val()) + 1).change();
  }

  recalculate = function() {
    /* Total Price */
    array = $('tr.order_item_wrapper').map(function() {
      return parseIntNaN($(this).data("price")) * parseIntNaN($(this).find("input[type=number]").val());
    })
    sum = 0;
    array.each(function(i, el) { sum += el; });
    $("#current_order .total_price").html((sum / 100.0).toFixed(2));

    /* Message when no product has been choosen */
    $("#current_order #empty").toggle(!($('tr.order_item_wrapper input[type=number]').filter(function() {
      return parseIntNaN($(this).val()) > 0;
    }).length));
  }

  /* PRODUCT MODAL */
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

  $("#products_modal button").click(function() {
    increment_product($(this).data("product"))
  })

  /* BARCODE SCAN */
  $("#from_barcode_form").submit(function(event) {
    event.preventDefault();
    barcode = $(this).find("input[type=number]").val();
    $("#from_barcode_form")[0].reset();
    $.ajax({
      url: "/barcodes/" + barcode,
      success: function(data) {
        if (data != null) {
          increment_product(data["id"]);
          $("#from_barcode_form")[0].reset();
        } else {
          alert("Barcode '" + barcode + "' was not found in the database system.");
        }
      },
      dataMethod: "json"
    }).fail(function() {
      alert("Barcode '" + barcode + "' was not found in the database system.");
    });
  });

  /* CURRENT ORDER CHANGE */
  $('tr.order_item_wrapper input[type=number]').change(function() {
    tr = $(this).closest('tr.order_item_wrapper')
    $(tr).toggle(parseIntNaN($(this).val()) > 0);
    $(tr).find("td").last().html(((parseIntNaN($(tr).data("price")) * parseIntNaN($(this).val())) / 100.0).toFixed(2))
    recalculate();
  })

  recalculate();
}

$(document).ready(ready);
$(document).on('page:load', ready);
