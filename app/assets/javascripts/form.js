/**
 * Remove form field that are removed by vanilla_nested from the DOM.
 */
function ready() {
  document.addEventListener("vanilla-nested:fields-removed", (e) => {
    console.log("here");
    console.log(e.target.remove);
  });
}

// Load on document load or between turbolink navigations
document.addEventListener("turbolinks:load", ready);
