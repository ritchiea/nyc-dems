class Building < ActiveRecord::Base
  has_many :endorsements

  self.rgeo_factory_generator = RGeo::Geos.factory_generator(:srid => 4326)
  set_rgeo_factory_for_column(:lonlat, RGeo::Geographic.spherical_factory(:srid => 4326))

  delegate :x, :to => :lonlat, :allow_nil => true
  delegate :y, :to => :lonlat, :allow_nil => true

  alias_method :latitude, :y
  alias_method :longitude, :x
  alias_method :lat, :y
  alias_method :lng, :x

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
