import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "menu", "toggle" ];

  toggleVisibility() {
    this.menuTarget.classList.toggle("hidden");
  }

  hide(event) {
    if (event.target !== this.toggleTarget &&
        !this.menuTarget.classList.contains("hidden")) {
      this.menuTarget.classList.add("hidden");
    }
  }
}
