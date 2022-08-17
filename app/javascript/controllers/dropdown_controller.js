import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "menu", "toggleBtn" ];

  toggleVisibility() {
    this.menuTarget.classList.toggle("hidden");
  }

  hide(event) {
    if (event.target !== this.toggleBtnTarget &&
        !this.menuTarget.classList.contains("hidden")) {
      console.log("happens")
      this.menuTarget.classList.add("hidden");
    }
  }
}
