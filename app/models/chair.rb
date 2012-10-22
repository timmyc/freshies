class Chair < ActiveRecord::Base
  belongs_to :area
  belongs_to :sms_action
end
