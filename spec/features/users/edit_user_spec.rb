feature 'Edit Account' do
  let(:user) { create(:user) }

  before(:each) do
    sign_in_user(user)
    visit edit_user_registration_path(user: user)
  end

  context 'User edits own account' do
    scenario 'with valid data' do
      fill_in 'user_first_name', with: 'Johnny'
      fill_in 'user_current_password', with: user.password
      click_button 'Update'

      expect(page).to have_css('script', text: t('devise.registrations.updated'), visible: false)
    end

    scenario 'changing the email address' do
      fill_in 'user_email', with: 'new@example.com'
      fill_in 'user_current_password', with: user.password
      click_button 'Update'

      expect(page).to have_css('script', text: t('devise.registrations.update_needs_confirmation'), visible: false)
    end

    scenario 'with invalid data' do
      fill_in 'user_first_name', with: 'Johnny'
      fill_in 'user_current_password', with: 'lol wrong password'
      click_button 'Update'

      expect(page).to have_content t('simple_form.error_notification.default_message')
    end
  end
end
