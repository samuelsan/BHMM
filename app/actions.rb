require 'pry'
require 'pony'
require_relative 'landlord_actions'
require_relative 'tenant_actions'

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

get '/records' do
  @record = Record.where(tenant_id:current_user.id)
  if current_user.usertype == 0
    redirect '/landlord/records'
  else current_user.usertype == 1
    redirect '/tenant/records'
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

get '/pets' do
  erb :pets
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

