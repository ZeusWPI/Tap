/**
 * Handle objects that want to be removed after a specific timeframe.
 * Used for example in the order list to cancel an order
 */
function readyRemove() {
  // Find all elements with the data-remove attribute
  const elements = document.querySelectorAll("[data-remove]");

  // Set a timeout for each element to remove the element
  elements.forEach((element) => {
    // Value of the data-remove attribute is in seconds
    const timeout = element.dataset.remove * 1000;

    // Remove the element after the timeout
    setTimeout(() => {
      element.remove();
    }, timeout);
  });
}

// Load on document load or between turbolink navigations
document.addEventListener("turbolinks:load", readyRemove);
