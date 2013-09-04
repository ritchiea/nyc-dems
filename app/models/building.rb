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

  def favorite_candidate
    totals = Candidate.all.map {|c| {c.id => self.endorsements.where(candidate_id: c.id).count} }
    totals.sort! {|x,y| y[y.keys.first] <=> x[x.keys.first] }
    first, second = totals[0], totals[1]
    first.values.first > second.values.first ? first.keys.first : nil
  end
end
