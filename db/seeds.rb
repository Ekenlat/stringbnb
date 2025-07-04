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
require "open-uri"

puts "Resetting DB..."
Booking.destroy_all
Review.destroy_all
Instrument.destroy_all
User.destroy_all

prenoms = %w[Audric Barthelemy Nour Baptiste Jonathan]
noms = %w[Nomentsoa Terrier Cucculelli Harrag Masson]
users = []

# crée les users ( j'ai  enlevé le role sur conseil du prof dans les migrations )
prenoms.each_with_index do |prenom, i|
  users << User.create!(
    email: "#{prenom.downcase}@test.com",
    first_name: prenom,
    last_name: noms[i],
    address: Faker::Address.full_address,
    phone_number: Faker::PhoneNumber.cell_phone_in_e164,
    password: "azerty"
  )
  puts "Created user: #{users.last.first_name} #{users.last.last_name}"
end

INSTRUMENTS = {
  "Guitare" => "Guitare acoustique en bois massif, parfaite pour accompagner les soirées au coin du feu.",
  "Violon" => "Violon classique 4/4 avec un archet en crin naturel, très équilibré pour les concerts.",
  "Piano" => "Piano droit élégant, idéal pour les amateurs et les pianistes confirmés.",
  "Clarinette" => "Clarinette en résine, légère et parfaite pour les débutants ou les musiciens nomades.",
  "Batterie" => "Kit de batterie complet avec cymbales et toms, excellent pour les styles rock et jazz.",
  "Flûte traversière" => "Flûte traversière argentée, parfaite pour les solos classiques et les ensembles à vent."
}


valid_addresses = [
  "16 Villa Gaudelet, Paris",
  "18 Rue Sainte-Catherine, Bordeaux",
  "8 Place Bellecour, Lyon",
  "2 Rue de la République, Marseille",
  "10 Rue Nationale, Lille",
  "15 Avenue Jean Jaurès, Toulouse",
  "12 Place Masséna, Nice",
  "20 Avenue Victor Hugo, Montpellier",
  "21 Rue du Faubourg Saint-Antoine, Paris",
  "50 Quai Charles de Gaulle, Lyon"
]

INSTRUMENT_PHOTOS = {
  "Guitare" => "https://images.unsplash.com/photo-1564186763535-ebb21ef5277f?q=80&w=1200&auto=format&fit=crop",
  "Violon" => "https://images.unsplash.com/photo-1612225330812-01a9c6b355ec?q=80&w=1200&auto=format&fit=crop",
  "Piano" => "https://images.unsplash.com/photo-1520523839897-bd0b52f945a0?q=80&w=1200&auto=format&fit=crop",
  "Clarinette" => "https://images.unsplash.com/photo-1651232529331-758604de9a6a?q=80&w=1200&auto=format&fit=crop",
  "Batterie" => "https://images.unsplash.com/photo-1694677476149-d0c5f5b553e0?q=80&w=1200&auto=format&fit=crop",
  "Flûte traversière" => "https://plus.unsplash.com/premium_photo-1664303083732-32e079d36221?q=80&w=1200&auto=format&fit=crop"
}

sizes = %w[Standard Large Compact Mini XL]
instruments = []
# crée 5 instruments, attribués à tour de rôle à Audric et bartelhemy
INSTRUMENTS.each do |type, description|
  instrument = Instrument.create!(
    instrument_type: type,
    price_per_day: rand(15..60),
    size: sizes.sample,
    user: users.sample,
    name: "#{Faker::Music.band} #{type.downcase}",
    description: description,
    address: valid_addresses.sample
  )
  instrument.geocode
  instrument.save!

  puts "Instrument #{instrument.name}: #{instrument.latitude}, #{instrument.longitude}"

  # ajoute la photo principale via open-uri
  photo_url = INSTRUMENT_PHOTOS[type]
  if photo_url.present?
    file = URI.open(photo_url)
    instrument.photos.attach(io: file, filename: "#{type.downcase}.jpg", content_type: "image/jpeg")
  end

  image_folder = Rails.root.join("db/seeds/images/#{type.downcase}")
  if Dir.exist?(image_folder)
    Dir[image_folder.join("*.jpg")].sample(rand(2..3)).each do |path|
      instrument.photos.attach(io: File.open(path), filename: File.basename(path))
    end
  end

  instruments << instrument
  puts "Created instrument: #{instrument.name} (#{instrument.instrument_type})"
end

# 5.times do |i|
#   owner = users[i % 2] # alterne entre Audric et Barthelemy
#   instruments << Instrument.create!(
#     instrument_type: instrument_types[i % instrument_types.length],
#     price_per_day: rand(10..50),
#     size: sizes.sample,
#     user: owner,
#     description: Faker::Lorem.sentence(word_count: 8),
#     status: "available",
#     name: instrument_names[i % instrument_names.length]
#   )
# end

# Chaque user restant booke un instrument différent
users.each_with_index do |user, i|
  instrument = instruments[i % instruments.length]
  Booking.create!(
    starting_date: Date.today + i,
    ending_date: Date.today + i + rand(1..5),
    user: user,
    instrument: instrument,
    total_price: instrument.price_per_day * rand(1..5),
    status: %w[pending accepted cancelled].sample
  )
  puts "#{user.first_name} booked #{instrument.name}"
end

# Chaque booking reçoit un review random
Booking.all.each do |booking|
  Review.create!(
    rating: rand(3..5),
    comment: Faker::Hipster.sentence,
    user: booking.user,
    instrument: booking.instrument
  )
  puts "#{booking.user.first_name} reviewed #{booking.instrument.name} with rating #{Review.last.rating}"
end

puts "Seed finished"
