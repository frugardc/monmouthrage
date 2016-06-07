class HomeController < ApplicationController
  def index
    @address = params[:address]
    @geocodes = Geocoder.search(@address)
    @result = @geocodes.first

    respond_to do |format|
      format.html
    end
  end
end
