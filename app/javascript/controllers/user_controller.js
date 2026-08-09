import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="user"
export default class extends Controller {
    static targets = [ "dagschotel", "dagschotelLoader", "avatar", "avatarLoader", "userLink" ]

    orderedDagschotel(event) {
        this.dagschotelTarget.classList.add("user-dagschotel--loading");
        this.dagschotelTarget.disabled = true;
        this.dagschotelLoaderTarget.classList.remove("is-hidden");
        event.currentTarget.closest('form').submit();
    }

    openedUser() {
        if (this.hasDagschotelTarget) {
            this.dagschotelTarget.classList.add("is-hidden");
        }
        this.avatarTarget.classList.add("user-avatar--loading");
        this.avatarLoaderTarget.classList.remove("is-hidden");
        this.userLinkTarget.disabled = true;
    }

}
