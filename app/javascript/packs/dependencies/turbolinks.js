import Turbolinks from "turbolinks";

// Start Turbolinks
Turbolinks.start();

// Prevent Turbolinks from sending a new GET request when an anchor tag is clicked.
// Anchor tags should be handled by the client, not the server.
document.addEventListener("turbolinks:click", (e) => {
  const element = e.target;

  // Check if the link of the element is a same page anchor.
  if (
    element.origin === window.location.origin &&
    element.pathname === window.location.pathname
  ) {
    // Prevent default behavior.
    e.preventDefault();

    // Push the new URL to the history.
    Turbolinks.controller.pushHistoryWithLocationAndRestorationIdentifier(
      e.data.url,
      Turbolinks.uuid()
    );
  }
});
