class Shredder < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :area_id, :inches, :mobile, :confirmed, :active
  validates_presence_of :area_id, :inches
  validates_presence_of :mobile, :if => :should_validate_mobile
  validates_length_of :mobile, :is => 10, :if => :should_validate_mobile
  validates_numericality_of :inches
  belongs_to :area
  has_many :alerts
  has_many :subscriptions
  has_many :text_subscriptions
  has_many :voice_subscriptions
  has_many :android_subscriptions
  before_create :create_confirmation_code
  validates_uniqueness_of :mobile, :scope => :area_id
  scope :notices_for, lambda{|inches,area_id| where("area_id = ? and inches <= ?",area_id,inches)}
  GREETS = ['SICKBURD','Gaper','Powderpuff','Powstar','Child of Ullr','Brah','Bro','Gnarsef','Brosef','Sickter','Shredder','Gaper Gapper','Shredhead','Freshie Fiend','Snow Bunny','Snow Angel','Conehead']
  DEFAULT_MESSAGE = 'FRESHIEZ! {{area}} is reporting {{new_snow}}" of new snow. Base Temp: {{base_temp}}. Reported At: {{report_time}}'

  def self.find_or_create_from_android(params)
    shredder = self.find_by_gcm_id(params[:gcm_id])
    if !shredder
      gcm_id = params[:gcm_id]
      shredder = self.new
      shredder.email =  "#{gcm_id}@conepatrol.com"
      shredder.password = gcm_id[0..8]
      shredder.password_confirmation = gcm_id[0..8]
      shredder.gcm_id = gcm_id
      shredder.area_id = params[:area_id]
      shredder.inches = params[:inches]
      shredder.save
      shredder.android_subscriptions.create(:inches => shredder.inches, :area_id => shredder.area_id, :active => true, :message => DEFAULT_MESSAGE)
    end
    return shredder
  end

  def should_validate_mobile
    !gcm_id
  end

  def send_confirmation
    Twilio.connect(Cone::Application.config.twilio_sid, Cone::Application.config.twilio_auth)
    Twilio::Sms.message(Cone::Application.config.twilio_number, self.mobile, "conepatrol.com/confirm confirmation code: #{self.confirmation_code}")
  end

  def mobile_confirm
    return true if self.confirmed
    self.update_attributes(:active => true, :confirmed => true)
    self.text_subscriptions.create(:inches => self.inches, :area_id => self.area_id, :active => true, :message => DEFAULT_MESSAGE)
  end

  def random_name
    GREETS[rand(GREETS.size)]
  end

  def active_subscriptions
    self.subscriptions.find(:all, :conditions => {:active => true})
  end

  def chimp
    h = Hominid::API.new(Cone::Application.config.mail_chimp_token)
    h.list_subscribe(Cone::Application.config.mail_chimp_list, self.email,{},'text', false, true, true, false)
  end
  
  private

  def create_confirmation_code
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    self.confirmation_code = (0...4).map{ charset.to_a[rand(charset.size)] }.join
    send_confirmation if should_validate_mobile
  end
end
