function ready() {
  // Find all flash messages
  const flashMessages = document.querySelectorAll("#flash");

  // Close the flash message when the close button is clicked.
  flashMessages.forEach((flashMessage) => {
    const close = flashMessage.querySelector(".delete");

    close.addEventListener("click", () => {
      flashMessage.style.display = "none";
    });
  });
}

// Load on document load
document.addEventListener("turbo:load", ready);
