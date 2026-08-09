import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="scanner"
export default class extends Controller {
    static targets = [ "laser", "loader", "error", "errorTitle", "errorMessage" ];

    initialize() {
        this.scanner = new BarcodeScanner("#barcodeCanvas");
        this.loading = true;
        this.error = null;
    }

    connect() {
        this.scanner.onDetected = (barcode) => {
            // Update the hidden barcode field.
            document.getElementById("orderBarcodeScannerFormInput").value = barcode.codeResult.code;

            // Submit the form
            const form = document.getElementById("orderBarcodeScannerForm");
            if (form.requestSubmit) {
                form.requestSubmit();
            } else {
                form.submit();
            }

            // Close modal
            window.closeModal("modalOrderScanner");
        }

        this.scanner.onSuccess = () => {
            this.loading = false;
            this.updateViews();
        }

        this.scanner.onError = (error) => {
            this.loading = false;
            this.error = {};

            if (error.name === "NotAllowedError") {
                this.error.title = "Camera access denied!";
                this.error.message = "Please allow camera access for this site and reload the webpage.";
            } else {
                this.error.title = error.name;
                this.error.message = error.message;
            }
            this.updateViews();
        }
        this.updateViews();
    }

    init(event) {
        if (event.currentTarget === this.element) {
            this.scanner.init();
        }
    }

    destroy() {
        if (event.currentTarget === this.element) {
            this.scanner.destroy();
            this.loading = true;
            this.error = null;
            this.updateViews();
        }
    }

    updateViews() {
        this.laserTarget.classList.toggle("is-hidden", this.error || this.loading);
        this.loaderTarget.classList.toggle("is-hidden", !this.loading);
        this.errorTarget.classList.toggle("is-hidden", !this.error);
        this.errorTitleTarget.innerText = this.error?.title ?? "";
        this.errorMessageTarget.innerText = this.error?.message ?? "";
    }
}
