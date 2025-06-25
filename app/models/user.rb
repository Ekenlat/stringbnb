class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # A user can propose many instruments and make many bookings which will be destroyed if the user is deleted.
  has_many :instruments, dependent: :destroy

  # A user can book many instruments, and the bookings will persist if the user is deleted (for historical records).
  # This is useful for keeping track of past bookings even if the user account is deleted.
  has_many :bookings

  # A user can write many reviews, which will persist if the user is deleted.
  has_many :reviews
end
