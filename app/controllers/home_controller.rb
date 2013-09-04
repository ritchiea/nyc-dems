class HomeController < ApplicationController

  def index
    @buildings = Building.with_endorsements.map {|b| b.to_json(methods: [:lat,:lng]) } 
    @building = Building.new
    @endorsement = Endorsement.new
    @client_ip = request.remote_ip
    Rails.logger.info "IP #{@client_ip}"
  end
end
