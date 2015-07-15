class CorrectTableName < ActiveRecord::Migration
  def change
		rename_table :landlord_records, :records
		rename_column :tenants, :acount_balance, :account_balance 
  end
end
