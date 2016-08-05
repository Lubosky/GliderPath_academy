require 'spec_helper'

RSpec.describe ForumSessionsController, type: :controller do
  include CurrentUserHelper

  describe '#new' do
    context 'when user logged in' do
      it 'properly redirects to the forum' do
        user = create(:user)
        confirm_and_login_user_with(user)
        stub_current_user_with(user)
        discourse_sso = discourse_sso_stub
        allow(DiscourseSignOn).to receive(:parse).and_return(discourse_sso)

        get :new, params: { sso: 'ssohash', sig: 'sig' }

        expect(DiscourseSignOn).to have_received(:parse).with(
          'sig=sig&sso=ssohash',
          ENV['DISCOURSE_SSO_SECRET']
        )
        expect(response).to redirect_to(
          discourse_sso.to_url(
            Forum.sso_url
          )
        )
        expect(discourse_sso).to have_received(:email=).with(user.email)
        expect(discourse_sso).to have_received(:name=).with(user.name)
        expect(discourse_sso).to have_received(:username=).with(
          user.email
        )
        expect(discourse_sso).to have_received(:external_id=).with(user.id)
        expect(discourse_sso).to have_received(:sso_secret=).with(
          ENV['DISCOURSE_SSO_SECRET']
        )
        expect(analytics).to(
          have_tracked('Logged into Forum').
          for_user(user)
        )
      end
    end

    def confirm_and_login_user_with(user)
      user.confirm
      login user
    end

    def discourse_sso_stub
      sso = double('DiscourseSignOn')
      [:email, :name, :username, :external_id, :sso_secret].each do |accessor|
        allow(sso).to receive(:"#{accessor}=")
      end
      allow(sso).to receive(:to_url).and_return('https://forum.example.com')
      sso
    end
  end
end
