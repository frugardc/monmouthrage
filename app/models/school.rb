class School < ActiveRecord::Base
  GEO_FACTORY = RGeo::Geographic.spherical_factory(srid: 4326)
  set_rgeo_factory_for_column :geom, GEO_FACTORY

end
