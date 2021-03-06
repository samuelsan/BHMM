# tenant
get '/tenant' do

	@amount_due = Record.where(tenant_id:current_user.id).sum(:amount_due) - Record.where(tenant_id:current_user.id).sum(:amount_paid)
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
	redirect '/lowfunds' if current_user.account_balance <= 0

  @amount = current_user.pay()
  if @amount > 0 
    redirect '/emailpayfull/true', 307 
  else
		#should redirect to no bills to pay page here
		redirect '/tenant'
  end
end

post '/tenant/pay/part' do
	redirect '/lowfunds' if current_user.account_balance <= 0
  @amount = current_user.pay(params[:amount].to_f)
    if @amount > 0
    redirect '/emailpay/true', 307 
    else
    #should redirect to no bills to pay page here
		redirect '/tenant'
  end
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

