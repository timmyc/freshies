class Area < ActiveRecord::Base
  validates_presence_of :name, :klass, :twitter
  before_create :set_api_keys
  has_many :snow_reports
  has_many :shredders

  def generate_code(size = 6)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    (0...size).map{ charset.to_a[rand(charset.size)] }.join
  end

  private

  def set_api_keys
    self.secret = self.generate_code(18)
    self.key = self.generate_code
  end

end
