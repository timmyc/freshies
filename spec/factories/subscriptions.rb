# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :subscription do
    shredder_id ""
    area_id ""
    inches ""
    type ""
    message "MyText"
  end
end