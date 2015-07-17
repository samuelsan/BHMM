class LocationModifiication < ActiveRecord::Migration
  def change
		add_column :locations, :move_in_date, :date
		add_column :locations, :move_out_date, :date
		add_column :locations, :city, :string
		add_column :locations, :country, :string


  end
end
