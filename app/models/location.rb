class Location < ActiveRecord::Base
  has_many :users
  validates :address, uniqueness: true
	after_destroy :check_user
  def charge
    # interest + rate*duration
  end

	def check_user
		User.where(location_id:self.id).each do |user|
			user.update(location_id:nil)
		end

	end

  # ceiling month
  def duration
    # DateTime.now
  end

  def late?
    date_paid > date_due || DateTime.now > date_due
  end

  def interest
    # charge = 0
    # if late?
    #   charge = rate*(0.1)*(date_paid-date_due)
    # end
  end

  def alert
  end
  
end
