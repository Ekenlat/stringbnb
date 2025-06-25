class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :instrument

  # Validations
  # A booking must have a user, instrument, starting date, ending date, total price, and status.
  validates :user_id, :instrument_id, presence: true
  validates :starting_date, presence: true
  validates :ending_date, presence: true, comparison: { greater_than_or_equal_to: :starting_date }
  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending confirmed cancelled] }

end
