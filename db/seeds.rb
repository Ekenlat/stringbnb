# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

puts "Resetting DB..."
Booking.destroy_all
Review.destroy_all
Instrument.destroy_all
User.destroy_all

prenoms = %w[Audric Barthelemy Nour Baptiste Jonathan]
users = []

# crée les users ( j'ai  enlevé le role sur conseil du prof dans les migrations )
prenoms.each do |prenom|
  users << User.create!(
    email: "#{prenom.downcase}@test.com",
    first_name: prenom,
    last_name: prenom,
    address: Faker::Address.full_address,
    phone_number: Faker::PhoneNumber.cell_phone_in_e164,
    password: "azerty"
  )
end

instrument_names = [
  "Gibson Les Paul",
  "Fender Stratocaster",
  "Yamaha P45",
  "Roland FP-30",
  "Ibanez RG"
]

# Petit changement sur les types d'instruments pour coller avec les validations du modèle
instrument_types = %w[String Woodwind Brass Percussion Electronic]
sizes = %w[Standard Large Compact Mini XL]

instruments = []

# crée 5 instruments, attribués à tour de rôle à Audric et bartelhemy
5.times do |i|
  owner = users[i % 2] # alterne entre Audric et Barthelemy
  instruments << Instrument.create!(
    instrument_type: instrument_types[i % instrument_types.length],
    price_per_day: rand(10..50),
    size: sizes.sample,
    user: owner,
    description: Faker::Lorem.sentence(word_count: 8),
    status: "available",
    name: instrument_names[i % instrument_names.length]
  )
end

# Chaque user restant booke un instrument différent
users[2..-1].each_with_index do |user, i|
  Booking.create!(
    starting_date: Date.today + i,
    ending_date: Date.today + i + rand(1..5),
    user: user,
    instrument: instruments[i],
    total_price: instruments[i].price_per_day * rand(1..5),
    status: %w[pending confirmed cancelled].sample
  )
end

# Chaque booking reçoit un review random
Booking.all.each do |booking|
  Review.create!(
    rating: rand(3..5),
    comment: Faker::Hipster.sentence,
    user: booking.user,
    instrument: booking.instrument
  )
end

puts "Seed finished"
