class Shredder < ActiveRecord::Base
  validates_presence_of :mobile, :area_id, :inches
  validates_length_of :mobile, :is => 10
  validates_numericality_of :inches
  belongs_to :area
  before_create :create_confirmation_code
  validates_uniqueness_of :mobile, :scope => :area_id
  after_create :send_confirmation

  def send_confirmation
    Twilio.connect('AC562c96a151e4a10786c007ee149b37d1', '1c88dc7566c0201e970a5d5825ba079d')
    Twilio::Sms.message("+15415267770", self.mobile, "conepatrol.com confirmation code: #{self.confirmation_code}")
  end

  def confirm
    self.update_attributes(:active => true, :confirmed => true)
  end
  
  private

  def create_confirmation_code
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    self.confirmation_code = (0...4).map{ charset.to_a[rand(charset.size)] }.join.downcase
  end
end
