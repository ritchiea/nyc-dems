class ApiController < ApplicationController

  def endorsement
    endorsement = Endorsement.new(endorsement_params)
    if endorsement.save
      render json: endorsement
    end
  end

  def building
    point = RGeo::Cartesian.factory.point(params[:lon],params[:lat])
    building = Building.find_or_create_by_lonlat(point)
    if building.created_at > (Time.now-3) #this is a hack
      building.update_attributes({neighborhood: params[:hood],
                                  address: params[:address].gsub('+',' '),
                                  county: params[:county],
                                  state: 'NY'})
    end
    render json: building
  end
   
  private

    def endorsement_params
      params.require(:endorsement).permit(:candidate_id, :description, :building_id)
    end
end
