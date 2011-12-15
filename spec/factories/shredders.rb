# Read about factories at http://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :shredder do
    sequence(:mobile){ |n| "8#{n}76543210"[0..9] }
    sequence(:email) { |n| "persion#{n}@example.com" }
    password 'blahblah'
    password_confirmation 'blahblah'
    area_id 1
    inches 1
    active false
    confirmed false
  end
end
