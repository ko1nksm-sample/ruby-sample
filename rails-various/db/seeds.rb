# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

order = Order.create(:name => 'name1', :address => 'address1')
Detail.create(:order => order, :product => 'product1', :quantity => 1)
Detail.create(:order => order, :product => 'product1', :quantity => 1)
Detail.create(:order => order, :product => 'product1', :quantity => 1)
Order.create(:name => 'name2', :address => 'address2')
Order.create(:name => 'name3', :address => 'address3')
