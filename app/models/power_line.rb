class PowerLine < ActiveRecord::Base

  def to_placemark(mapid="map")
    points = geom.to_s.gsub(/[A-Z()]/i,"").split(",").collect{|p| p.split(" ")}
    point_strings = points.collect{|p| "{lat: #{p[1]},lng: #{p[0]}}"}
    str = "var path = [
      #{point_strings.join(",")}
    ];
    var powerPath = new google.maps.Polyline({
      path: path,
      geodesic: true,
      strokeColor: '#FF0000',
      strokeOpacity: 1.0,
      strokeWeight: 6
    });

    powerPath.setMap(#{mapid});"
  end

  def to_distance_placemark(lat,lng,mapid="map")
    calcs = connection.select_rows("SELECT ST_AsText(ST_ClosestPoint(foo.pt,foo.geom)) AS cp_pt_line,
      	ST_AsText(ST_ClosestPoint(foo.geom,foo.pt)) As cp_line_pt
      FROM (SELECT ST_PointFromText('POINT(#{lng} #{lat})',4326) As pt,
      		geom from power_lines where power_lines.id = 1
      	) foo;")
    points = calcs.flatten.collect{|point| point.gsub(/[A-Z()]/i,"").split(" ")}
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
    var bounds = new google.maps.LatLngBounds();
    for (var i in distancePath) {
      var latlng = new google.maps.LatLng(distancePath[i].lat, distancePath[i].lng);
      bounds.extend(latlng);
    }
    map.fitBounds(bounds);"
  end
end
