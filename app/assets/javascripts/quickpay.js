ready = function() {
  $('[data-quickpay]').on("ajax:success", function (e, data, status, xhr) {
    var img = $("<img>", {
      src: $(this).closest(".overviewthumbnail").find(".avatar").attr("src").replace("large", "small"),
      class: [ "img-responsive img-circle img-thumbnail" ]
    })
    $(img).hide().prependTo($("#last")).fadeIn();
    if ($("#last").find("img").size() > 10) {
      $("#last").find("img").last().remove();
    }
  }).on("ajax:error", function (e, xhr, status, error) {
    alert("Error while using quickpay ... sorry.");
  });
}

$(document).ready(ready);
$(document).on('page:load', ready);
