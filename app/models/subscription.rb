class Subscription < ActiveRecord::Base
  belongs_to :area
  belongs_to :shredder
  scope :for_inches_area, lambda{|inches,area_id| where("active = ? and area_id = ? and inches <= ?",true,area_id,inches)}
end
