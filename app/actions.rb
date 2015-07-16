# Homepage (Root path)
@login_error = false

get '/' do
  erb :index
end

get '/login' do
  @user
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
      redirect to('/')
    end
  else
     @login_error = true
     erb :'login'
  end 
end

get '/logout' do
  session.clear
  redirect to('/login')
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
  else 
    usertype = 1
  end

  @user = User.new(
    name: params[:name],
    email: params[:email],
    password: params[:password],
    usertype: usertype
  )
  if @user.save
    redirect '/login'
  else
    erb :'signup'
  end
end

get '/locations' do
  @user = User.find(session[:user])
  erb :locations
end

get '/results' do
  @user = User.find(session[:user])
  erb :results
end

# landlord
get '/landlord' do
  @user = User.find(session[:user])
  erb :landlord_home
end

get '/landlord/records' do
  @user = User.find(session[:user])
	@record = Record.where(landlord_id:@user.id)
  erb :landlord_records
end

get '/landlord/my_locations' do
  @user = User.find(session[:user])
	@location = Location.where(landlord_id:@user.id)
  erb :landlord_locations
end

# tenant
post '/movein/:locationid' do
  User.find(session[:user]).update_attributes(location_id: params[:locationid])
  redirect '/tenant'
end

get '/tenant' do
  @user = User.find(session[:user])
  erb :tenant_home
end

get '/tenant/records' do
  @user = User.find(session[:user])
	@record = Record.where(tenant_id:@user.id)
  erb :tenant_records
end

get '/tenant/pay' do
  @user = User.find(session[:user])
  erb :tenant_pay
end

get 'tenant/confirmation' do
  @user = User.find(session[:user])
  erb :tenant_confirmation
end
