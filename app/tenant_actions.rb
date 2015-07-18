# tenant
get '/tenant' do
  erb :tenant_home
end

get '/tenant/records' do

  @record = Record.where(tenant_id:current_user.id)
  if @record.nil? or @record == []
    @amount_due = 0
		@record = []
  else
    @amount_due = @record.sum(:amount_due) - @record.sum(:amount_paid)
  end

	@payment = Payment.where(tenant_id:current_user.id)
  erb :tenant_records
end

get '/tenant/pay' do
  if !(User.find(current_user).location_id)
    redirect '/locations' 
  end
	@record = Record.where(tenant_id:current_user.id)
  if @record.nil? or @record == []
    @amount_due = 0
		@record = []
  else
    @amount_due = @record.sum(:amount_due) - @record.sum(:amount_paid)
  end
  erb :tenant_pay
end

post '/tenant/pay/full' do
  # if current_user.account_balance < Location.find(current_user.location_id).rate
  current_user.pay()
  Payment.add(current_user, Location.find(current_user.location_id).rate)
  redirect '/emailpay/true', 307
end

post '/tenant/pay/part' do
  # if current_user.account_balance < params[:amount]
  current_user.pay(params[:amount].to_f)
  Payment.add(current_user, params[:amount])
  redirect '/tenant/records'
end

post '/work' do
  current_user.work
  redirect '/tenant'
end

post '/movein/:locationid' do
  location = Location.find(params[:locationid])
  redirect '/nopets' if current_user.pets && !location.allow_pets?
  current_user.update_attributes(location_id: params[:locationid])
  redirect '/tenant'
end

post '/moveout' do
  User.find(current_user).update_attributes(location_id: nil)
  redirect '/tenant'
end

