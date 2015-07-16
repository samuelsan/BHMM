require './config/environment'
require 'faker'

max_num = 20
20.times {
  pets_num = rand(0..20)
  rand_type = rand(0..2)
  User.create(name:Faker::Name.name,email:Faker::Internet.email,password:'123',pets:pets_num, type: rand_type)
}

40.times do 
address = Faker::Address.street_address + " " +  Faker::Address.secondary_address
pets = rand(2) == 1 ? true : false
location = Location.create(landlord_id:rand(1..max_num),nickname:Faker::Lorem.word,address:address,rate:(rand(5..20)*100),interest_rate:0.045,allow_pets?:pets,no_people:rand(1..4),photo:"http://www.fakenamegenerator.com/images/sil-male.png")
end

40.times do
record = Record.create(tenant_id:rand(1..max_num),landlord_id:rand(1..max_num),location_id:rand(1..max_num),amount_due:(rand(5..20)*100),amount_paid:0)
end


puts Faker::Hacker.say_something_smart
