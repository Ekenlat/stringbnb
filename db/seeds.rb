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

prenoms = %w[Audric Barthelemy Jonathan Nour Baptiste]
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
  "Flûte traversière" => "Flûte traversière argentée, parfaite pour les solos classiques et les ensembles à vent.",
  "Saxophone" => "Saxophone alto brillant, sonorité chaude adaptée au jazz et à la musique moderne.",
  "Contrebasse" => "Contrebasse massive, parfaite pour les orchestres symphoniques et les sessions jazz acoustiques.",
  "Trompette" => "Trompette en laiton avec pistons souples, très expressive pour les solos éclatants.",
  "Harp" => "Harpe celtique au bois noble, idéale pour les musiques traditionnelles ou les compositions oniriques.",
  "Guitare électrique" => "Guitare électrique de style vintage avec micros double bobinage. Parfaite pour le rock énergique.",
  "Accordéon" => "Accordéon chromatique français, idéal pour la musette, le jazz manouche ou la musique traditionnelle.",
  "Ukulélé" => "Petit ukulélé hawaïen, léger et facile à prendre en main, parfait pour les débutants.",
  "Xylophone" => "Xylophone en bois massif avec baguettes douces, idéal pour l'éveil musical.",
  "Harmonica" => "Harmonica en do majeur, parfait pour les improvisations blues ou les balades folk."
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
    description: description
  )

  image_folder = Rails.root.join("db/seeds/images/#{type.downcase}")
  Dir[image_folder.join("*.jpg")].sample(rand(2..3)).each do |path|
    instrument.photos.attach(io: File.open(path), filename: File.basename(path))
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
  Booking.create!(
    starting_date: Date.today + i,
    ending_date: Date.today + i + rand(1..5),
    user: user,
    instrument: instruments[i],
    total_price: instruments[i].price_per_day * rand(1..5),
    status: %w[pending confirmed cancelled].sample
  )
  puts "#{user.first_name} booked #{instruments[i].name}"
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
