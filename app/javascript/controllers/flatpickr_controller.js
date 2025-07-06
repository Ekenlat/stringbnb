import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr";
// Connects to data-controller="flatpickr"
export default class extends Controller {
  static targets = ["startDate", "endDate"]

  connect() {
    this.startCalendar = flatpickr(this.startDateTarget, {
      altInput: true,
      // Si on modifie la date de début, on met à jour la date de fin
      // pour qu'elle soit toujours postérieure à la date de début
      onChange: this.handleStartDateChange.bind(this)
    })

    this.endCalendar = flatpickr(this.endDateTarget, {
      altInput: true,
      // On initialise la date de fin avec la date de début
      minDate: this.startDateTarget.value
    })
  }

  // Cette méthode est appelée lorsque la date de début change
  handleStartDateChange(selectedDates) {
    if (selectedDates.length > 0) {
      const selectedDate = selectedDates[0]
      this.endCalendar.set("minDate", selectedDate)
    }
  }
}
