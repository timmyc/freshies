# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :voice_subscription do
    shredder_id ""
    area_id ""
    inches ""
    type ""
    intro ""
    gender "female"
    message "MyText"
  end
end
