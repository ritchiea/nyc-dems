class Cleanup < ActiveRecord::Migration
  def change
    drop_table :locations
    remove_column :buildings, :lonlat
  end
end
