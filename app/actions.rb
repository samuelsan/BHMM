# Homepage (Root path)
@login_error = false

get '/' do
  erb :login
end

get '/login' do
  # TODO: do not allow multiple sign ins. Must sign out first
  # @user = User.find(session[:user])
  # redirect '/logout' if @user
  @user
  erb :'login'
end

get '/home' do
  erb :home
end

post '/login' do
  log_user = User.find_by(email: params[:email], password: params[:password])
  if log_user
    session[:user] = log_user.id
    @login_error = false

    case log_user.usertype
    when 0
      redirect to('/landlord')
    when 1
      redirect to('/tenant')
    when 2
      redirect to('/home')
    end
  else
     @login_error = true
     erb :'login'
  end 
end

post '/logout' do
  session.clear
  redirect '/login'
end

get '/notloggedin' do
  erb :notloggedin
end

get '/signup' do
  @user = User.new
  erb :'signup'
end

post '/signup' do
  if (params[:landlord] == "on" && params[:tenant] == "on") 
    usertype = 2
  elsif params[:landlord] == "on" 
    usertype = 0
  elsif params[:tenant] == "on" 
    usertype = 1
  else 
    usertype = nil
  end

  @user = User.new(
    name: params[:name],
    email: params[:email],
    password: params[:password],
    phone: params[:phone],
    pets: params[:pets],
    usertype: usertype
  )
  if @user.save
    redirect '/login'
  else
    erb :'signup'
  end
end

get '/locations' do
  redirect '/notloggedin' if session[:user].nil?
  @user = User.find(session[:user])
	occupied_locations = User.select(:location_id).distinct.pluck(:location_id)
	@location = Location.where.not(id:occupied_locations) 
  erb :locations
end

get '/results' do
  redirect '/notloggedin' if session[:user].nil?
  @user = User.find(session[:user])
	@search_text = params[:search_text]
  erb :results
end

# landlord
get '/landlord' do
  redirect '/notloggedin' if session[:user].nil?
  @user = User.find(session[:user])
  erb :landlord_home
end

get '/landlord/records' do
  redirect '/notloggedin' if session[:user].nil?
  @user = User.find(session[:user])
	@record = Record.where(landlord_id:@user.id)
  erb :landlord_records
end

get '/landlord/my_locations' do
  redirect '/notloggedin' if session[:user].nil?
  @user = User.find(session[:user])
	@location = Location.where(landlord_id:@user.id)
  erb :landlord_locations
end
post '/landlord/new_location' do
# Add new location backend here ,
	redirect '/notloggedin' if session[:user].nil?
	@user = User.find(session[:user])
	print params[:pets?]
	pet = params[:pets?] == "on" ? true : false
	location = Location.new(landlord_id:@user.id,nickname:params[:nickname],address:params[:address],rate:params[:rate],interest_rate:params[:interestrate],no_people:params[:nopeople],photo:params[:imgurl],allow_pets?:pet)
	print location.inspect
	if location.save
		redirect '/landlord'
	else
	
	end
end

# tenant
post '/movein/:locationid' do
  redirect '/notloggedin' if session[:user].nil?
  User.find(session[:user]).update_attributes(location_id: params[:locationid])
  redirect '/tenant'
end

post '/moveout' do
  redirect '/notloggedin' if session[:user].nil?
  User.find(session[:user]).update_attributes(location_id: nil)
  redirect '/tenant'
end

get '/tenant' do
  redirect '/notloggedin' if session[:user].nil?
  @user = User.find(session[:user])
  erb :tenant_home
end

get '/tenant/records' do
  redirect '/notloggedin' if session[:user].nil?
  @user = User.find(session[:user])
	@record = Record.where(tenant_id:@user.id)
  erb :tenant_records
end

get '/tenant/pay' do
  redirect '/notloggedin' if session[:user].nil?
  @user = User.find(session[:user])
  redirect '/locations' if !(User.find(session[:user]).location_id)
  erb :tenant_pay
end

post '/tenant/pay' do
  redirect '/notloggedin' if session[:user].nil?
  @user = User.find(session[:user])
  @user.pay
  # TODO: should redirect to receipt
  redirect '/tenant'
end

post '/tenant/transfer' do
  redirect '/notloggedin' if session[:user].nil?
  @user = User.find(session[:user])
  redirect '/tenant/receipt'
end

get '/tenant/receipt' do
  redirect '/notloggedin' if session[:user].nil?
  @user = User.find(session[:user])
  erb :tenant_receipt
end

post '/work' do
  redirect '/notloggedin' if session[:user].nil?
  @user = User.find(session[:user])
  @user.work
  redirect '/tenant'
end
