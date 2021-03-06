class ApiController < ApplicationController

  def new_endorsement
    endorsement = Endorsement.new(endorsement_params)
    if endorsement.save
      endorsement.user.destroy if ( endorsement.user.present? && endorsement.user_invalid? )
      render json: endorsement
    end
  end

  def edit_endorsement
    if user = User.authenticate(params[:email], params[:password])
      user.endorsement.update_attributes endorsement_params
      render json: user
    end
  end

  def get_endorsements
    endorsements = Building.find(params[:building_id]).endorsements
    if endorsements
      render json: endorsements.to_json(methods: [:name, :photo_url ])
    end
  end

  def building
    point = RGeo::Cartesian.factory.point(params[:lon],params[:lat])
    building = Building.find_or_create_by_lonlat(point)
    if building.created_at > (Time.now-3) #this is a hack
      building.update_attributes({neighborhood: params[:hood],
                                  address: params[:address],
                                  county: params[:county],
                                  state: 'NY'})
    end
    render json: building
  end
  
  def get_buildings
    buildings = Building.with_endorsements.map {|b| b.to_json(methods: [:lat,:lng]) } 
    render json: buildings
  end 
  private

    def endorsement_params
      params.require(:endorsement).permit(:candidate_id, :description, :building_id, :ip_address, 
                                          user_attributes: [:email, :password])
    end
end
