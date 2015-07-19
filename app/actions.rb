require 'pry'
require 'pony'
require_relative 'landlord_actions'
require_relative 'tenant_actions'
require_relative 'stripe_actions'

# Homepage (Root path)
helpers do
  def current_user
    @current_user ||= User.find(session[:user]) if session[:user]
  end
end

before do
  redirect '/notloggedin' if !current_user && request.path != '/notloggedin' && request.path != '/login' && request.path != '/signup'  && request.path != '/locations' && request.path != '/' && request.path != '/search'
end

@login_error = false

get '/' do
  # TODO: erb :home if session:[user]
  redirect '/locations'
end

get '/login' do
  # TODO: do not allow multiple sign ins. Must sign out first
  # redirect '/logout' if current_user
  session.clear if current_user 
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

get '/logout' do
  session.clear
  redirect '/locations'
end

post '/logout' do
  session.clear
  redirect '/locations'
end

get '/notloggedin' do
  erb :'errors/notloggedin'
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
    erb :landlord_records
  else current_user.usertype == 1
    erb :tenant_records
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

  pets = (params[:pets] == 'yes')
  new_user = User.new(
    name: params[:name],
    email: params[:email],
    password: params[:password],
    phone: params[:phone],
    pets: pets,
    usertype: usertype
  )
  new_user.save
  session[:user] = new_user.id
  redirect '/home'
  # redirect '/login'
end

post '/update' do
  # ONLY THE FIRST ONE UPDATES WHY
  pets = (params[:pets] == 'yes')
  current_user.update_attributes(pets: pets)
  current_user.update_attributes(name: params[:name])
  current_user.update_attributes(email: params[:email])
  current_user.update_attributes(password: params[:password])
  current_user.update_attributes(phone: params[:phone])
  current_user.save
  redirect '/home'
end

get '/locations' do
	occupied_locations = User.select(:location_id).distinct.pluck(:location_id)
	@location = Location.where.not(id:occupied_locations) 
  erb :locations
end

post '/search' do
  @search_result =search(params[:search_text])
  erb :search
end

get '/nopets' do
  erb :'errors/nopets'
end

get '/lowfunds' do
  erb :'errors/lowfunds'
end

#don't delete this.  This has also been moved to record.rb

post '/emailpay/:redirect' do
  Pony.mail({
    from:             "RentCollectorBBHMM@gmail.com",
    to:               current_user.email,
    subject:          current_user.name,
    body:             erb(:paymessage, layout: false),
    via:              :smtp,
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
  if params[:redirect] 
    if current_user.account_balance < Location.find(current_user.location_id).rate
      redirect '/lowfunds'
    else 
      redirect '/tenant'
    end
  end
end

post '/emailrefill/:redirect' do
  Pony.mail({
    from:             "RentCollectorBBHMM@gmail.com",
    to:               current_user.email,
    subject:          current_user.name,
    body:             erb(:refillmessage, layout: false),
    via:              :smtp,
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
  if params[:redirect] 
    redirect '/tenant'
  end
end

post '/emailpayfull/:redirect' do
  Pony.mail({
    from:             "RentCollectorBBHMM@gmail.com",
    to:               current_user.email,
    subject:          current_user.name,
    body:             erb(:fullpaymessage, layout: false),
    via:              :smtp,
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
 if params[:redirect] 
    if current_user.account_balance < Location.find(current_user.location_id).rate
      redirect '/lowfunds'
    else 
      redirect '/tenant'
    end
  end
end

get '/new_month' do
	Record.add_all
  redirect '/'
end

