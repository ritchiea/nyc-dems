class HomeController < ApplicationController

  def index
    @buildings = Building.with_endorsements.map {|b| b.to_json(methods: [:lat,:lng]) } 
    @building = Building.new
    @endorsement = Endorsement.new
  end
end
