class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook google_oauth2]

  # A user can propose many instruments and make many bookings which will be destroyed if the user is deleted.
  has_many :instruments, dependent: :destroy

  # A user can book many instruments, and the bookings will persist if the user is deleted (for historical records).
  # This is useful for keeping track of past bookings even if the user account is deleted.
  has_many :bookings

  # A user can write many reviews, which will persist if the user is deleted.
  has_many :reviews

  # un owner peut voir ses listings d'instruments
  has_many :listings, class_name: 'Instrument', foreign_key: 'user_id'

  # Validations
  # A user must have a first name, last name, address, and phone number (email and password are handled by Devise).

  validates :first_name, :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :address, presence: true, length: { minimum: 10, maximum: 200 }
  validates :phone_number, presence: true, length: { minimum: 10, maximum: 15 },
                           format: { with: /\A\+?\d{10,15}\z/, message: "must be a valid phone number" }

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.first_name = auth.info.first_name || auth.info.name.split(' ').first
      user.last_name = auth.info.last_name || auth.info.name.split(' ').last
      user.password = Devise.friendly_token[0, 20]
      user.address = "Adresse inconnue" # à adapter selon ton modèle
      user.phone_number = "+0000000000" # à adapter selon ton modèle
    end
  end
end
