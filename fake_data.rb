require './config/environment'
require 'faker'

max_num = 20
  User.create(name:"user",email:"lmd0209@msn.com",password:'123',pets:pets_num, usertype: rand_type, usertype:2)

40.times do 
address = Faker::Address.street_address + " " +  Faker::Address.secondary_address
pets = rand(2) == 1 ? true : false
location = Location.create(landlord_id:rand(1..max_num),nickname:Faker::Lorem.word,address:address,rate:(rand(5..20)*100),interest_rate:0.045,allow_pets?:pets,no_people:rand(1..4),photo:"http://www.fakenamegenerator.com/images/sil-male.png")
end
i=0
20.times {
  pets_num = rand(0..20)
  rand_type = rand(0..2)
	i+=1
  User.create(location_id:i,name:Faker::Name.name,email:Faker::Internet.email,password:'123',pets:pets_num, usertype: rand_type)
}

Record.add

puts Faker::Hacker.say_something_smart
