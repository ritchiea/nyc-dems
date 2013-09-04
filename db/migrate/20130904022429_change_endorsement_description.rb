class ChangeEndorsementDescription < ActiveRecord::Migration
  def up
    change_column :endorsements, :description, :text
  end
  def down
    change_column :endorsements, :description, :string
  end
end
