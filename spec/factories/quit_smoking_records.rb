FactoryBot.define do
  factory :quit_smoking_record do
    user
    start_date { 2.days.ago }

    trait :completed do
      end_date { Time.current }
    end

    trait :with_smoking_records do
      after(:build) do |record|
        create(:smoking_record, user: record.user, price_per_cigarette: 25,
                                smoked_at: 3.days.ago)
        create(:smoking_record, user: record.user, price_per_cigarette: 25,
                                smoked_at: 4.days.ago)
      end
    end
  end
end
