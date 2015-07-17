require 'pry'
class User < ActiveRecord::Base
  has_many :locations

  validates :name, presence: true#, uniqueness: true
	validates :email, presence: true#, uniqueness: true #format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: {case_sensitive: false}
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
    amount = location.rate if amount.nil?
    self.account_balance -= amount
    landlord.account_balance += amount
    self.save
    landlord.save
    # Record.add(location.id, current_user.id, landlordid, amount, location.rate, i)
  end
  
  def set_balance
    self.account_balance = 0 if !account_balance
  end

  def set_pets
    self.pets = 0 if !pets
  end

end
