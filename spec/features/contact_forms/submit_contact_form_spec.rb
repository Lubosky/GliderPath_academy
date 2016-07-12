feature 'Submit Contact Form' do

  let(:name) { 'John Doe' }
  let(:user_email) { 'john@example.com' }
  let(:subject) { 'Sample subject' }
  let(:message) { 'Sample message' }

  before :each do
    visit contact_path
  end

  context 'with valid data' do
    before :each do
      fill_in 'contact_form_name', with: name
      fill_in 'contact_form_email', with: user_email
      fill_in 'contact_form_subject', with: subject
      fill_in 'contact_form_message', with: message
      click_button t('button.contact_form.send')
    end

    it 'shows message about email being sent' do
      expect(page).to have_css('script', text: t('flash.contact_form.success'), visible: false)
    end

  end

  context 'with invalid data' do
    before do
      fill_in 'contact_form_name', with: name
      fill_in 'contact_form_email', with: 'john@example'
      fill_in 'contact_form_subject', with: subject
      fill_in 'contact_form_message', with: message
      click_button t('button.contact_form.send')
    end

    it 'shows message about email being sent' do
      expect(page).to have_css('script', text: t('flash.contact_form.error'), visible: false)
    end
  end

  context 'with missing data' do
    before do
      fill_in 'contact_form_name', with: name
      fill_in 'contact_form_email', with: user_email
      click_button t('button.contact_form.send')
    end

    it 'shows error message' do
      expect(page).to have_css('script', text: t('flash.contact_form.error'), visible: false)
    end
  end

end
