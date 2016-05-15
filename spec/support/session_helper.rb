def sign_in_user(user, opts={})
  visit new_user_session_path
  fill_in t('users.email'), with: user.email
  fill_in t('users.password'), with: (opts[:password] || user.password)
  click_button t('sign_in')
end

def login(user = double('user'))
  if user.nil?
    allow(request.env['warden']).to receive(:authenticate!).and_throw(:warden, {:scope => :user})
    allow(controller).to receive(:current_user).and_return(nil)
  else
    allow(request.env['warden']).to receive(:authenticate!).and_return(user)
    allow(controller).to receive(:current_user).and_return(user)
  end
end

def login_user
  @request.env['devise.mapping'] = Devise.mappings[:user]
  user = FactoryGirl.create(:user)
  user.confirm
  sign_in(user)
end
