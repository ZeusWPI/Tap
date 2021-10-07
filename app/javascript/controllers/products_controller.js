function ProductsController(props) {
  return {
    /**
     * Currently active tab category.
     */
    tab: "all",

    /**
     * Value of the search input.
     */
    search: "",

    /**
     * Should a specific product be shown
     * @param name name of the product
     * @param category name of the category of the product
     */
    showProduct(name, category) {
      // If the product doesn't match the category, return false
      if (category && this.tab !== "all" && this.tab !== category) {
        return false;
      }

      // If the product doesn't match the search query, return false
      if (
        this.search &&
        !name.toLowerCase().includes(this.search.toLowerCase())
      ) {
        return false;
      }

      return true;
    },

    /**
     * Should the placeholder be shown (when no products match a given query)
     */
    get showPlaceholder() {
      // This is a simple hack to check if no products match a specific query.
      // As product name the concatenation of all products is used,
      // so when there is no match the string will not include the searched keyword
      // and the placeholder can be shown.
      return !this.showProduct(
        "<%= escape_javascript @products.map(&:name).join %>",
        null
      );
    },
  };
}

window.ProductsController = ProductsController;
