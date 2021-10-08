import Turbolinks from "turbolinks";

// Start Turbolinks
Turbolinks.start();

// Prevent Turbolinks from sending a new GET request when an anchor tag is clicked.
// Anchor tags should be handled by the client, not the server.
document.addEventListener("turbolinks:click", (event) => {
  const element = event.target;

  // Check if the link of the element is a same page anchor.
  if (
    element.hash &&
    element.origin === window.location.origin &&
    element.pathname === window.location.pathname
  ) {
    // Prevent default behavior.
    event.preventDefault();

    // Push the new URL to the history.
    Turbolinks.controller.pushHistoryWithLocationAndRestorationIdentifier(
      event.data.url,
      Turbolinks.uuid()
    );
  }
});
