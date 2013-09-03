class Endorsement < ActiveRecord::Base
  belongs_to :building
  accepts_nested_attributes_for :building
  belongs_to :candidate

  validates :candidate_id, presence: true

  def photo_url
    candidate.photo_url
  end
end
