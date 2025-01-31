import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["count", "total", "decrementButton", "incrementButton"]
  static values = {
    price: Number,
    available: Number
  }

  connect() {
    this.count = 1
    this.updateDisplay()
  }

  increment() {
    if (this.count < this.availableValue) {
      this.count++
      this.updateDisplay()
    }
  }

  decrement() {
    if (this.count > 1) {
      this.count--
      this.updateDisplay()
    }
  }

  updateDisplay() {
    // Mise à jour du compteur
    this.countTarget.textContent = this.count

    // Mise à jour du prix total
    const total = (this.count * this.priceValue).toFixed(2)
    this.totalTarget.textContent = `${total} €`

    // Gestion des boutons
    this.decrementButtonTarget.disabled = this.count <= 1
    this.incrementButtonTarget.disabled = this.count >= this.availableValue

    // Mise à jour des classes pour les boutons désactivés
    this.decrementButtonTarget.classList.toggle("opacity-50", this.count <= 1)
    this.incrementButtonTarget.classList.toggle("opacity-50", this.count >= this.availableValue)
  }
} 