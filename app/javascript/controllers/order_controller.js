import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = {
    /**
     * List of available products.
     */
    products,
  };

  connect() {
    console.log(this.values.products);
  }
}
