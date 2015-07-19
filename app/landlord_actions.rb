# landlord
get '/landlord' do
  @locations = Location.where(landlord_id:current_user.id)
  erb :landlord_home
end

get '/landlord/records?*' do
  @record = Record.where(landlord_id:current_user.id)
 	@months = []
	@annual_revenue = Payment.where(landlord_id:current_user.id).where(created_at:(Date.new(2015,1,1))..(Date.new(2016,1,1))).sum(:amount)
  unless @record.nil?
    @months = @record.all.map {|d| d.date_due.strftime('%y-%m')}.uniq
  end
	@months.unshift("All")
	unless params[:date].nil? or params[:date] == ""
		puts params[:date]
		date = params[:date].split("-")
		start_date = Date.new(2000+date[0].to_i,date[1].to_i,1)
		end_date = Date.new(2000+date[0].to_i,date[1].to_i + 1,1)
		@record = @record.where(date_due:start_date..end_date)
	end	
  erb :landlord_records
end

get '/my_locations' do
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
post '/my_locations/delete' do
Location.find(params[:location_id].to_i).destroy
redirect "/my_locations"
end

get '/generate_lease/:tenant_id' do
  @tenant = User.find(params[:tenant_id])
  @landlord = current_user
  erb :generate_lease
end
