FactoryBot.define do
  factory :authentication do
    user
    provider { 'line' }
    sequence(:uid) { |n| "uid_#{n}" }
  end
end