import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "image" ];

  show(event) {
    if (event.target.files.length > 0) {
      const src = URL.createObjectURL(event.target.files[0]);
      this.imageTarget.src = src;
      this.imageTarget.style.display = "block";
      this.imageTarget.style.width = "80px";
    }
  }
}
