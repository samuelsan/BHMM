# Homepage (Root path)
get '/' do
  erb :index
end

get '/login' do
  @tenant
  erb :'login'
end

post '/login' do
  if Tenant.where(email: email, password: password) #|| Landlord.where(email:)
   Tenant.find_by(name: params[:name])#, password: params[:password])
     session[:current_tenant_id] = log_tenant.id
    @login_error = false
    redirect to('/tenant')
  else
     @login_error = true
     erb :'login'
  end 
end

get '/signup' do
  erb :signup
end

get '/signup' do
  @tenant = Tenant.new
  erb :'signup'
end

post '/signup' do
  @tenant = Tenant.new(
    name: params[:name],
    email: params[:email]
   # password: params[:password]
  )
  if @tenant.save
    redirect '/login'
  else
    erb :'signup'
  end
end

get '/locations' do
  erb :locations
end

get '/results' do
  erb :results
end

# landlord
get '/landlord' do
  erb :landlord_home
end

get '/landlord/records' do
  erb :landlord_records
end

get '/landlord/my_locations' do
  erb :landlord_locations
end

# tenant
get '/tenant' do
  erb :tenant_home
end

get '/tenant/records' do
  erb :tenant_records
end

get '/tenant/pay' do
  erb :tenant_pay
end

get 'tenant/confirmation' do
  erb :tenant_confirmation
end