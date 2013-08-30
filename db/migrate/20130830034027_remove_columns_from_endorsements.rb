class RemoveColumnsFromEndorsements < ActiveRecord::Migration
  def up
    remove_column :endorsements, :address
    remove_column :endorsements, :city
    remove_column :endorsements, :state
    remove_column :endorsements, :zip
    remove_column :endorsements, :lonlat
  end
  
  def down
    add_column :endorsements, :address, :string
    add_column :endorsements, :city, :string
    add_column :endorsements, :state, :string
    add_column :endorsements, :zip, :string
    add_column :endorsements, :lonlat, :point, :geographic => true
  end
end
