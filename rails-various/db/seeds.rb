# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Order.create(name: 'name1', address: 'address1', details_attributes: [
  {product: 'product1', quantity: 1},
])
Order.create(name: 'name2', address: 'address2', details_attributes: [
  {product: 'product1', quantity: 1},
  {product: 'product2', quantity: 2},
])
Order.create(name: 'name3', address: 'address3', details_attributes: [
  {product: 'product1', quantity: 1},
  {product: 'product2', quantity: 2},
  {product: 'product3', quantity: 3},
])
