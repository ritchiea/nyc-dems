class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|      
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.point :lonlat, :geographic => true

      t.timestamps
    end
    add_column :endorsements, :building_id, :integer
  end
end
