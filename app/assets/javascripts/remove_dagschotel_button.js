ready = function() {
    var id = $("#remove_dagschotel").find(".btn");
    default_value = id.val();

    id.hover(function() {
        $(this).toggleClass("btn-success");
        $(this).toggleClass("btn-danger");
        $(this).val("Remove dagschotel");
    }, function() {
        $(this).val(default_value);
        $(this).toggleClass("btn-success");
        $(this).toggleClass("btn-danger");
    });
}
$(document).ready(ready);
$(document).on('page:load', ready);
