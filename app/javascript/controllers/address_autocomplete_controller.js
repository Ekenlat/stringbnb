import { Controller } from "@hotwired/stimulus"
import mapboxgl from "mapbox-gl"
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder"

// Connects to data-controller="address-autocomplete"
export default class extends Controller {
  static values = { apiKey: String }

  connect() {
    mapboxgl.accessToken = this.apiKeyValue

    this.geocoder = new MapboxGeocoder({
      accessToken: mapboxgl.accessToken,
      types: 'address',
      countries: 'fr',
      placeholder: 'Commence à taper une adresse…',
      mapboxgl: mapboxgl,
    })

    this.geocoder.addTo(this.element)

    // Quand une adresse est choisie, remplit le champ texte caché avec la valeur complète
    this.geocoder.on('result', (e) => {
      const addressInput = document.getElementById('instrument_address')
      if (addressInput) addressInput.value = e.result.place_name
    })
  }
}
