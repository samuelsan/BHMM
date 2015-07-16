class AddDateColumnOnRecord < ActiveRecord::Migration
  def change
		add_column :records, :date_due, :datetime
		add_column :records, :date_paid, :datetime
		add_column :records, :created_at, :datetime
		add_column :records, :updated_at, :datetime
  end
end
