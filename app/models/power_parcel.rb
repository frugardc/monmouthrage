class PowerParcel < ActiveRecord::Base
  require 'open-uri'
  GEO_FACTORY = RGeo::Geographic.spherical_factory(srid: 4326)
  set_rgeo_factory_for_column :geom, GEO_FACTORY
  default_scope :select => "*,st_astext(geom) as wkt"
  self.primary_key = :objectid
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
      strokeOpacity: 0.75,
      strokeWeight: 1,
      fillColor: '#FF0000',
      fillOpacity: 0.15
    });
    parcelPath#{objectid}.setMap(#{mapid});
    "
  end

  def self.all_placemarks
    all_string = Rails.cache.fetch("all_parcels_placemark_js") do
      str = ""
      all.each do |parcel|
        str = str + parcel.to_placemark
      end
      str
    end
    all_string
  end

  def calcs
    connection.select_rows("SELECT ST_AsText(st_transform(ST_ClosestPoint(st_transform(power_parcels.geom,3857),st_transform(st_setsrid(power_lines.geom,4326),3857)),4326)) AS cp_pt_line,
        ST_AsText(st_transform(ST_ClosestPoint(st_transform(st_setsrid(power_lines.geom,4326),3857),st_transform(power_parcels.geom,3857)),4326)) As cp_line_pt
      FROM
        power_parcels
        join power_lines on
        power_parcels.objectid = #{objectid} and power_lines.id = 1")
  end

  def distance
    distance_points = calcs.flatten.collect{|point| point.gsub(/[A-Z()]/i,"").split(" ")}
    distance = (PowerLine.length(distance_points) * 3.28084).to_i
  end

  def distance_image
    points = calcs.flatten.collect{|point| point.gsub(/[A-Z()]/i,"").split(" ")}.collect{|pair| pair.reverse.join(",")}.join("|")
    image_path = "http://maps.googleapis.com/maps/api/staticmap?size=400x400&path=#{points}&sensor=false&zoom=18"
    # points = calcs.flatten.collect{|point| point.gsub(/[A-Z()]/i,"").split(" ")}

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

  def owners
    owner16.to_s.split(",").reverse.join(" ")
  end

  def pdf_letter
    pdf = Prawn::Document.new
    pdf.text "Dear #{owners},


      I am writing to inform you of important events taking place locally that will greatly affect the health,
      value, and standard of living at your property at #{propertylocation} in #{citystatezip.split(',')[0]}.  JCP&L is planning on installing 140-210 foot tall 'monopole' style towers along the NJ Transity Rail line
      from Aberdeen to Red Bank.  These are so tall that they will be visible for MILES on either side.
      There are many studies that link living near these power lines with increased risk of childhood cancer.
      They will tower over everything in our area.  They are as little as 100 feet from elementary schools,
      parks, churches and preschools.  Due to all of these factors, properties in the vicinity of these lines will lose tens of thousands of dollars in value
      overnight and our residents will be exposed to ElectroMagnetic Fields (EMF's), the risks of which are not yet fully understood.

      YOUR HOME LIES A MERE
      #{distance} FEET
      FROM THESE DAMAGING
      EYESORES!
      "
      pdf.image  open(URI.encode(distance_image)), :width => 150, :at => [170,550]
      pdf.text "
      That's the bad news.

      Here is the good news.

      There is still time to stop this madness.  JCP&L is about to apply for the permits to begin work.  You can
      join the fight.  Join the Facebook Group.  Call the Mayor.  Call your representatives.  Spread the word.  Talk to your neighbors.  Unless we make a stand, JCP&L will make
      and eyesore out of our beautiful towns in the name of unimpeded progress.  Many of us are unwilling to allow that to happen.  Will you join the fight?
    "

    pdf.move_down 20
    pdf.render_file("test.pdf")
  end
end
