post '/movein/:locationid' do
<<<<<<< HEAD
  location = Location.find(params[:locationid])
  redirect '/pets' if session[:pets] && !location.allow_pets?
  current_user.update_attributes(location_id: params[:locationid])
=======
  @location = Location.find(params[:locationid])
  redirect '/pets' if session[:pets] && !@location.allow_pets?
  User.find(current_user).update_attributes(location_id: params[:locationid])
>>>>>>> branch
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
<<<<<<< HEAD
  if @record.nil? or @record == []
    @amount_due = 0
  else
=======
>>>>>>> branch
  @amount_due = Record.where(tenant_id:current_user.id).sum(:amount_due) - Record.where(tenant_id:current_user.id).sum(:amount_paid)
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