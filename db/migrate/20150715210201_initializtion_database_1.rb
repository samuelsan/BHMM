class InitializtionDatabase1 < ActiveRecord::Migration
  def change
		create_table :landlords do |t|
			t.string :name, null: false
			t.string :email
		end

		create_table :tenants do |t|
			t.string :name, null: false
			t.string :email
			t.string :phone
			t.string :photo
			t.integer :pets
			t.float	:acount_balance
			t.string :credit_card
  end

		create_table :landlord_records do |t|
			t.integer :tenant_id, null: false
			t.integer :landlord_id, null:false
			t.integer :location_id, null: false
			t.integer :amount_due, null: false
			t.integer :amount_paid
		end

		create_table :locations do |t|
			t.integer :landlord_id
			t.string :nickname
			t.string :address
			t.float :rate
			t.float :interest_rate
			t.boolean :allow_pets?
			t.integer :no_people
			t.string :photo
		end
end
end
