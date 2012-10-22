class SmsAction < ActiveRecord::Base
  belongs_to :area
  belongs_to :chair

  validates_uniqueness_of :command, :scope => :area_id
end
