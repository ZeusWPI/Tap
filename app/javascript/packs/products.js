function ready() {
  // Find all products in the list
  const products = document.querySelectorAll("#product");

  // Find all tab elements (data-product-tab)
  const tabs = document.querySelectorAll("[data-product-tab]");

  // For each tab element, add an event listener to update the list of products
  // to only show the products that match the tab's data-product-tab attribute
  tabs.forEach((tab) => {
    tab.addEventListener("click", (e) => {
      e.preventDefault();

      // Get the tab value
      const tabValue = tab.dataset.productTab;

      // Set the tab as active an all other tabs to inactive
      tabs.forEach((tab) => {
        tab.classList.remove("is-active");
      });
      tab.classList.add("is-active");

      // Find all products that match the tab's data-product-tab attribute
      const productsToShow =
        tabValue === "all"
          ? products
          : [...products].filter(
              (product) => product.dataset.productCategory === tabValue
            );

      // For each product, show if it is in the list of products to show,
      // otherwise hide it
      products.forEach((product) => {
        if (productsToShow.includes(product)) {
          product.classList.remove("is-hidden");
        } else {
          product.classList.add("is-hidden");
        }
      });
    });
  });
}

// Load on document load
document.addEventListener("turbo:load", ready);
