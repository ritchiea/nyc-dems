class AjaxController < ApplicationController

  def endorsement

  end

  def building
    point = RGeo::Cartesian.factory.point(params[:lon],params[:lat])
    building = Building.find_or_create_by_lonlat(point)
    render json: building
  end
end
