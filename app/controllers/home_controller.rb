class HomeController < ApplicationController

  def index
    @building = Building.new
    @endorsement = Endorsement.new
  end
end
