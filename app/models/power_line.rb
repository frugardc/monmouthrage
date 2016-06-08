class PowerLine < ActiveRecord::Base
  GEO_FACTORY = RGeo::Geographic.spherical_factory(srid: 4326)
  set_rgeo_factory_for_column :geom, GEO_FACTORY
  default_scope :select => "*,st_astext(geom) as wkt"
  def to_placemark(mapid="map")
    points = wkt.to_s.gsub(/[A-Z()]/i,"").split(",").collect{|p| p.split(" ")}
    point_strings = points.collect{|p| "{lat: #{p[1]},lng: #{p[0]}}"}
    str = "var path = [
      #{point_strings.join(",")}
    ];
    var powerPath4 = new google.maps.Polyline({
      path: path,
      geodesic: true,
      strokeColor: '#00FFFF',
      strokeOpacity: 1.0,
      strokeWeight: 18
    });
    var powerPath = new google.maps.Polyline({
      path: path,
      geodesic: true,
      strokeColor: '#FF0000',
      strokeOpacity: 1.0,
      strokeWeight: 10
    });
    var powerPath2 = new google.maps.Polyline({
      path: path,
      geodesic: true,
      strokeColor: '#FFFF00',
      strokeOpacity: 1.0,
      strokeWeight: 6
    });
    var powerPath3 = new google.maps.Polyline({
      path: path,
      geodesic: true,
      strokeColor: '#00FFFF',
      strokeOpacity: 1.0,
      strokeWeight: 2
    });
    powerPath.setMap(#{mapid});
    powerPath2.setMap(#{mapid});
    powerPath3.setMap(#{mapid});
    powerPath4.setMap(#{mapid});"
  end

  def to_distance_placemark(lat,lng,zoomto=false,mapid="map")
    calcs = connection.select_rows("SELECT ST_AsText(st_transform(ST_ClosestPoint(foo.pt,foo.geom),4326)) AS cp_pt_line,
      	ST_AsText(st_transform(ST_ClosestPoint(foo.geom,foo.pt),4326)) As cp_line_pt
      FROM (SELECT st_transform(ST_PointFromText('POINT(#{lng} #{lat})',4326),3857) As pt,
      		st_transform(st_setsrid(geom,4326),3857) as geom from power_lines where power_lines.id = 1
      	) foo;")
    points = calcs.flatten.collect{|point| point.gsub(/[A-Z()]/i,"").split(" ")}
    distance = (PowerLine.length(points) * 3.28084).to_i
    point_strings = points.collect{|p| "{lat: #{p[1]},lng: #{p[0]}}"}
    str = "var distancePath = [
      #{point_strings.join(",")}
    ];
    var distanceLine = new google.maps.Polyline({
      path: distancePath,
      geodesic: true,
      strokeColor: '#FFFF00',
      strokeOpacity: 1.0,
      strokeWeight: 4
    });
    distanceLine.setMap(#{mapid});
    "
    if zoomto
      str = str + "var bounds = new google.maps.LatLngBounds();
      for (var i in distancePath) {
        var latlng = new google.maps.LatLng(distancePath[i].lat, distancePath[i].lng);
        bounds.extend(latlng);
      }
      map.fitBounds(bounds);"
    end
    [str,distance]
  end

  def self.length(points)
    connection.select_rows("select st_length(st_transform(ST_GeomFromText('LINESTRING(#{points[0][0]} #{points[0][1]},#{points[1][0]} #{points[1][1]})',4326),2163))").flatten.first.to_f
  end
end
