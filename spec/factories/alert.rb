
FactoryGirl.define do
  factory :alert do
    association :snow_report
    association :shredder
  end
end

