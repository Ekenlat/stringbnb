class Instrument < ApplicationRecord
  # For instrument types and sizes, we use a predefined list to avoid input errors. Add more types to make it exhaustive. This constant is called in create and update actions.
  INSTRUMENT_TYPES = %w[Guitare Violon Piano Clarinette Batterie Flûte\ traversière Saxophone
                        Contrebasse Trompette Harp Guitare\ électrique Accordéon Ukulélé Xylophone Harmonica].freeze
  INSTRUMENT_SIZES = %w[Standard Large Compact Mini XL].freeze

  belongs_to :user

  # An instrument can be booked many times and the bookings will persist if the instrument is deleted for historical records.
  # This is useful for keeping track of past bookings even if the instrument is deleted.
  has_many :bookings, dependent: :destroy

  # Status utilisé pour contrôler si un instrument apparaît ou non dans les listings
  # Le propriétaire pourra changer ce statut depuis son dashboard (ex : mettre "unavailable" pour le retirer temporairement).
  enum status: { available: "available", booked: "booked", unavailable: "unavailable" }

  # convertis l'adresse de l'instrumenten lat/lon automatiquement
  # a chaque fois que l'adresse change ou qu'on créé un instrument, on recupere les coords gps
  # pour pouvoir afficher l'instrument avec mapbox
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  # Each instrument can have multiple photos attached via Active Storage
  # Used for instrument listings so owners can upload several images per instrument
  has_many_attached :photos

  # An instrument can receive many reviews, all will be destroyed if the instrument is deleted.
  has_many :reviews, dependent: :destroy

  # Validations
  # An instrument must have a name, description, size, instrument type, status, and price per day.

  validates :instrument_type, presence: true, inclusion: { in: INSTRUMENT_TYPES }
  validates :price_per_day, presence: true, numericality: { greater_than: 0 }
  validates :size, presence: true, inclusion: { in: INSTRUMENT_SIZES }
  validates :description, presence: true, length: { minimum: 10, maximum: 400 }
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :address, presence: true, length: { minimum: 10, maximum: 120 }

  def average_rating
    return nil if reviews.empty?

    reviews.average(:rating).round(1)
  end

  def reviews_count
    reviews.count
  end

  def latest_reviews(n = 2)
    reviews.order(created_at: :desc).limit(n)
  end
end
