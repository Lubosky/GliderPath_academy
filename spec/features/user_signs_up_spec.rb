feature 'User signs up' do

  let(:first_name) { 'John' }
  let(:last_name) { 'Doe' }
  let(:user_email) { 'john@example.com' }
  let(:user_password) { 'secure123!@#' }

  context 'with valid data' do
    before :each do
      visit new_user_registration_path
      fill_in 'user_first_name', with: first_name
      fill_in 'user_last_name', with: last_name
      fill_in 'user_email', with: user_email, match: :first
      fill_in 'user_password', with: user_password, match: :first
      click_button t('button.account.create')
    end

#    it 'shows message about confirmation email' do
#      expect(page).to have_css('script', text: t('devise.registrations.signed_up_but_unconfirmed'), visible: false)
#    end
#
#    describe 'confirmation email' do
#
#    include EmailSpec::Helpers
#    include EmailSpec::Matchers
#
#      # Open the most recent email sent to user_email
#      subject { open_email(user_email) }
#
#      # Verify email details
#      it {
#        is_expected.to deliver_to(user_email)
#        is_expected.to have_body_text(/You can confirm your account/)
#        is_expected.to have_body_text(/users\/confirmation\?confirmation/)
#        is_expected.to have_subject(/Confirmation instructions/)
#      }
#    end
#
#    context 'when clicking confirmation link in email' do
#      before :each do
#        open_email(user_email)
#        current_email.click_link 'Confirm my account'
#      end
#
#      it 'shows confirmation message' do
#        expect(page).to have_css('script', text: t('devise.confirmations.confirmed'), visible: false)
#      end
#
#      it 'confirms user' do
#        user = User.find_for_authentication(email: user_email)
#        expect(user).to be_confirmed
#      end
#    end
  end

  context 'with invalid data' do

    context 'when not filling password' do
      before do
        visit new_user_registration_path
        fill_in 'user_first_name', with: first_name
        fill_in 'user_last_name', with: last_name
        fill_in 'user_email', with: '', match: :first
        fill_in 'user_password', with: user_password, match: :first
        click_button t('button.account.create')
      end

      it 'shows error message' do
        expect(page).to have_content 'can\'t be blank'
      end
    end

    context 'when password is less than 8 characters long' do
      before do
        visit new_user_registration_path
        fill_in 'user_first_name', with: first_name
        fill_in 'user_last_name', with: last_name
        fill_in 'user_email', with: '', match: :first
        fill_in 'user_password', with: '123' * 2, match: :first
        click_button t('button.account.create')
      end

      it 'shows error message' do
        expect(page).to have_content 'is too short (minimum is 8 characters)'
      end
    end
  end

end
