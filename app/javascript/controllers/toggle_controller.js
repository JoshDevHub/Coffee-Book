import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = [ "change" ];
  static targets = [ "toggleElement", "count" ];

  switch() {
    this.toggleElementTarget.classList.toggle(this.changeClass);
  }

  countSwitch(event) {
    const integerCount = Number(this.countTarget.textContent);
    const elementHasClass = this.toggleElementTarget.classList.contains(this.changeClass);
    const maxLength = event.params.max;

    if (integerCount > maxLength && !elementHasClass) {
      this.toggleElementTarget.classList.add(this.changeClass);
    } else if (integerCount <= maxLength && elementHasClass) {
      this.toggleElementTarget.classList.remove(this.changeClass);
    }
  }
}
