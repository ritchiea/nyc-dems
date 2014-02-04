class AddLonAndLatToBuildings < ActiveRecord::Migration
  def up
    add_column :buildings, :longitude, :decimal
    add_column :buildings, :latitude, :decimal
  end

  def down
    remove_column :buildings, :longitude
    remove_column :buildings, :latitude
  end

end
