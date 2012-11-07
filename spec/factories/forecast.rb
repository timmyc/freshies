FactoryGirl.define do
  factory :forecast do
    snowfall '2-4"'
    snowfall_min 2
    snowfall_max 4
    association :area
  end
end

