class User < ActiveRecord::Base
  has_many :locations

  validates :name, presence: true
	validates :email, presence: true #format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: {case_sensitive: false}
	validates :password, presence: true
	validates :usertype, presence: true
  
  before_validation :set_balance

  RATE = 1000
  
  def set_balance
    self.account_balance = 0 if !account_balance
  end

  def work
    self.account_balance+= RATE
  end

end
