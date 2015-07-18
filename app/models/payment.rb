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
		records = Record.where(tenant_id:self.tenant_id).where.not("amount_due = amount_paid") # get all the record where amount_paid is not equal to the amount due
		records.each do |record|
			diff = record.amount_due - record.amount_paid
			if diff <= pmt
				#amount_paid increase to amount due and pmt decrease by diff and corresponding landlord's account_balance increase by diff
				record.amount_paid = record.amount_due
				pmt -= diff
				user = User.find(record.landlord_id)
				user.account_balance += diff
				user.save 
			else
				#amount_paid increase by pmt and pmt become 0 corresponding landlord's account_balance balance increase bt amt
				record.amount_paid += pmt
				user = User.find(record.landlord_id)
				user.account_balance += pmt
				user.save
				pmt = 0
			end
			record.save
		end
		#incase of padi too much, the money goes to user's account balance
		user = User.find(self.tenant_id)
		user.account_balance= user.account_balance - self.amount + pmt
		user.save
	end
end
