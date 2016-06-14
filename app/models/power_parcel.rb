class PowerParcel < ActiveRecord::Base
  GEO_FACTORY = RGeo::Geographic.spherical_factory(srid: 4326)
  set_rgeo_factory_for_column :geom, GEO_FACTORY
  default_scope :select => "*,st_astext(geom) as wkt"
  def to_placemark(mapid="map")
    points = wkt.to_s.gsub(/[A-Z()]/i,"").split(",").collect{|p| p.split(" ")}
    point_strings = points.collect{|p| "{lat: #{p[1]},lng: #{p[0]}}"}
    str = "var path#{objectid} = [
      #{point_strings.join(",")}
    ];
    var parcelPath#{objectid} = new google.maps.Polygon({
      path: path#{objectid},
      geodesic: true,
      strokeColor: '#FF0000',
      strokeOpacity: 1.0,
      strokeWeight: 2,
      fillColor: '#FF0000',
      fillOpacity: 0.35
    });
    parcelPath#{objectid}.setMap(#{mapid});
    "
  end

  def to_static_map

  end

  def distance_geom
    calcs = connection.select_rows("SELECT ST_AsText(st_transform(ST_ClosestPoint(foo.parcel_geom,foo.foo.power_line_geom),4326)) AS cp_pt_line,
      	ST_AsText(st_transform(ST_ClosestPoint(foo.power_line_geom,foo.parcel_geom),4326)) As cp_line_pt
      FROM (SELECT st_transform(power_parcels.geom,3857) As parcel_geom,
      		st_transform(st_setsrid(power_lines.geom,4326),3857) as power_line_geom from power_lines, power_parcels where power_lines.id = 1 and power_parcels.id = #{id}
      	) foo;")
    # points = calcs.flatten.collect{|point| point.gsub(/[A-Z()]/i,"").split(" ")}
    # distance = (PowerLine.length(points) * 3.28084).to_i
    # point_strings = points.collect{|p| "{lat: #{p[1]},lng: #{p[0]}}"}
    # str = "var distancePath = [
    #   #{point_strings.join(",")}
    # ];
    # var distanceLine = new google.maps.Polyline({
    #   path: distancePath,
    #   geodesic: true,
    #   strokeColor: '#FFFF00',
    #   strokeOpacity: 1.0,
    #   strokeWeight: 4
    # });
    # distanceLine.setMap(#{mapid});
    # "
    # if zoomto
    #   str = str + "var bounds = new google.maps.LatLngBounds();
    #   for (var i in distancePath) {
    #     var latlng = new google.maps.LatLng(distancePath[i].lat, distancePath[i].lng);
    #     bounds.extend(latlng);
    #   }
    #   map.fitBounds(bounds);"
    # end
    # [str,distance]
  end
end
