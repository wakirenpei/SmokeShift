FactoryBot.define do
  factory :savings_goal do
    user
    quit_smoking_record
    target_amount { 10_000 }
    start_date { 1.day.ago }
    status { :active }

    trait :achieved do
      status { :achieved }
      achieved_at { Time.current }
    end
  end
end
