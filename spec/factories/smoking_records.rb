FactoryBot.define do
  factory :smoking_record do
    association :user
    association :cigarette

    after(:build) do |record|
      record.price_per_cigarette = record.cigarette.price_per_cigarette
      record.brand_name = record.cigarette.brand
      record.smoked_at ||= Time.current
    end
  end
end
