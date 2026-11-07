import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="products"
export default class extends Controller {
    static targets = [ "item", "placeholder", "tab" ]

    initialize() {
        this.tab = "all";
        this.searchValue = "";
    }

    changeTab(event) {
        this.tab = event.params.category;
        this.tabTargets.forEach(element => element.closest("li").classList.remove("is-active"));
        event.target.closest("li").classList.add("is-active");
        this.updateItems();
    }

    search(event) {
        this.searchValue = event.currentTarget.value;
        this.updateItems();
    }

    updateItems() {
        let anyMatched = false;
        this.itemTargets.forEach(element => {
            const matches = this.itemMatches(element.dataset.name, element.dataset.category)
            anyMatched ||= matches;
            element.classList.toggle('is-hidden', !matches);
        });
        this.placeholderTarget.classList.toggle('is-hidden', anyMatched);
    }

    itemMatches(name, category) {
      // If the product doesn't match the category, return false
      if (category && this.tab !== "all" && this.tab !== category) {
        return false;
      }

      // If the product doesn't match the search query, return false
      if (this.searchValue && !name.toLowerCase().includes(this.searchValue.toLowerCase())) {
        return false;
      }

      return true;
    }

}
