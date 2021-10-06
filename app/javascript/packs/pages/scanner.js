class BarcodeScanner {
  /**
   * Create a barcode scanner
   * @param {str} selector Selector of the element to mount the scanner canvas to.
   */
  constructor(selector) {
    this.selector = selector;

    // Intialize empty callbacks
    this.detectedCallback = () => {};
    this.successCallback = () => {};
    this.errorCallback = () => {};

    // Audio to play when an item is scanned.
    this.beepAudio = new Audio("/audios/scanner-beep.mp3");

    // Detected handler
    this.detectedHandler = (result) => {
      // Play the beep audio
      this.beepAudio.play();

      // Stop Quagga
      Quagga.stop();

      // Trigger callback
      this.detectedCallback(result);
    };
  }

  /**
   * Callback when the setup was successful.
   */
  set onSuccess(successCallback) {
    this.successCallback = successCallback;
  }

  /**
   * Callback when the setup failed.
   */
  set onError(errorCallback) {
    this.errorCallback = errorCallback;
  }

  /**
   * Callback when the scanner has detected a barcode.
   */
  set onDetected(detectedCallback) {
    this.detectedCallback = detectedCallback;
  }

  /**
   * Initialize the barcode scanner.
   * @param scanCallback Callback, receiving the barcode, when a barcode has been scanned.
   */
  init() {
    // Initialize the barcode scanner
    Quagga.init(
      {
        // Video input stream
        inputStream: {
          name: "Live",
          type: "LiveStream",
          target: document.querySelector(this.selector),
          constraints: {
            facingMode: "environment",
          },
        },

        // Available decoders for decoding barcodes.
        decoder: {
          readers: ["ean_reader"],
        },

        // Disable auto-locate of barcodes on the screen.
        // This is turned off to prevent bad auto-focus.
        // We will show a guidebox to guide the user.

        // Enable the scanner to look for barcodes around the screen.
        locate: true,

        // Locator settings
        // Used when locate is enabled
        locator: {
          patchSize: "medium",
          halfSample: true,
        },
      },
      (error) => {
        // Catch a potential error by calling the error callback.
        if (error) {
          this.errorCallback(error);
          return;
        }

        Quagga.start();
        this.successCallback();

        // Attempt to apply some settings, like autofocus, when supported.
        try {
          // Quagga internal MediaStreamTrack instance.
          const track = Quagga.CameraAccess.getActiveTrack();

          // Get the track MediaTrackCapabilities object.
          const capabilities = track.getCapabilities();

          console.log(capabilities);
          console.log(track.getSettings());

          // Set the framerate to 0
          if (capabilities.saturation) {
            track.applyConstraints({
              advanced: [{ saturation: 50 }],
            });
          }

          // Set focusMode to "continuous" if supported.
          if (capabilities.focusMode) {
            track.applyConstraints({
              advanced: [
                {
                  focusMode: "continuous",
                },
              ],
            });
          }
        } catch (e) {}
      }
    );

    // When a barcode has been detected
    Quagga.onDetected(this.detectedHandler);
  }

  /**
   * Destroy the barcode scanner.
   */
  destroy() {
    Quagga.stop();
    Quagga.offDetected(this.detectedHandler);
  }
}

window.BarcodeScanner = BarcodeScanner;

/**
 * Handle the barcode scanner modal.
 */
function ready() {
  // Barcode Scanner
  const scanner = new BarcodeScanner("#barcodeScannerCanvas");

  // Set the scan callback
  scanner.onDetected = (barcode) => {
    // Emit a barcode scan event to the order form
    document.dispatchEvent(
      new CustomEvent("barcode:scan", {
        detail: {
          barcode,
        },
      })
    );
  };

  // Set loaded callback
  scanner.onSuccess = () => {
    // Hide the loading text
    document.querySelector("#barcodeScannerLoading").classList.add("is-hidden");

    // Show the laser
    document
      .querySelector("#barcodeScannerLaser")
      .classList.remove("is-hidden");
  };

  // Set the error callback
  scanner.onError = (error) => {
    // Hide the loading text
    document.querySelector("#barcodeScannerLoading").classList.add("is-hidden");

    // Show the error text
    document
      .querySelector("#barcodeScannerError")
      .classList.remove("is-hidden");

    // Error message
    let title = error.name;
    let message = error.message;

    // Permission Denied
    if (error.name === "NotAllowedError") {
      title = "Camera access denied!";
      message =
        "Please allow camera access for this site and reload the webpage.";
    }

    // Update the error title & message
    document.querySelector("#barcodeScannerErrorTitle").innerText = title;
    document.querySelector("#barcodeScannerErrorMessage").innerText = message;
  };

  // Watch the modal open state for changes.
  // Init the barcode scanner.
  document.addEventListener("modal:open", (event) => {
    if (event.detail.id === "barcodeScannerModal") {
      scanner.init();
    }
  });

  // Watch the modal close state for changes.
  // Destroy the barcode scanner.
  document.addEventListener("modal:close", (event) => {
    if (event.detail.id === "barcodeScannerModal") {
      scanner.destroy();

      // Re-show the loading text
      // Re-hide the error text
      // Re-hide the laser
      document
        .querySelector("#barcodeScannerLoading")
        .classList.remove("is-hidden");
      document.querySelector("#barcodeScannerError").classList.add("is-hidden");
      document.querySelector("#barcodeScannerLaser").classList.add("is-hidden");
    }
  });
}

// Load on document load or between turbolink navigations
document.addEventListener("turbo:load", ready);
