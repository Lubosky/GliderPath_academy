feature 'User signs up' do

  let(:first_name) { 'John' }
  let(:last_name) { 'Doe' }
  let(:user_email) { 'john@example.com' }
  let(:user_password) { 'secure123!@#' }

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
