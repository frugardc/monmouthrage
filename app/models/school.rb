class School < ActiveRecord::Base
  GEO_FACTORY = RGeo::Geographic.spherical_factory(srid: 4326)
  set_rgeo_factory_for_column :geom, GEO_FACTORY
  LOCATION_STRUCT = Struct.new(:latitude,:longitude)
  default_scope :select => "*,st_astext(geom) as wkt"
  def location
    parts = wkt.gsub(/[A-Z()]/i,"").split(" ")
    LOCATION_STRUCT.new(parts[1].to_f,parts[0].to_f)
  end
end
