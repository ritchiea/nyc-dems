class Endorsement < ActiveRecord::Base
  belongs_to :building
  accepts_nested_attributes_for :building
  belongs_to :candidate

  validates :candidate_id, presence: true

  before_save :check_description
  after_save :run_building_fave_candidate

  has_one :user
  accepts_nested_attributes_for :user, :allow_destroy => false

  def check_description
    return if !description.blank?
    self.description = 'No comments'
  end

  def run_building_fave_candidate
    building.set_favorite_candidate
  end

  def user_invalid?
    return true if user.email.blank? && user.password_blank?
  end

  def name
    candidate.name
  end

  def photo_url
    candidate.photo_url
  end
end
