# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Nettoyage de la base de données
puts "Nettoyage de la base de données..."
Dish.destroy_all
Apartment.destroy_all
Building.destroy_all
User.destroy_all

# Création des bâtiments
puts "Création des bâtiments..."
buildings = [
  { name: "Résidence Les Fleurs", address: "123 rue des Roses" },
  { name: "Le Belvédère", address: "45 avenue des Pins" },
  { name: "Les Terrasses", address: "78 boulevard du Parc" }
].map { |building| Building.create!(building) }

# Création des utilisateurs
puts "Création des utilisateurs..."
users = [
  {
    full_name: "Jean Dupont",
    email: "jean@exemple.com",
    password: "password123"
  },
  {
    full_name: "Marie Martin",
    email: "marie@exemple.com",
    password: "password123"
  },
  {
    full_name: "Pierre Dubois",
    email: "pierre@exemple.com",
    password: "password123"
  }
].map { |user_data| User.create!(user_data) }

# Création des appartements
puts "Création des appartements..."
[
  { number: "A101", building: buildings[0], user: users[0] },
  { number: "B202", building: buildings[0], user: users[1] },
  { number: "C303", building: buildings[0], user: users[2] }
].each { |apt_data| Apartment.create!(apt_data) }

# Création des plats
puts "Création des plats..."
dishes_data = [
  {
    name: "Abolo",
    description: "Délicieux gâteau de maïs fermenté traditionnel, servi chaud avec une sauce épicée aux légumes. Un vrai régal pour les amateurs de cuisine africaine !",
    portions: 5,
    price: 200.00,
    user: users[0]
  },
  {
    name: "Akoumé",
    description: "Plat traditionnel à base de farine de maïs, servi avec une sauce tomate aux épices. Parfait pour découvrir les saveurs d'Afrique de l'Ouest.",
    portions: 12,
    price: 12.00,
    user: users[1]
  },
  {
    name: "Poulet Yassa",
    description: "Poulet mariné aux oignons et citron, cuit lentement avec des épices. Servi avec du riz parfumé. Une spécialité sénégalaise à ne pas manquer !",
    portions: 8,
    price: 15.50,
    user: users[2]
  },
  {
    name: "Mafé",
    description: "Ragoût à la sauce d'arachide avec viande tendre et légumes de saison. Un classique de la cuisine ouest-africaine, riche en saveurs.",
    portions: 6,
    price: 18.00,
    user: users[0]
  },
  {
    name: "Thiéboudienne",
    description: "Le plat national sénégalais : riz au poisson avec légumes, préparé avec des épices traditionnelles. Un festin complet et savoureux !",
    portions: 10,
    price: 14.00,
    user: users[1]
  }
]

dishes_data.each do |dish_data|
  dish = Dish.create!(dish_data)
  puts "Plat créé : #{dish.name}"
end

puts "Création des plats terminée !"
puts "Données de test créées avec succès !"
puts "Utilisateurs créés :"
users.each do |user|
  puts "- Email : #{user.email} / Mot de passe : password123"
end
