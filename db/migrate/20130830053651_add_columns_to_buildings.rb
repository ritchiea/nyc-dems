class AddColumnsToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :neighborhood, :string
    add_column :buildings, :county, :string
  end
end
