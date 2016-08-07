feature 'User updates email' do

  let(:user) { create(:user) }

  before(:each) do
    sign_in_user(user)
    visit edit_user_registration_path(user: user)
  end

  scenario 'while account is not confirmed' do
    fill_in 'user_email', with: 'new@example.com'
    fill_in 'user_current_password', with: user.password
    click_button t('button.account.update')

    expect(page).to have_css('script', text: t('devise.registrations.update_needs_confirmation'), visible: false)
  end
end
