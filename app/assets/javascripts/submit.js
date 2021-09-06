/**
 * Handle checkboxes that want to submit the parent form on change event.
 */
function readySubmit() {
  // Find all elements with the data-submit attribute
  const checkboxes = document.querySelectorAll("[data-submit]");

  // When the checkbox state changes, submit the form
  checkboxes.forEach((element) => {
    element.addEventListener("change", () => {
      element.closest("form").submit();
    });
  });
}

// Load on document load or between turbolink navigations
document.addEventListener("turbolinks:load", readySubmit);
