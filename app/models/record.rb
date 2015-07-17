class Record < ActiveRecord::Base

  belongs_to :location

  validates :tenant_id, presence: true
  validates :landlord_id, presence: true
  validates :location_id, presence: true
  validates :date_due, presence: true

def self.add()
		today = Date.today
		duedate = Date.new(today.year, today.month,27)
	User.where.not(location_id:nil).each do |user|
		location = Location.find(user.location_id)
		landlord = User.find(location.landlord_id)
		Record.create(tenant_id:user.id,landlord_id:landlord.id,location_id:location.id,amount_due:location.rate,amount_paid:0,date_due:duedate,date_paid:nil)
	end
end

#def add(address, tenant_id, landlord_id, amount_paid, amount_due, date_due)
#  Record.create(created_at: DateTime.now, address: address, tenant_id: tenant_id, landlord_id: landlord_id, amount_paid: amount_paid, amount_due: amount_due, date_due: date_due)
#  self.save
#end

end
