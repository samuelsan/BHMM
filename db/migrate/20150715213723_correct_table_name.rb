class CorrectTableName < ActiveRecord::Migration
  def change
		rename_table :landlords_records, :records
  end
end
