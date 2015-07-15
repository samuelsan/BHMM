class CreateUserTable < ActiveRecord::Migration
  def change
		create_table :users do |t|
			t.string :username, null: false
			t.string :password, null: false
			t.string :usertype, null: false
		end

		add_column :landlords, :user_id, :integer
		add_column :tenants, :user_id, :integer
  end
end
