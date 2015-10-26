ready = function() {
  $('[data-remove]').each(function() {
    var button = $(this);
    setTimeout(function() {
      $(button).remove();
    }, $(button).data("remove") * 1000);
  });
}

$(document).ready(ready);
$(document).on('page:load', ready);
