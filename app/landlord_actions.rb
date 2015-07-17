# landlord
get '/landlord' do
  @locations = Location.where(landlord_id:current_user.id)
  erb :landlord_home
end

get '/landlord/records?:date' do
  @record = Record.where(landlord_id:current_user.id)
  @months = []
  unless @record.nil?
    @months = @record.all.map {|d| d.date_due.strftime('%y-%m')}.uniq 
  end
  erb :landlord_records
end

get '/landlord/my_locations' do
  @location = Location.where(landlord_id:current_user.id)
  erb :landlord_locations
end

post '/landlord/new_location' do
  # Add new location backend here ,
  print params[:pets?]
  pet = params[:pets?] == "on" ? true : false
  location = Location.new(landlord_id:current_user.id,nickname:params[:nickname],address:params[:address],rate:params[:rate],interest_rate:params[:interestrate],no_people:params[:nopeople],photo:params[:imgurl],allow_pets?:pet)
  print location.inspect
  if location.save
    redirect '/landlord'
  end
end

get '/generate_lease/:tenant_id' do
  @tenant = User.find(params[:tenant_id])
  @landlord = current_user
  erb :generate_lease
end
