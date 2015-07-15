# Homepage (Root path)
get '/' do
  erb :index
end

get '/login' do
  erb :login
end

get '/signup' do
  erb :signup
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