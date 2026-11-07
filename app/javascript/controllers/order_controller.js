import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="order"
export default class extends Controller {
    static targets = [ "billOverview", "spinner", "actualForm" ];

    setLoading() {
        this.billOverviewTarget.classList.add("is-hidden");
        this.spinnerTarget.classList.remove("is-hidden");
    }

    submit(event) {
        event.currentTarget.disabled = true;
        event.currentTarget.value = "Please wait...";
        this.actualFormTarget.submit();
    }

    addItem(event) {
        this.setLoading();
        window.closeModal('modalOrderProducts');
    }
}
