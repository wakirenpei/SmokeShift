module SorceryHelper
  def login_user(user)
    post login_path, params: { 
      email: user.email, 
      password: 'password123'
    }
  end

  def login_as_system_user(user)
    visit login_path
    fill_in 'email', with: user.email
    fill_in 'password', with: 'password123'
    click_button 'ログイン'
  end
end

RSpec.configure do |config|
  config.include SorceryHelper, type: :request
  config.include SorceryHelper, type: :system
end