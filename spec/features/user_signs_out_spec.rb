feature 'User signs out' do
  let(:user) { create(:user) }

  scenario 'signs out' do
    sign_in_user(user)
    expect(page).to have_css('script', text: t('devise.sessions.signed_in'), visible: false)
    click_link t('button.account.sign_out'), match: :first
    expect(page).to have_css('script', text: t('devise.sessions.signed_out'), visible: false)
  end
end
