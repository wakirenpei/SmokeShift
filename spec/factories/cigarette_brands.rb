FactoryBot.define do
  factory :cigarette_brand do
    sequence(:name) { |n| "ブランド#{n}" }
    price_per_pack { 500 }
    quantity_per_pack { 20 }
  end
end