class AddFavoriteCandidateToBuilding < ActiveRecord::Migration
  def change
    add_column :buildings, :favorite_candidate, :integer
  end
end
