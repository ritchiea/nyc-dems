class AddCandidateIdToEndorsements < ActiveRecord::Migration
  def change
    add_column :endorsements, :candidate_id, :integer
  end
end
