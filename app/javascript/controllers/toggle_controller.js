import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = [ "change" ];
  static targets = [ "toggleElement" ];

  switch() {
    this.toggleElementTargets.forEach((target) => {
      target.classList.toggle(this.changeClass);
    })
  }
}
