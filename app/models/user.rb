require 'pry'
class User < ActiveRecord::Base
  has_many :locations

  validates :name, presence: true#, uniqueness: true
	validates :email, presence: true, uniqueness: true , uniqueness: {case_sensitive: false} #format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
	validates :password, presence: true
  validates :usertype, presence: true, allow_nil: false
  before_validation :set_balance

  RATE = 1000

  def work
    self.account_balance += RATE
    self.save
  end

	def pay(amount=nil)

		landlordid = Location.find(self.location_id).landlord_id
		landlord = User.find(landlordid)
		location = Location.find(self.location_id)
		records = Record.where(tenant_id:id).where(location_id:location.id)
		outstanding_balance = records.sum(:amount_due) - records.sum(:amount_paid)
		amount = location.rate if amount.nil?
		amount = outstanding_balance if amount > outstanding_balance
		amount = self.account_balance if amount > self.account_balance
		return 0 if amount == 0 or outstanding_balance == 0
		self.account_balance -= amount
		landlord.account_balance += amount
		self.save
		landlord.save
		# record = Record.where()
		# record.update_attributes(amount_paid+=amount)
		# record.save
		return amount
	end
  
  def set_balance
    self.account_balance = 0 if !account_balance
  end

  def set_pets
    self.pets = 0 if !pets
  end

end
