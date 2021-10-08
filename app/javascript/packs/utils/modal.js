/**
 * Utilities and events for working with modals.
 */
function ready() {
  // Listen to the hash change and notify a potential modal open/close listener
  window.addEventListener("turbolinks:click", (e) => {
    // Get the hashes from the event urls
    const oldHash = window.location.hash.replace("#", "");
    const newHash = e.data.url.split("#")[1];

    // If the hash contains a value, emit a potential modal close event.
    // Otherwise emit a potential modal open event.
    if (newHash) {
      window.dispatchEvent(
        new CustomEvent("modal:open", { detail: { id: newHash } })
      );
    } else {
      window.dispatchEvent(
        new CustomEvent("modal:close", { detail: { id: oldHash } })
      );
    }
  });
}

// Load on document load or between turbolink navigations
document.addEventListener("turbolinks:load", ready);
