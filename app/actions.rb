require 'pry'
require 'pony'
require_relative 'landlord_actions'

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
  # TODO: erb :home if session:[user]
  erb :login
end

get '/login' do
  # TODO: do not allow multiple sign ins. Must sign out first
  # redirect '/logout' if current_user
  current_user
  erb :'login'
end

get '/home' do
  case current_user.usertype
    when 0
      erb :landlord_home
    when 1
      erb :tenant_home
    when 2
      erb :home
    end
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
    redirect '/home'
  end
end

post '/update' do
  # if (params[:landlord] == "on" && params[:tenant] == "on") 
  #   usertype = 2
  # elsif params[:landlord] == "on" 
  #   usertype = 0
  # elsif params[:tenant] == "on" 
  #   usertype = 1
  # else 
  #   usertype = nil
  # end
  # user.update_attributes(name: params[:name]) if params[:name]
  # user.update_attributes(email: params[:email]) if params[:email]
  # user.update_attributes(password: params[:password]) if params[:password]
  # user.update_attributes(password: params[:phone]) if params[:phone]
  # user.update_attributes(password: params[:pets]) if params[:pets]
  # if current_user.save
  #   redirect '/home'
  # end
end


get '/locations' do
	occupied_locations = User.select(:location_id).distinct.pluck(:location_id)
	@location = Location.where.not(id:occupied_locations) 
  erb :locations
end

post '/search' do
  current_user = User.find(session[:user])
	@search_result =search(params[:search_text])
  erb :search
end

# landlord
get '/landlord' do
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
	else
	
	end
end

# tenant
post '/movein/:locationid' do
  location = Location.find(params[:locationid])
  redirect '/pets' if session[:pets] && !location.allow_pets?
  current_user.update_attributes(location_id: params[:locationid])
  redirect '/tenant'
end

post '/moveout' do
  User.find(current_user).update_attributes(location_id: nil)
  redirect '/tenant'
end

get '/pets' do
  erb :pets
end

get '/tenant' do
  erb :tenant_home
end

get '/tenant/records' do

	@record = Record.where(tenant_id:current_user.id)
	if @record.nil? or @record == []
		@amount_due = 0
	else
	@amount_due = Record.where(tenant_id:current_user.id).sum(:amount_due) - Record.where(tenant_id:current_user.id).sum(:amount_paid)
	end
  erb :tenant_records
end

get '/records' do
    @record = Record.where(tenant_id:current_user.id)
  if current_user.usertype == 0
    redirect '/landlord/records'
  else current_user.usertype == 1
    redirect '/tenant/records'
  end
end

get '/tenant/pay' do
  if !(User.find(current_user).location_id)
    redirect '/locations' 
  end
  erb :tenant_pay
end

post '/tenant/pay/full' do
  # if current_user.account_balance < Location.find(current_user.location_id).rate
  current_user.pay()
  redirect '/tenant/records'
end

post '/tenant/pay/part' do
  # if current_user.account_balance < params[:amount]
  current_user.pay(params[:amount].to_f)
  redirect '/tenant/records'
end

get '/tenant/receipt' do
  erb :tenant_receipt
end

post '/work' do
  current_user.work
  redirect '/tenant'
end

get '/generate_lease/:tenant_id' do
  @tenant = User.find(params[:tenant_id])
  @landlord = current_user
  erb :generate_lease
end



get '/email' do
  erb :email
end

post '/email' do
  Pony.mail({
    to:               "samuelsaninbox@gmail.com",
    from:             "RentCollectorBBHMM@gmail.com",
    subject:          "Rent Reminder",
    body:             erb(:emailmessage),
    via:    :smtp,
    via_options: {
      address:        'smtp.gmail.com',
      port:           '587',
      user_name:      'RentCollectorBBHMM@gmail.com',
      enable_starttls_auto: true,
      password:       '123BBHMM',
      authentication: :plain,
      domain:         "localhost.localdomain" 
      }
    })
  redirect '/login'
end

get '/analytics' do
redirect '/index.html'
end

