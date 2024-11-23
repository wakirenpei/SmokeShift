require 'rails_helper'

RSpec.describe Cigarette, type: :model do
  describe 'バリデーション' do
    let(:cigarette) { build(:cigarette) }

    it '有効な属性値の場合は有効である' do
      expect(cigarette).to be_valid
    end
  end

  describe 'メソッド' do
    let(:cigarette) { create(:cigarette, price_per_pack: 500, quantity_per_pack: 20) }

    it '1本あたりの価格が計算できる' do
      expect(cigarette.price_per_cigarette).to eq 25
    end
  end
end
