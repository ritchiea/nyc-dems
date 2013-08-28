class CreateEndorsements < ActiveRecord::Migration
  def change
    create_table :endorsements do |t|
      t.string :name
      t.text :description
      t.string :email
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :unit
      t.point :lonlat, :geographic => true

      t.timestamps
    end
  end
end
