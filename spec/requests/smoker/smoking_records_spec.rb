RSpec.describe '喫煙記録管理', type: :request do
  let(:user) { create(:user) }
  let(:cigarette) { create(:cigarette, user: user) }

  before { login_user(user) }

  describe '喫煙記録の作成' do
    let(:valid_params) { { smoking_record: { cigarette_id: cigarette.id } } }

    context '正常系' do
      it '喫煙記録が作成されること' do
        expect do
          post smoker_smoking_records_path, params: valid_params
        end.to change(SmokingRecord, :count).by(1)
      end

      it 'リダイレクトされること' do
        post smoker_smoking_records_path, params: valid_params
        expect(response).to redirect_to smoker_smoking_records_path
      end

      it '成功メッセージが表示されること' do
        post smoker_smoking_records_path, params: valid_params
        expect(flash[:notice]).to eq '喫煙記録が追加されました。'
      end
    end

    context '無効な場合' do
      let(:invalid_params) { { smoking_record: { cigarette_id: nil } } }

      it '喫煙記録が作成されないこと' do
        expect do
          post smoker_smoking_records_path, params: invalid_params
        end.not_to change(SmokingRecord, :count)
      end

      it 'リダイレクトされること' do
        post smoker_smoking_records_path, params: invalid_params
        expect(response.status).to eq(302)
      end

      it 'エラーメッセージが表示されること' do
        post smoker_smoking_records_path, params: invalid_params
        expect(flash[:alert]).to eq '喫煙記録の追加に失敗しました。'
      end
    end

    context '禁煙中の場合' do
      before { create(:quit_smoking_record, user: user, start_date: Time.zone.now) }

      it '喫煙記録が作成されないこと' do
        expect do
          post smoker_smoking_records_path, params: valid_params
        end.not_to change(SmokingRecord, :count)
      end

      it 'リダイレクトされること' do
        post smoker_smoking_records_path, params: valid_params
        expect(response).to redirect_to(smoker_smoking_records_path)
      end

      it '禁煙中エラーメッセージが表示されること' do
        post smoker_smoking_records_path, params: valid_params
        expect(flash[:alert]).to eq '禁煙中は喫煙記録を追加できません。禁煙を終了してから記録してください。'
      end
    end
  end

  describe '喫煙記録の削除' do
    let!(:smoking_record) { create(:smoking_record, user: user, cigarette: cigarette) }

    it '喫煙記録が削除されること' do
      expect do
        delete smoker_smoking_record_path(smoking_record)
      end.to change(SmokingRecord, :count).by(-1)
    end

    it 'リダイレクトされること' do
      delete smoker_smoking_record_path(smoking_record)
      expect(response).to redirect_to smoker_smoking_records_path
    end

    it '成功メッセージが表示されること' do
      delete smoker_smoking_record_path(smoking_record)
      expect(flash[:notice]).to eq '喫煙記録が削除されました。'
    end
  end
end
