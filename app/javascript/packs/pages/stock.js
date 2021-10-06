function ready() {
  // Get all stock forms
  const stockForms = document.querySelectorAll("#stock");

  // For each stock form, add the behaviour
  stockForms.forEach((stockForm) => {
    const stockOld = stockForm.dataset.stock;

    // Get the purchased stock input value
    const stockPurchased = stockForm.querySelector("#stockPurchasedInput");
    const stockValue = stockForm.querySelector("#stockValue");

    // Update the stock value when the input changes
    stockPurchased.addEventListener("input", () => {
      const stockNew = parseInt(stockOld) + parseInt(stockPurchased.value || 0);

      // Update the hidden stock value
      stockValue.value = stockNew;

      // Update the stock text
      stockForm.querySelector("#stockNew").innerHTML = stockNew;
    });
  });
}

// Load on document load
document.addEventListener("turbo:load", ready);
