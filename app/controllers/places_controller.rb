class PlacesController < ApplicationController
  def index
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:city] = params[:city]
      render :index
    end
  end

  def show
    places = BeermappingApi.places_in(session[:city])
    @place = places.find{|a| a.id == params[:id]}
  end
end