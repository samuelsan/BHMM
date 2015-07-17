class Payment < ActiveRecord::Base
validates :amount, presence: true
validates :landlord_id, presence: true
validates :tenant_id, presence: true
validates :location_id, presence: true

belongs_to :location

end
