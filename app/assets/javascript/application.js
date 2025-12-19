import "@hotwired/turbo-rails";
import "chartkick/chart.js";
import "vanilla-nested";
import * as PetiteVue from "petite-vue";
import Quagga from "@ericblade/quagga2";
import Rails from "@rails/ujs";

// Start petite-vue on page and frame load
document.addEventListener("turbo:load", () => PetiteVue.createApp().mount());
document.addEventListener("turbo:frame-load", () => PetiteVue.createApp().mount());

// Globally mount Quagga
window.Quagga = Quagga;

Rails.start();

// Register a service worker
import "./pwa";

// Globally mount some utils
import "./utils/filepicker";
import "./utils/modal";
import "./utils/remove";
import "./utils/scanner";
import "./utils/submit";

// Script that only runs for koelkast user
import "./mqtt"
