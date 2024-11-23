RSpec.describe 'SavingsGoals', type: :request do
  let(:user) { create(:user) }
  let(:quit_smoking_record) do
    create(:quit_smoking_record, :with_smoking_records, user: user, start_date: Time.current)
  end

  before do
    login_user user
  end

  describe '目標の作成' do
    context '禁煙記録がある場合' do
      before { quit_smoking_record }

      it '新しい目標を作成したとき、リダイレクトされること' do
        post non_smoker_savings_goals_path, params: {
          savings_goal: {
            target_amount: 10_000
          }
        }
        expect(response).to redirect_to(non_smoker_savings_goals_path)
      end

      it '新しい目標を作成したとき、フラッシュメッセージが表示されること' do
        post non_smoker_savings_goals_path, params: {
          savings_goal: {
            target_amount: 10_000
          }
        }
        expect(flash[:notice]).to eq '貯金目標を設定しました'
      end
    end
  end
end
