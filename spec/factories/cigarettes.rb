FactoryBot.define do
  factory :cigarette do
    association :user
    brand { "テストブランド" }
    price_per_pack { 500 }
    quantity_per_pack { 20 }
  end
end