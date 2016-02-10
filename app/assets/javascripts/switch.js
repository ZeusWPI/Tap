ready = function() {
  $('[data-switch]').bootstrapSwitch({ onText: "private", offText: "public" });
  $('[data-switch]').on('switchChange.bootstrapSwitch', function(event, state) {
    $(this).closest('form').submit();
  });

  $('#edit_user_1').on("ajax:error", function(xhr, status, error) {
    alert("An error occured. Your account has not been updated.");
  });
}

$(document).ready(ready);
$(document).on('page:load', ready);
