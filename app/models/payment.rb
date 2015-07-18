require 'pry'
class Payment < ActiveRecord::Base
	validates :amount, presence: true
	validates :landlord_id, presence: true
	validates :tenant_id, presence: true
	validates :location_id, presence: true

	belongs_to :location
	after_create :update_record

	def self.add(user, amount)
		location = Location.find(user.location_id)
		landlord = location.landlord_id
		new = Payment.create(amount:amount, landlord_id: landlord, tenant_id: user.id, location_id: location.id)
		new.save
	end

	def update_record
		#self referes to the payment being saved
		# updates record of the tenant column amount paid
		pmt = self.amount
		records = Record.where(tenant_id:self.tenant_id).where(location_id:self.location_id).where.not("amount_due = amount_paid") # get all the record where amount_paid is not equal to the amount due
		records.each do |record|
			diff = record.amount_due - record.amount_paid
			if diff <= pmt
				#amount_paid increase to amount due and pmt decrease by diff
				record.amount_paid = record.amount_due
				pmt -= diff
			elsif pmt == 0 then return 
			else
				#amount_paid increase by pmt and pmt become 0
				record.amount_paid += pmt
				pmt = 0
			end
			record.save
		end
		User.find(self.tenant_id).account_balance += pmt
	end
end
