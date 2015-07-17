require 'pry'
# Homepage (Root path)
helpers do
  def current_user
    @current_user ||= User.find(session[:user]) if session[:user]
  end
end

before do
  redirect '/notloggedin' if !current_user && request.path != '/notloggedin' && request.path != '/login' && request.path != '/signup'
end

@login_error = false

get '/' do
  erb :login
end

get '/login' do
  # TODO: do not allow multiple sign ins. Must sign out first
 
  # redirect '/logout' if current_user
  current_user
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

post '/home' do
  case log_user.usertype
    when 0
      redirect to('/landlord')
    when 1
      redirect to('/tenant')
    when 2
      redirect to('/home')
    end
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

  current_user = User.new(
    name: params[:name],
    email: params[:email],
    password: params[:password],
    phone: params[:phone],
    pets: params[:pets],
    usertype: usertype
  )
  if current_user.save
    #TODO: redirect to homepage after create
    redirect '/login'
  end
end

get '/locations' do
	occupied_locations = User.select(:location_id).distinct.pluck(:location_id)
	@location = Location.where.not(id:occupied_locations) 
  erb :locations
end

get '/search' do
	@search_text = params[:search_text]
  erb :results
end

# landlord
get '/landlord' do
  erb :landlord_home
end

get '/landlord/records' do
	@record = Record.where(landlord_id:current_user.id)
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
	else
	
	end
end

# tenant
post '/movein/:locationid' do
  User.find(current_user).update_attributes(location_id: params[:locationid])
  redirect '/tenant'
end

post '/moveout' do
  User.find(current_user).update_attributes(location_id: nil)
  redirect '/tenant'
end

get '/tenant' do
  erb :tenant_home
end

get '/tenant/records' do
	@record = Record.where(tenant_id:current_user.id)
  erb :tenant_records
end

get '/records' do
    @record = Record.where(tenant_id:current_user.id)
  if current_user.usertype == 0
    erb :landlord_records
  else current_user.usertype == 1
    erb :tenant_records
  end
end

get '/tenant/pay' do
  if !(User.find(current_user).location_id)
    redirect '/locations' 
    # alert("I am an alert box!")
  end
  erb :tenant_pay
end

post '/tenant/pay/full' do
  current_user.pay()
  # TODO: should redirect to receipt
  redirect '/tenant/receipt'
end

post '/tenant/pay/part' do
  current_user.pay(params[:amount].to_f)
  # TODO: should redirect to receipt
  redirect '/tenant/receipt'
end


get '/tenant/receipt' do
  erb :tenant_receipt
end

post '/work' do
  current_user.work
  redirect '/tenant'
end
