import { formatPrice } from "../helpers/price.js";

/**
 * Handle modal opening/closing
 */
function ready() {
  // Get all modals
  const modals = document.querySelectorAll(".modal");

  // For each modal, get the id and add an event listener for opening and closing set modal.
  modals.forEach((modal) => {
    const id = modal.id;
    const openElements = document.querySelectorAll(`[data-modal-open="${id}"]`);
    const closeElements = document.querySelectorAll(
      `[data-modal-close="${id}"], .modal-background`
    );

    // Add modal open event listeners
    openElements.forEach((element) => {
      element.addEventListener("click", () => {
        modal.classList.add("is-active");

        // Emit open event
        document.dispatchEvent(
          new CustomEvent("modal:open", { detail: { id } })
        );
      });
    });

    // Add modal close event listeners
    closeElements.forEach((element) => {
      element.addEventListener("click", () => {
        modal.classList.remove("is-active");

        // Emit close event
        document.dispatchEvent(
          new CustomEvent("modal:close", { detail: { id } })
        );
      });
    });
  });
}

// Load on document load
document.addEventListener("turbo:load", ready);
