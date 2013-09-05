class AddSeedDataToEndorsement < ActiveRecord::Migration
  def change
    add_column :endorsements, :seed_data, :boolean, default: false
  end
end
