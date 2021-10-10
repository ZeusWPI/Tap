/**
 * Update the label of a file picker with the name of the file when the user selects a file.
 */
function ready() {
  // Find all available filepickers
  const fileInputs = document.querySelectorAll("input[type=file]");

  // For each filepicker, update the label on file selection.
  fileInputs.forEach((fileInput) => {
    fileInput.addEventListener("change", (event) => {
      const file = event.target.files[0];

      // Find the label for the file picker
      for (const child of event.target.parentElement.children) {
        if (child.className === "file-name") {
          child.innerText = file.name;
        }
      }
    });
  });
}

// Load on document load or between turbolink navigations
document.addEventListener("turbo:load", ready);
