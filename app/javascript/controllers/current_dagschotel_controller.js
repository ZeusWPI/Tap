import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="current-dagschotel"
export default class extends Controller {
    static targets = [ "button" ]

    startHover() {
        this.buttonTarget.innerText = "Remove dagschotel";
        this.buttonTarget.classList.add("is-danger");
    }

    endHover() {
        this.buttonTarget.innerText = "Current dagschotel";
        this.buttonTarget.classList.remove("is-danger");
    }
}
