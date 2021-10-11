import { createApp } from "petite-vue";

// Start petite-vue on page load
document.addEventListener("turbo:load", () => {
  createApp().mount();
});

// Start petite-vue on frame load
document.addEventListener("turbo:frame-load", () => {
  createApp().mount();
});
