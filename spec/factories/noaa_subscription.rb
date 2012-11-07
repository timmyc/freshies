# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :noaa_subscription do
    shredder_id ""
    area_id ""
    inches ""
    message 'SICK DAY! NOAA is forecast {{forecast}} in the next 24 hours!'
  end
end
