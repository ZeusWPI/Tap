import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="stock"
export default class extends Controller {
    static targets = [ "totalOutput", "readableTotalOutput" ]

    connect() {
        this.currentValue = Number.parseInt(this.element.dataset.currentStock);
    }

    setPurchasedStock(event) {
        const purchasedValue = Number.parseInt(event.currentTarget.value);
        this.totalOutputTarget.value = this.currentValue + purchasedValue;
        this.readableTotalOutputTarget.innerText = this.currentValue + purchasedValue;
    }
}
