class User < ActiveRecord::Base
	validates :username, presence: true
	validates :password, presence: true
	validates :usertype, presence: true
end
