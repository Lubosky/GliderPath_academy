feature 'User updates password' do

  let(:user) { create(:user) }

  before(:each) do
    sign_in_user(user)
    visit edit_user_registration_path(user: user)
  end

  scenario 'with valid data' do
    fill_in 'user_password', with: '123' * 3
    fill_in 'user_password_confirmation', with: '123' * 3
    fill_in 'user_current_password', with: user.password
    click_button t('button.account.update')

    expect(page).to have_css('script', text: t('devise.registrations.updated'), visible: false)
    expect(page).to have_content user.full_name
  end

  scenario 'with invalid data' do
    fill_in 'user_password', with: '123' * 3
    fill_in 'user_password_confirmation', with: '123' * 3
    fill_in 'user_current_password', with: 'lol wrong password'
    click_button t('button.account.update')

    expect(page).to have_content t('simple_form.error_notification.default_message')
  end
end
