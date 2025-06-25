class Review < ApplicationRecord
  belongs_to :user
  belongs_to :instrument

  # Validations
  # A review must have a user, instrument, rating, and comment.

  validates :user_id, :instrument_id, presence: true
  validates :rating, presence: true, numericality: { only_integer: true, in: 0..5 }

  # A comment is not mandatory but if there is one it should have a minimum and maximum length.
  validates :comment, length: { minimum: 5, maximum: 500 }
end
