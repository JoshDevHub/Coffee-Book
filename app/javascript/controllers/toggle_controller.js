import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = [ "change" ];
  static targets = [ "toggleElement" ];

  switch() {
    this.toggleElementTarget.classList.toggle(this.changeClass);
  }
}
