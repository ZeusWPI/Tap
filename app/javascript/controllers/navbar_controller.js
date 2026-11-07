import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="navbar"
export default class extends Controller {
    static targets = [ "burger", "menu" ]

    initialize() {
        this.open = false;
    }

    toggleOpen() {
        this.open = !this.open;
        this.burgerTarget.classList.toggle("is-active", this.open);
        this.menuTarget.classList.toggle("is-active", this.open);
    }
}
