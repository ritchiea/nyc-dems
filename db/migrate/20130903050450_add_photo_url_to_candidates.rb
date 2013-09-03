class AddPhotoUrlToCandidates < ActiveRecord::Migration
  def change
    add_column :candidates, :photo_url, :string
  end
end
