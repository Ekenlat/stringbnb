class Instrument < ApplicationRecord
  belongs_to :user

  # An instrument can be booked many times and the bookings will persist if the instrument is deleted for historical records.
  # This is useful for keeping track of past bookings even if the instrument is deleted.
  has_many :bookings

  # An instrument can receive many reviews, all will be destroyed if the instrument is deleted.
  has_many :reviews, dependent: :destroy


end
