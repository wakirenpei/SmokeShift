FactoryBot.define do
  factory :graph_record, class: SmokingRecord do
    association :user
    association :cigarette
    smoked_at { Time.current }
    price_per_cigarette { 25 }
    brand_name { "テストブランド" }
  end
end