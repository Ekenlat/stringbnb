class Instrument < ApplicationRecord
  belongs_to :user

  # An instrument can be booked many times and the bookings will persist if the instrument is deleted for historical records.
  # This is useful for keeping track of past bookings even if the instrument is deleted.
  has_many :bookings

  # An instrument can receive many reviews, all will be destroyed if the instrument is deleted.
  has_many :reviews, dependent: :destroy

  # Validations
  # An instrument must have a name, description, size, instrument type, status, and price per day.

  # For instrument types, we use a predefined list to avoid input errors. Add more types to make it exhaustive.
  validates :instrument_type, presence: true, inclusion: { in: %w[String Woodwind Brass Percussion Electronic] }
  validates :price_per_day, presence: true, numericality: { greater_than: 0 }
  validates :size, presence: true, inclusion: { in: %w[Standard Large Compact Mini XL] }
  validates :description, presence: true, length: { minimum: 10, maximum: 400 }
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :status, presence: true, inclusion: { in: %w[available booked maintenance] }


end
