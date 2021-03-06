class Record < ActiveRecord::Base

  belongs_to :location
	before_create :charge_interest
  validates :tenant_id, presence: true
  validates :landlord_id, presence: true
  validates :location_id, presence: true
  validates :date_due, presence: true

  def self.add_all(month=nil)

    today = Date.today
		if month.nil?
    duedate = Date.new(today.year, today.month,27)
		else
    duedate = Date.new(today.year, month.to_i,27)
		end
    User.where.not(location_id:nil).each do |user|
    begin
			location = Location.find(user.location_id)
      landlord = User.find(location.landlord_id)
      Record.create(tenant_id:user.id,landlord_id:landlord.id,location_id:location.id,amount_due:location.rate,amount_paid:0,date_due:duedate)
		rescue ActiveRecord::RecordNotFound
		end
    end
	end

	def charge_interest
		
		#self refers to the record being created, so there is tenant_id and all the stuff
		records = Record.where(tenant_id:self.tenant_id).where(location_id:self.location_id)
		outstanding_balance = records.sum(:amount_due) - records.sum(:amount_paid)
		return if outstanding_balance <= 0 or outstanding_balance.nil? or self.location.interest_rate.nil?
		self.amount_due += (outstanding_balance * self.location.interest_rate / 100).to_i
	end

	def owning?
		return false if self.amount_due == self.amount_paid or self.date_due.month == Date.today.month
		return true
	end

  def self.send_mail
    Pony.mail({
    from:             "RentCollectorBBHMM@gmail.com",
    to:               current_user.email,
    subject:          current_user.name,
    body:             erb(:remindermessage, layout: false),
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
  end

  # def self.add
  #   location = Location.find(user.location_id)
  #   landlord = location.landlord_id
  #   new = (tenant_id:user.id,landlord_id:landlord.id,location_id:location.id,amount_due:location.rate,amount_paid:0,date_due:duedate)
  #   new.save
  # end


#def add(address, tenant_id, landlord_id, amount_paid, amount_due, date_due)
#  Record.create(created_at: DateTime.now, address: address, tenant_id: tenant_id, landlord_id: landlord_id, amount_paid: amount_paid, amount_due: amount_due, date_due: date_due)
#  self.save
#end

end
