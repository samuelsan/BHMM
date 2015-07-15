class Record < ActiveRecord::Base
validates :tenant_id, presence: true
validates :landlord_id, presence: true
validates :location_id, presence: true
validates :amount_due, presence: true
end
