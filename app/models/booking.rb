class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :instrument

  enum status: { pending: 0, accepted: 1, rejected: 2, cancelled: 3 }

  # Validations
  # A booking must have a user, instrument, starting date, ending date, total price, and status.
  validates :user_id, :instrument_id, presence: true
  validates :starting_date, presence: true
  validates :ending_date, presence: true, comparison: { greater_than_or_equal_to: :starting_date }
  validates :total_price, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w[pending accepted cancelled] }

  # statut par défaut à "pending" lors de l'initialisation si rien n'est précisé
  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= "pending"
  end
end
