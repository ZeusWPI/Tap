import { createApp } from "petite-vue";

// Start petite-vue on page load
document.addEventListener("turbolinks:load", () => {
  createApp().mount();
});

// Start petite-vue on frame load
document.addEventListener("turbo:frame", () => {
  createApp().mount();
});
