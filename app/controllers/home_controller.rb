class HomeController < ApplicationController
  def index
    @address = params[:address]
    @geocodes = Geocoder.search(@address)
    @result = @geocodes.first
    @power_line = PowerLine.first
    @full_url = request.original_url
    respond_to do |format|
      format.html
    end
  end
end
