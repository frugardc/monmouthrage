class HomeController < ApplicationController
  def index
    @address = params[:address]
    @geocodes = Geocoder.search(@address)
    @result = @geocodes.first
    @power_line = PowerLine.first
    @full_url = request.original_url
    @power_parcels = Rails.cache.fetch("all_parcel_recs") do
      PowerParcel.all
    end
    if @result
      @power_line_data = @power_line.to_distance_placemark(@result.latitude,@result.longitude,true)
      @power_line_string = @power_line_data[0]
      @power_line_distance = @power_line_data[1]
    end
    @schools_data = School.all.collect{|school| [school,@power_line.to_distance_placemark(school.location.latitude,school.location.longitude)]}
    respond_to do |format|
      format.html
    end
  end
end
