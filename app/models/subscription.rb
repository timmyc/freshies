class Subscription < ActiveRecord::Base
  belongs_to :area
  belongs_to :shredder
  has_many :alerts
  scope :for_inches_area, lambda{|inches,area_id| where("active = ? and area_id = ? and inches <= ?",true,area_id,inches)}
  validates_presence_of :message
  attr_accessible :area_id, :inches, :message, :active, :intro, :gender, :hour
end
