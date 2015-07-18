class LocationModifiication < ActiveRecord::Migration
  def change
		add_column :locations, :city, :string
		add_column :locations, :country, :string
	
		create_table :payments do |t|
		t.timestamp :created_at
		t.float :amount,				null: false
		t.integer :landlord_id,	null: false
		t.integer :tenant_id,		null: false
		t.integer :location_id,	null: false
		end
  end
end
