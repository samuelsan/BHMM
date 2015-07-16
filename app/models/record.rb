class Record < ActiveRecord::Base

  belongs_to :location

  validates :tenant_id, presence: true
  validates :landlord_id, presence: true
  validates :location_id, presence: true
  validates :date_due, presence: true

def late?
  date_paid > date_due || DateTime.now > date_due
end

end
