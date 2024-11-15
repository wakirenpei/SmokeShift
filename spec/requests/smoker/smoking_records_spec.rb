RSpec.describe '喫煙記録管理', type: :request do
  let(:user) { create(:user) }
  let(:cigarette) { create(:cigarette, user: user) }
  
  before { login_user(user) }

  describe '喫煙記録の作成' do
    let(:valid_params) { { smoking_record: { cigarette_id: cigarette.id } } }

    it '喫煙記録を作成できる' do
      expect {
        post smoker_smoking_records_path, params: valid_params
      }.to change(SmokingRecord, :count).by(1)
      expect(response).to redirect_to smoker_smoking_records_path
      expect(flash[:notice]).to eq '喫煙記録が追加されました。'
    end

    it '無効な喫煙記録の場合は作成されないこと' do
      invalid_params = { smoking_record: { cigarette_id: nil } }
      expect {
        post smoker_smoking_records_path, params: invalid_params
      }.not_to change(SmokingRecord, :count)
      expect(response.status).to eq(302)
      expect(flash[:alert]).to eq '喫煙記録の追加に失敗しました。'
    end

    it '禁煙中は喫煙記録が作成されないこと' do
      create(:quit_smoking_record, user: user, start_date: Time.current)
      expect {
        post smoker_smoking_records_path, params: valid_params
      }.not_to change(SmokingRecord, :count)
      expect(response).to redirect_to(smoker_smoking_records_path)
      expect(flash[:alert]).to eq '禁煙中は喫煙記録を追加できません。禁煙を終了してから記録してください。'
    end
  end

  describe '喫煙記録の削除' do
    let!(:smoking_record) { create(:smoking_record, user: user, cigarette: cigarette) }

    it '喫煙記録を削除できる' do
      expect {
        delete smoker_smoking_record_path(smoking_record)
      }.to change(SmokingRecord, :count).by(-1)
      expect(response).to redirect_to smoker_smoking_records_path
      expect(flash[:notice]).to eq '喫煙記録が削除されました。'
    end
  end
end
