class HomeController < ApplicationController
  def index
    @address = params[:address]
    @geocodes = Geocoder.search(@address)
    @result = @geocodes.first
    @power_line = PowerLine.first
    @full_url = request.original_url
    if @result
      @power_line_data = @power_line.to_distance_placemark(@result.latitude,@result.longitude)
      @power_line_string = @power_line_data[0]
      @power_line_distance = @power_line_data[1]
    end
    respond_to do |format|
      format.html
    end
  end
end
