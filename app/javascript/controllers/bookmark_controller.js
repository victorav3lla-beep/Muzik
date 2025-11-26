import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["icon", "count"]
  static values = {
    bookmarked: Boolean,
    count: Number
  }

  connect() {
    console.log("Bookmark controller connected", this.bookmarkedValue, this.countValue)
  }

  toggle(event) {
    // Don't prevent default - let Turbo handle the form submission

    // Add animation to the icon
    if (this.hasIconTarget) {
      this.iconTarget.classList.add("heart-pop")

      setTimeout(() => {
        this.iconTarget.classList.remove("heart-pop")
      }, 300)
    }

    // Add loading state
    this.element.style.opacity = "0.7"
    this.element.style.pointerEvents = "none"
  }

  // This is called automatically after Turbo Stream replaces the content
  bookmarkedValueChanged() {
    this.animateSuccess()
  }

  countValueChanged() {
    if (this.hasCountTarget) {
      this.animateCount()
    }
  }

  animateSuccess() {
    // Remove loading state
    this.element.style.opacity = "1"
    this.element.style.pointerEvents = "auto"

    // Add success animation
    this.element.classList.add("bookmark-success")

    setTimeout(() => {
      this.element.classList.remove("bookmark-success")
    }, 600)
  }

  animateCount() {
    if (this.hasCountTarget) {
      this.countTarget.style.transform = "scale(1.2)"

      setTimeout(() => {
        this.countTarget.style.transform = "scale(1)"
      }, 200)
    }
  }
}
