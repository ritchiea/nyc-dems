class Endorsement < ActiveRecord::Base
  belongs_to :building
  accepts_nested_attributes_for :building
end
