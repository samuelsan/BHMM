class User < ActiveRecord::Base
  has_many :locations

  validates :name, presence: true#, uniqueness: true
	validates :email, presence: true#, uniqueness: true #format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: {case_sensitive: false}
	validates :password, presence: true
  validates :usertype, presence: true, allow_blank: false, allow_nil: false, acceptance: true
  before_validation :set_balance

  RATE = 1000
  
  def set_balance
    self.account_balance = 0 if !account_balance
  end

  def set_pets
    self.pets = 0 if !pets
  end

  def work
    self.account_balance += RATE
    self.save
  end

  def pay
    # Deduct from own account
    self.account_balance -= Location.find(self.location_id).rate
    # Add to landlords account
    Location.find(self.location_id).landlord_id += Location.find(self.location_id).rate
    self.save
  end
end
