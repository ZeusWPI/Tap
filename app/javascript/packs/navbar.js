/**
 * Handle navbar expansion menu on mobile
 */
function ready() {
  // Get all "navbar-burger" elements
  const navbarBurgers = document.querySelectorAll(".navbar-burger");

  // Check if there are any navbar burgers
  // Add a click event on each of them
  navbarBurgers.forEach((element) => {
    element.addEventListener("click", (e) => {
      e.preventDefault();

      // Find the navbar menu
      const navbarMenu = element
        .closest(".navbar")
        .querySelector(".navbar-menu");

      // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
      element.classList.toggle("is-active");
      navbarMenu.classList.toggle("is-active");
    });
  });
}

// Load on document load or between turbolink navigations
document.addEventListener("turbo:load", ready);
