import "@hotwired/turbo-rails";
import "chartkick/chart.js";
import "vanilla-nested";
import Quagga from "@ericblade/quagga2";

// Globally mount Quagga
window.Quagga = Quagga;

// Register a service worker
import "./pwa";

// Register stimulus controllers
import "./controllers";

// Globally mount some utils
import "./utils/filepicker";
import "./utils/modal";
import "./utils/remove";
import "./utils/scanner";
import "./utils/submit";

// Script that only runs for koelkast user
import "./mqtt"
