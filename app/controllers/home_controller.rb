class HomeController < ApplicationController

  def index
    get_map_data
    @show = ''
  end

  def show
    Rails.logger.info "ID #{request.original_url}"
    get_map_data
    @show = Endorsement.find params[:id]
    render 'index'
  end

  private

    def get_map_data
      @voted = cookies[:voted]
      @candidates = Candidate.all.order 'id'
      @buildings = Building.with_endorsements.map {|b| b.to_json(methods: [:lat,:lng]) } 
      @building = Building.new
      @endorsement = Endorsement.new
      @endorsement.build_user
      @client_ip = request.remote_ip
    end
end
