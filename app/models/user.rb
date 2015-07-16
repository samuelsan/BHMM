class User < ActiveRecord::Base
  validates :name, presence: true
	validates :email, presence: true #format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: {case_sensitive: false}
	validates :password, presence: true
	validates :usertype, presence: true

end
