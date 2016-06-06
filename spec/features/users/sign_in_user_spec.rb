feature 'User signs in' do
  let(:user) { create(:user) }

  scenario 'can sign in with valid credentials' do
    sign_in_user(user)
    expect(page).to have_css('script', text: t('devise.sessions.signed_in'), visible: false)
  end

  scenario 'cannot sign in with invalid credentials' do
    sign_in_user(user, password: 'wrong password')
    expect(page).to have_css('script', text: t('devise.failure.invalid', authentication_keys: 'Email'), visible: false)
  end
end
