def sign_in_user(user, opts={})
  visit new_user_session_path
  fill_in t('users.email'), with: user.email
  fill_in t('users.password'), with: (opts[:password] || user.password)
  click_button t('sign_in')
end
