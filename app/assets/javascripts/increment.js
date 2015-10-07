ready = function() {
  increment_function = function() {
    target = $(this).data("target");
    $(target).val(parseIntNaN($(target).data("default")) + parseIntNaN($(this).val()));
  }

  $('[data-increment]').change(increment_function);
  $('[data-increment]').keyup(increment_function);
}

$(document).ready(ready);
$(document).on('page:load', ready);
