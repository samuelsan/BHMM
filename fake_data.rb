require './config/environment'
require 'faker'

max_num = 20
20.times do
usertype = rand(2) == 1 ? 'l' : 't'
User.create(username:Faker::Internet.user_name,password:'123',usertype:usertype)
end
20.times {Landlord.create(name:Faker::Name.name ,email:Faker::Internet.email)}

40.times do 
address = Faker::Address.street_address + " " +  Faker::Address.secondary_address
pets = rand(2) == 1 ? true : false
location = Location.create(landlord_id:rand(1..max_num),nickname:Faker::Lorem.word,address:address,rate:(rand(5..20)*100),interest_rate:0.045,allow_pets?:pets,no_people:rand(1..4),photo:"http://www.fakenamegenerator.com/images/sil-male.png")
end

40.times do
record = Record.create(tenant_id:rand(1..max_num),landlord_id:rand(1..max_num),location_id:rand(1..max_num),amount_due:(rand(5..20)*100),amount_paid:0)
end


20.times {Tenant.create(name:Faker::Name.name,email:Faker::Internet.email,phone:Faker::PhoneNumber.cell_phone,pets:rand(0..3),account_balance:0,credit_card:Faker::Business.credit_card_number)}


puts Faker::Hacker.say_something_smart
