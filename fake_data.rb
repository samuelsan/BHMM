require './config/environment'
require 'faker'

max_num = 20
  User.create(name:"Tom Lei",email:"lmd0209@msn.com",password:'123',pets:0, usertype:2)
  User.create(name:"Sam San",email:"tenant",password:'123',pets:0, usertype:1, location_id:User.count) # Tenant
  User.create(name:"Steph Lam",email:"landlord",password:'123',pets:0, usertype:0) #Landlord

40.times do 
address = Faker::Address.street_address + " " +  Faker::Address.secondary_address
pets = rand(2) == 1 ? true : false
cities = ['Vancouver','Calgary','Edmonton','Winnpeg','Toronto','Montreal','Halifax']

location = Location.create(landlord_id:rand(1..max_num),nickname:Faker::Lorem.word,address:address,rate:(rand(5..20)*100),interest_rate:rand(3..15),allow_pets?:pets,no_people:rand(1..4),photo:"http://www.fakenamegenerator.com/images/sil-male.png",city:cities.sample, country:'Canada')
end
i=User.count
20.times {
  pets_num = rand(0..20)
  rand_type = rand(0..2)
	i += 1
  User.create(location_id:i,name:Faker::Name.name,email:Faker::Internet.email,password:'123',pets:pets_num, usertype: rand_type)
}
User.find(2).update(email:'123')

Record.add_all

puts Faker::Hacker.say_something_smart
