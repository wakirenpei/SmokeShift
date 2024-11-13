RSpec.describe '禁煙記録管理', type: :request do
  let(:user) { create(:user) }
  let(:quit_smoking_record) { create(:quit_smoking_record, user: user) }

  before do
    login_user(user)
  end

  describe '禁煙開始' do
    it '喫煙記録がある場合、禁煙を正常に開始できること' do
      create(:smoking_record, user: user)
      post non_smoker_quit_smoking_records_path
      expect(response).to redirect_to(non_smoker_quit_smoking_records_path)
      expect(flash[:notice]).to eq '禁煙を開始しました。頑張りましょう！'
    end

    it '喫煙記録がない場合、禁煙を開始できずエラーメッセージが表示されること' do
      post non_smoker_quit_smoking_records_path
      expect(response).to redirect_to(smoker_smoking_records_path)
      expect(flash[:alert]).to eq '喫煙記録がないため、禁煙を開始できません。'
    end
  end

  describe '禁煙終了' do
    it '禁煙を正常に終了できること' do
      patch non_smoker_quit_smoking_record_path(quit_smoking_record)
      expect(response).to redirect_to(smoker_smoking_records_path)
      expect(flash[:notice]).to eq '禁煙を終了します。お疲れ様でした！'
    end
  end
end