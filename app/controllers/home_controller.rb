class HomeController < ApplicationController

  def index
    Rails.logger.info "Cookie: #{cookies[:voted]}"
    @buildings = Building.with_endorsements.map {|b| b.to_json(methods: [:lat,:lng]) } 
    @building = Building.new
    @endorsement = Endorsement.new
    @client_ip = request.remote_ip
  end
end
