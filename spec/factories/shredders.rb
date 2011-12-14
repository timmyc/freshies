# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :shredder do
    mobile 9876543210
    email 'foo@bar.com'
    password 'blahblah'
    password_confirmation 'blahblah'
    area_id 1
    inches 1
    active false
    confirmed false
  end
end
