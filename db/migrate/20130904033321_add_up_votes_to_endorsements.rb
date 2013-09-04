class AddUpVotesToEndorsements < ActiveRecord::Migration
  def change
    add_column :endorsements, :upvotes, :integer
  end
end
