# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shredder do
    mobile 9876543210
    area_id 1
    inches 1
    active false
    confirmed false
  end
end
