FactoryBot.define do
  factory :savings_goal do
    user
    quit_smoking_record
    target_amount { 10000 }
    start_date { Time.current - 1.day }
    status { :active }

    trait :achieved do
      status { :achieved }
      achieved_at { Time.current }
    end
  end
end