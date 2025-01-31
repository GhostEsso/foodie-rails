import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container"]
  static values = { behavior: String }

  connect() {
    this.scrollToBottom()
    this.setupMutationObserver()
  }

  scrollToBottom() {
    this.containerTarget.scrollTop = this.containerTarget.scrollHeight
  }

  setupMutationObserver() {
    const observer = new MutationObserver((mutations) => {
      this.scrollToBottom()
    })

    observer.observe(this.containerTarget, {
      childList: true,
      subtree: true
    })
  }
} 