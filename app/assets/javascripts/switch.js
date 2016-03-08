ready = function() {
  $.each($('[data-switch]'), function(key, value){
    console.log(value.getAttribute('data-offText'));
    $(this).bootstrapSwitch({ offText: value.getAttribute('data-offText'),  onText: value.getAttribute('data-onText')});
  });
  $('[data-switch]').on('switchChange.bootstrapSwitch', function(event, state) {
    $(this).closest('form').submit();
  });

  $('#edit_user_1').on("ajax:error", function(xhr, status, error) {
    alert("An error occured. Your account has not been updated.");
  });
}

$(document).ready(ready);
$(document).on('page:load', ready);
