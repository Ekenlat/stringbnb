import { Controller } from "@hotwired/stimulus"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

export default class extends Controller {
  static targets = ["address"]
  static values = { apiKey: String }

  connect() {
    console.log("Controller connecté")
    console.log("Champ address trouvé :", this.hasAddressTarget)
    console.log("Clé API Mapbox :", this.apiKeyValue)

    if (!this.hasAddressTarget) {
      console.warn("Aucun champ address trouvé (target 'address')")
      return
    }

    if (!this.apiKeyValue) {
      console.warn("Clé API Mapbox manquante")
      return
    }

    this.geocoder = new MapboxGeocoder({
      accessToken: this.apiKeyValue,
      types: "country,region,place,postcode,locality,neighborhood,address",
      placeholder: this.addressTarget.placeholder || "Rechercher une adresse",
      autocomplete: true
    })

    this.geocoder.addTo(this.element)

    this.addressTarget.classList.add("d-none")

    this.geocoder.on("result", (event) => {
      console.log("Résultat reçu :", event)
      if (event.result && event.result.place_name) {
        this.addressTarget.value = event.result.place_name
      } else {
        console.warn("Résultat invalide :", event)
      }
    })

    this.geocoder.on("clear", () => {
      console.log("Champ effacé")
      this.addressTarget.value = ""
    })
  }

  disconnect() {
    if (this.geocoder) this.geocoder.onRemove()
  }
}
