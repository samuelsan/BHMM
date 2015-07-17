class Record < ActiveRecord::Base

  belongs_to :location

  validates :tenant_id, presence: true
  validates :landlord_id, presence: true
  validates :location_id, presence: true
  validates :date_due, presence: true

def add(address, tenant_id, landlord_id, amount_paid, amount_due, date_due)
  Record.create(created_at: DateTime.now, address: address, tenant_id: tenant_id, landlord_id: landlord_id, amount_paid: amount_paid, amount_due: amount_due, date_due: date_due)
  self.save
end

end