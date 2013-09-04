class HomeController < ApplicationController

  def index
    @voted = cookies[:voted]
    @buildings = Building.with_endorsements.map {|b| b.to_json(methods: [:lat,:lng]) } 
    @building = Building.new
    @endorsement = Endorsement.new
    @endorsement.build_user
    @client_ip = request.remote_ip
  end
end
