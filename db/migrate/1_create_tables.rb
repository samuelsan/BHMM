class CreateTables < ActiveRecord::Migration
  def change
    create_table :records do |t|
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

    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password, null: false
      t.string :phone
      t.integer :pets
      t.float :account_balance
      t.string :credit_card
      t.integer :type, null: false
    end
end
end
