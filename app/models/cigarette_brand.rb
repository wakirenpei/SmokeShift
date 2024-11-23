class CigaretteBrand < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price_per_pack, presence: true, numericality: { greater_than: 0 }
  validates :quantity_per_pack, presence: true, numericality: { greater_than: 0 }

  scope :search_by_name, ->(query) { where('name ILIKE ?', "%#{query}%") }
  scope :select_brand_details, -> { select(:id, :name, :price_per_pack, :quantity_per_pack) }
end
