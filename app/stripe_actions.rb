#Stripe

get '/stripe' do
	erb :'/stripe/stripe'
end


post '/charge' do
	@amount = params[:amount_charge].to_i * 100

	customer = Stripe::Customer.create(
		:email => current_user.email,
		:card  => params[:stripeToken]
	)

	charge = Stripe::Charge.create(
		:amount      => @amount,
		:description => "#{current_user.name} + Refill",
		:currency    => 'cad',
		:customer    => customer
	)
	current_user.account_balance += params[:amount_charge].to_f
	current_user.save
	redirect '/home'
end
