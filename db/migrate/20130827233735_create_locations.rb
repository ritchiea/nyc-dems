class CreateLocations < ActiveRecord::Migration

  def change
    create_table :locations do |t|
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :unit
      t.integer :locationable_id
      t.string :locationable_type
      t.point :lonlat, :geographic => true

      t.timestamps
    end
  end
end
