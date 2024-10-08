import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["brand", "pricePerPack", "quantityPerPack", "results"]

  connect() {
    this.resultsTarget.style.display = 'none'
  }

  search() {
    const query = this.brandTarget.value

    if (query.length < 2) {
      this.resultsTarget.style.display = 'none'
      return
    }

    fetch(`/smoker/cigarettes/brands?query=${encodeURIComponent(query)}`)
      .then(response => response.json())
      .then(data => {
        this.resultsTarget.innerHTML = data.map(brand => `
          <li class="p-2 hover:bg-gray-700 cursor-pointer" data-action="click->cigarette-form#select" data-name="${brand.name}" data-price="${brand.price_per_pack}" data-quantity="${brand.quantity_per_pack}">
            ${brand.name}
          </li>
        `).join('')
        this.resultsTarget.style.display = 'block'
      })
  }

  select(event) {
    const { name, price, quantity } = event.target.dataset
    this.brandTarget.value = name
    this.pricePerPackTarget.value = price
    this.quantityPerPackTarget.value = quantity
    this.resultsTarget.style.display = 'none'
  }
}