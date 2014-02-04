class Building < ActiveRecord::Base
  has_many :endorsements

  alias_attribute :lat, :latitude
  alias_attribute :lng, :longitude

  scope :with_endorsements, -> { includes(:endorsements).select {|b| b.endorsements.count > 0} }

  def endorsements_count
    endorsements.count
  end

  def set_favorite_candidate
    if endorsements.blank?
      self.favorite_candidate = nil
    elsif endorsements.count == 1
      self.favorite_candidate = endorsements.first.candidate_id
    else
      totals = Candidate.all.map {|c| {c.id => self.endorsements.where(candidate_id: c.id).count} }
      totals.sort! {|x,y| y[y.keys.first] <=> x[x.keys.first] }
      first, second = totals[0], totals[1]
      self.favorite_candidate = first.values.first > second.values.first ? first.keys.first : nil
    end
    save
  end
end
