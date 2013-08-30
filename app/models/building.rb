class Building < ActiveRecord::Base
  has_many :endorsements

  self.rgeo_factory_generator = RGeo::Geos.factory_generator(:srid => 4326)
  set_rgeo_factory_for_column(:lonlat, RGeo::Geographic.spherical_factory(:srid => 4326))

  delegate :x, :to => :lonlat, :allow_nil => true
  delegate :y, :to => :lonlat, :allow_nil => true

  alias_method :latitude, :x
  alias_method :longitude, :y
end
