import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";
// Connects to data-controller="flatpickr"
export default class extends Controller {
  static targets = ["startDate", "endDate"]
  static values = { pricePerDay: Number }

  connect() {
    // fix :on cherche le total price dans le scope du controller
    this.totalPriceElement = this.element.querySelector("#total-price")
    this.startCalendar = flatpickr(this.startDateTarget, {
      altInput: true,
      // Si on modifie la date de début, on met à jour la date de fin
      // pour qu'elle soit toujours postérieure à la date de début
      onChange: this.handleStartDateChange.bind(this)
    })

    this.endCalendar = flatpickr(this.endDateTarget, {
      altInput: true,
      // On initialise la date de fin avec la date de début
      minDate: this.startDateTarget.value,
      onChange: this.handleDateChange.bind(this)
    })
  }

  // Cette méthode est appelée lorsque la date de début change
  handleStartDateChange(selectedDates) {
    if (selectedDates.length > 0) {
      const selectedDate = selectedDates[0]
      this.endCalendar.set("minDate", selectedDate)
    }
    // on recalcule le prix à chaque changement de start
    this.updateTotalPrice()
  }

  // Cette méthode est appelée quand la date de fin change
  handleDateChange(selectedDates) {
    this.updateTotalPrice()
  }

  // Méthode JS centrale pour afficher le prix total en live
  updateTotalPrice() {
    const startDate = this.startCalendar.selectedDates[0]
    const endDate = this.endCalendar.selectedDates[0]
    if (startDate && endDate && endDate > startDate) {
      const days = (endDate - startDate) / (1000 * 60 * 60 * 24)
      const total = days * this.pricePerDayValue
      this.totalPriceElement.classList.remove("d-none")
      this.totalPriceElement.textContent = `Total price: ${total} €`
    } else {
      this.totalPriceElement.classList.add("d-none")
      this.totalPriceElement.textContent = ""
    }
  }
}
