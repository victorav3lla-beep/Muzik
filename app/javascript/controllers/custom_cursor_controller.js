import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["dot", "circle"]

  connect() {
    this.dotX = 0
    this.dotY = 0
    this.circleX = 0
    this.circleY = 0

    this.onMouseMove = this.moveCursor.bind(this)
    this.onMouseEnter = this.expandCursor.bind(this)
    this.onMouseLeave = this.shrinkCursor.bind(this)

    window.addEventListener("mousemove", this.onMouseMove)

    // Add hover effects on clickable elements
    this.addHoverEffects()

    // Start animation loop
    this.animate()
  }

  disconnect() {
    window.removeEventListener("mousemove", this.onMouseMove)
    this.removeHoverEffects()
  }

  moveCursor(e) {
    this.dotX = e.clientX
    this.dotY = e.clientY
  }

  animate() {
    // Smooth follow effect for the circle
    const speed = 0.01

    this.circleX += (this.dotX - this.circleX) * speed
    this.circleY += (this.dotY - this.circleY) * speed

    // Update positions
    if (this.hasDotTarget) {
      this.dotTarget.style.left = `${this.dotX}px`
      this.dotTarget.style.top = `${this.dotY}px`
    }

    if (this.hasCircleTarget) {
      this.circleTarget.style.left = `${this.circleX}px`
      this.circleTarget.style.top = `${this.circleY}px`
    }

    requestAnimationFrame(this.animate.bind(this))
  }

  addHoverEffects() {
    const clickables = document.querySelectorAll('a, button, .btn, .card-custom, input, textarea')

    clickables.forEach(el => {
      el.addEventListener('mouseenter', this.onMouseEnter)
      el.addEventListener('mouseleave', this.onMouseLeave)
    })
  }

  removeHoverEffects() {
    const clickables = document.querySelectorAll('a, button, .btn, .card-custom, input, textarea')

    clickables.forEach(el => {
      el.removeEventListener('mouseenter', this.onMouseEnter)
      el.removeEventListener('mouseleave', this.onMouseLeave)
    })
  }

  expandCursor() {
    if (this.hasCircleTarget) {
      this.circleTarget.style.transform = 'translate(-50%, -50%) scale(1.5)'
      this.circleTarget.style.borderColor = '#ff953d'
    }
    if (this.hasDotTarget) {
      this.dotTarget.style.transform = 'translate(-50%, -50%) scale(0.5)'
    }
  }

  shrinkCursor() {
    if (this.hasCircleTarget) {
      this.circleTarget.style.transform = 'translate(-50%, -50%) scale(1)'
      this.circleTarget.style.borderColor = 'rgba(255, 149, 61, 0.5)'
    }
    if (this.hasDotTarget) {
      this.dotTarget.style.transform = 'translate(-50%, -50%) scale(1)'
    }
  }
}
