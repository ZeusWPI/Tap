/**
 * Utilities and events for working with modals.
 */
function ready() {
  // Listen to the hash change and notify a potential modal open/close listener
  window.addEventListener("hashchange", (e) => {
    // Get the hashes from the event urls
    const oldHash = e.oldURL.split("#")[1];
    const newHash = e.newURL.split("#")[1];

    // Get the modal id from the hash
    const modalId = newHash || oldHash;

    // Get the modal element
    const modal = document.getElementById(modalId);

    // If the hash contains a value, emit a potential modal close event.
    // Otherwise emit a potential modal open event.
    modal.dispatchEvent(
      new CustomEvent(newHash ? "modal:open" : "modal:close", {
        detail: { id: modalId },
      })
    );
  });
}

// Load on document load
document.addEventListener("DOMContentLoaded", ready);

/**
 * Function for closing a modal using JavaScript
 * Used when a button already acts as a form submit.
 * @param {string} id id of the modal to close.
 */
window.closeModal = (id) => {
  // Make sure the current open modal is the modal with the given id
  if (window.location.hash.replace("#", "") === id) {
    // Remove the hash from the URL to close the modal
    window.location.hash = "";
  }
};
