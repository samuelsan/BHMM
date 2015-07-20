class Location < ActiveRecord::Base
  has_many :users
  validates :address, uniqueness: true
	after_update :check_user
  def charge
    # interest + rate*duration
  end

	def check_user
		User.where(location_id:self.id).each do |user|
			user.update(location_id:nil)
		end

		Payment.where(location_id:self.id).each do |payment|
			payment.update(location_id:Location.first.id)
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
