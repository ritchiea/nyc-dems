class RemoveNameFromEndorsement < ActiveRecord::Migration
  def up
    remove_column :endorsements, :name
  end
  def down
    add_column :endorsements, :name, :string
  end
end
