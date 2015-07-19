require './config/environment'
require 'faker'

max_num = 20
	User.create(name:"Don Burks",email:"don",password:"123",pets:15,usertype:0)
  User.create(name:"Tom Lei",email:"lmd0209@msn.com",password:'123',pets:0, usertype:2)
  User.create(name:"Steph Lam",email:"landlord",password:'123',pets:0, usertype:0) #dlordt
  User.create(name:"Sam San",email:"tenant",password:'123',pets:0, usertype:1, location_id:1) # Tenant

	Location.create(landlord_id:1,interest_rate:5,nickname:"Lighthouse Labs",address:"128 West Hasting",rate:4000,no_people:25,city:"Vancouver",country:"Canada")

60.times do 
address = Faker::Address.street_address + " " +  Faker::Address.secondary_address
pets = rand(2) == 1 ? true : false
cities = ['Vancouver','Calgary','Edmonton','Winnpeg','Toronto','Montreal','Halifax']

location = Location.create(landlord_id:rand(1..max_num),nickname:Faker::Lorem.word,address:address,rate:(rand(5..20)*100),interest_rate:rand(3..15),allow_pets?:pets,no_people:rand(1..4),photo:"http://www.fakenamegenerator.com/images/sil-male.png",city:cities.sample, country:'Canada')
end
i=User.count
40.times {
  pets_num = rand(0..20)
  rand_type = rand(0..2)
	i += 1
	# Generate one tenant
  User.create(location_id:i,name:Faker::Name.name,email:Faker::Internet.email,password:'123',pets:pets_num, usertype: 1)
	#Generate one Landlord
  User.create(name:Faker::Name.name,email:Faker::Internet.email,password:'123',pets:pets_num, usertype: 0)
}


(2..6).each do |a|
	Record.add_all(a) # Generate Record for Month a
	User.where.not(location_id:nil).each do |usr|
		random = rand (0..10)
		usr.pay if random > (a-2) # certain people don't pay
	end
end







puts Faker::Hacker.say_something_smart
