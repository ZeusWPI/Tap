ready = function() {
    $('[data-quickpay]').on("ajax:success", function(e, data, status, xhr) {
        if (this.id !== "dagschotel_quickpay") {
            // Last Image
            var img = $("<img>", {
                src: $(this).closest(".overviewthumbnail").find(".avatar").attr("src").replace("koelkast", "small"),
                class: ["img-responsive img-circle img-thumbnail"]
            })
            $(img).hide().prependTo($("#last")).fadeIn();
            if ($("#last").find("img").size() > 10) {
                $("#last").find("img").last().remove();
            }
            $(".alert").fadeOut();

            // Flash Message
            var div = $("<div>", {
                class: ["alert alert-success alert-dismissable"]
            });
            $(div).append($("<button>", {
                text: 'x',
                class: "close",
                data: {
                    dismiss: "alert"
                }
            }));
            $(div).append($("<strong>", {
                text: "Success! "
            }));
            $(div).append(data.message);

            $("#flash").append(div);
        }

    }).on("ajax:error", function(e, xhr, status, error) {
        alert("Error while using quickpay ... sorry.");
    });
}

$(document).ready(ready);
$(document).on('page:load', ready);
