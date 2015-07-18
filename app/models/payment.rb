require 'pry'
class Payment < ActiveRecord::Base
  validates :amount, presence: true
  validates :landlord_id, presence: true
  validates :tenant_id, presence: true
  validates :location_id, presence: true

  belongs_to :location

  def self.add(user, amount)
    location = Location.find(user.location_id)
    landlord = location.landlord_id
    new = Payment.create(amount:amount, landlord_id: landlord, tenant_id: user.id, location_id: location.id)
    new.save
  end

end
