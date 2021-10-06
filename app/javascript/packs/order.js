import { formatPrice } from "../helpers/price.js";

/**
 * Order form.
 */
function ready() {
  // Function for updating the subtotal of the entire form.
  function updateForm() {
    // Find all elements with the "data-order-product-subtotal" attribute.
    // Map the value of "data-order-product-subtotal" to an array of integers and sum them.
    const totalCents = [
      ...document.querySelectorAll("[data-order-product-subtotal]"),
    ]
      .map((el) => parseInt(el.dataset.orderProductSubtotal))
      .reduce((a, b) => a + b, 0);

    // Show/hide the order placeholder depending on whether the total is 0.
    const orderPlaceholder = document.querySelector("#orderPlaceholder");
    if (totalCents === 0) {
      orderPlaceholder.classList.remove("is-hidden");
    } else {
      orderPlaceholder.classList.add("is-hidden");
    }

    // Update the total of the entire form.
    document.querySelector("#orderTotal").innerText = formatPrice(totalCents);
  }

  // Get all order item elements
  const items = document.querySelectorAll("#orderItem");

  items.forEach((item) => {
    const quantityField = item.querySelector("#orderItemQuantity");
    const subtotalField = item.querySelector("#orderItemSubtotal");
    const productId = item.dataset.orderProductId;
    const productPrice = item.dataset.orderProductPrice;
    const productBarcodes = item.dataset.orderProductBarcodes;

    // Function for updating the item when the quantity changes
    function updateItem() {
      const quantity = quantityField.value;

      // Hide/show the order item when the quantity is 0
      if (quantity <= 0) {
        item.classList.add("is-hidden");
      } else {
        item.classList.remove("is-hidden");
      }

      // Calculate the price in cents
      const priceCents = productPrice * quantity;

      // Update the subtotal field
      subtotalField.dataset.orderProductSubtotal = priceCents;
      subtotalField.innerHTML = formatPrice(priceCents);

      // Update the total price
      updateForm();
    }

    // Update the price field when the quantity field changes
    quantityField.addEventListener("change", updateItem);

    // Update the quantity when the user clicks on a product with data-order-product-increment="id"
    document
      .querySelector(`[data-order-product-increment="${productId}"]`)
      ?.addEventListener("click", () => {
        // Increment the quantity
        quantityField.value++;

        // Update the item
        updateItem();
      });

    // Update the quantity when the user clicks on a product with data-order-product-delete="id"
    document
      .querySelector(`[data-order-product-delete="${productId}"]`)
      ?.addEventListener("click", () => {
        // Set the quantity to 0
        quantityField.value = 0;

        // Update the item
        updateItem();
      });

    // Update the quantity when a barcode is scanned
    document.addEventListener("barcode:scanned", (e) => {
      if (productBarcodes.includes(e.detail.barcode)) {
        // Increment the quantity
        quantityField.value++;

        // Update the item
        updateItem();
      }
    });

    // Also update the price initially
    updateItem();
  });
}

// Load on document load
document.addEventListener("turbo:load", ready);
