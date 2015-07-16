class ChangePetsType < ActiveRecord::Migration
  def change
		change_column :users, :pets, :boolean
  end
end
