FactoryGirl.define do
  factory :snow_report do
    snowfall_twelve 2
    report_time Time.now
    association :area
  end
end

