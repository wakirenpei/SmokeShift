FactoryBot.define do
  factory :quit_smoking_record do
    user
    start_date { Time.current }
  end
end